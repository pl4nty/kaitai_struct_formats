#!/usr/bin/env python3
"""Sample-file regression tests for the .ksy formats in this repository.

Each manifest under ``_test/samples/<path>.yml`` describes real-world sample
files for the spec at ``<path>.ksy``. For each sample the runner:

1. downloads the file (cached by SHA-256) and verifies its hash,
2. optionally extracts the bytes to parse from a container (``extract``),
3. compiles the spec to Python with ``ksc`` (once per spec),
4. parses the sample in a subprocess with a timeout,
5. optionally forces every lazy ``instances`` value (``deep``),
6. checks optional ``expect`` assertions and ``eof``.

See ``_test/README.md`` for the manifest schema.
"""

import argparse
import base64
import bz2
import collections
import concurrent.futures
import fnmatch
import gzip
import hashlib
import http.client
import io
import json
import lzma
import os
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import threading
import time
import urllib.error
import urllib.request
import xml.etree.ElementTree as ET
import zipfile
from typing import NamedTuple

import yaml

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SAMPLES_DIR = os.path.join(REPO, "_test", "samples")
WORKER = os.path.join(REPO, "_test", "parse_worker.py")
# Python implementations of opaque types and custom processes that specs import
OPAQUE_DIR = os.path.join(REPO, "_test", "opaque")
MAX_DOWNLOAD = 64 * 1024 * 1024
USER_AGENT = "ksf-sample-tests/1.0"

SAMPLE_KEYS = {"url", "sha256", "data", "name", "source", "license", "extract", "deep",
               "eof", "expect", "params", "xfail", "skip", "timeout"}
EXTRACT_KEYS = {"format", "member", "offset", "size", "field", "then"}
ARCHIVES = ("zip", "tar")
EXTRACT_FORMATS = ARCHIVES + ("gzip", "bz2", "xz", "hex", "base64", "slice")
STATUSES = ("pass", "fail", "xfail", "xpass", "skip")
FAILING = ("fail", "xpass")
# everything XML 1.0 cannot represent, even escaped
XML_INVALID = re.compile("[^\t\n\r\x20-퟿-�\U00010000-\U0010ffff]")


class SpecError(Exception):
    pass


class Manifest(NamedTuple):
    path: str  # relative to SAMPLES_DIR
    spec: str  # relative to REPO, always with forward slashes
    doc: object  # parsed YAML; a dict with a 'samples' list once validated


class Build(NamedTuple):
    dir: str
    module: str
    cls: str
    errors: list


class Result(NamedTuple):
    spec: str
    name: str
    status: str
    message: str = ""
    seconds: float = 0.0


# --- manifests ---------------------------------------------------------------

def load_manifests(only=()):
    out = []
    for dirpath, _, files in os.walk(SAMPLES_DIR):
        for fn in files:
            base, ext = os.path.splitext(fn)
            if ext not in (".yml", ".yaml"):
                continue
            path = os.path.join(dirpath, fn)
            rel = os.path.relpath(path, SAMPLES_DIR)
            spec = os.path.relpath(os.path.join(dirpath, base), SAMPLES_DIR).replace(os.sep, "/") + ".ksy"
            if only and not any(fnmatch.fnmatch(spec, p) for p in only):
                continue
            try:
                with open(path, encoding="utf-8") as f:
                    doc = yaml.safe_load(f)
            except (OSError, UnicodeDecodeError, yaml.YAMLError) as e:
                doc = e  # reported by validate()
            out.append(Manifest(rel, spec, doc))
    return sorted(out, key=lambda m: m.path)


def sample_name(sample):
    if sample.get("name"):
        return str(sample["name"])
    if "data" in sample and "url" not in sample:
        return "data"
    return str(sample.get("url", "?")).rstrip("/").rsplit("/", 1)[-1]


def validate(manifest):
    rel, spec, doc = manifest
    if isinstance(doc, Exception):
        return [f"{rel}: cannot load: {' '.join(str(doc).split())}"]
    errs = []
    if not os.path.isfile(os.path.join(REPO, spec)):
        errs.append(f"{rel}: no spec at {spec}")
    samples = doc.get("samples") if isinstance(doc, dict) else None
    if not isinstance(samples, list) or not samples:
        errs.append(f"{rel}: 'samples' must be a non-empty list")
        return errs
    seen = set()
    for i, s in enumerate(samples):
        where = f"{rel}: samples[{i}]"
        if not isinstance(s, dict):
            errs.append(f"{where}: must be a mapping")
            continue
        errs += [f"{where}: unknown key '{k}'" for k in s if k not in SAMPLE_KEYS]
        if "data" in s:
            if "url" in s or "sha256" in s or "extract" in s:
                errs.append(f"{where}: 'data' excludes 'url', 'sha256' and 'extract'")
            if not (isinstance(s["data"], str) and re.fullmatch(r"(?:\s*[0-9a-fA-F]{2})*\s*", s["data"])):
                errs.append(f"{where}: 'data' must be a string of hex byte pairs")
        else:
            if not str(s.get("url", "")).startswith("https://"):
                errs.append(f"{where}: 'url' must be https")
            if not re.fullmatch("[0-9a-f]{64}", str(s.get("sha256", ""))):
                errs.append(f"{where}: 'sha256' must be 64 lowercase hex chars")
        params = s.get("params", {})
        if not (isinstance(params, dict) and all(isinstance(k, str) and isinstance(v, str)
                                                  for k, v in params.items())):
            errs.append(f"{where}: 'params' must map param id -> Python expression string")
        name = sample_name(s)
        if name in seen:
            errs.append(f"{where}: duplicate name '{name}'")
        seen.add(name)
        if not isinstance(s.get("expect", {}), dict):
            errs.append(f"{where}: 'expect' must be a mapping of expression -> value")
        for k in ("deep", "eof"):
            if not isinstance(s.get(k, False), bool):
                errs.append(f"{where}: '{k}' must be true or false")
        if not (is_number(s.get("timeout", 60)) and s.get("timeout", 60) > 0):
            errs.append(f"{where}: 'timeout' must be a positive number of seconds")
        if s.get("extract") is not None:
            errs += [f"{where}: {e}" for e in validate_extract(s["extract"], "extract")]
    return errs


def is_number(v):
    return isinstance(v, (int, float)) and not isinstance(v, bool)


def validate_extract(x, where):
    if not isinstance(x, dict) or x.get("format") not in EXTRACT_FORMATS:
        return [f"'{where}.format' must be one of: {', '.join(EXTRACT_FORMATS)}"]
    errs = [f"'{where}': unknown key '{k}'" for k in x if k not in EXTRACT_KEYS]
    if x["format"] in ARCHIVES and not isinstance(x.get("member"), str):
        errs.append(f"'{where}.member' is required for {x['format']}")
    for k in ("offset", "size"):
        if k in x and not (isinstance(x[k], int) and not isinstance(x[k], bool) and x[k] >= 0):
            errs.append(f"'{where}.{k}' must be a non-negative integer")
    if "then" in x:
        errs += validate_extract(x["then"], where + ".then")
    return errs


# --- download / extract -----------------------------------------------------

def download(url, retries=3):
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    for attempt in range(retries):
        if attempt:
            time.sleep(2 ** attempt)
        try:
            with urllib.request.urlopen(req, timeout=60) as r:
                data = r.read(MAX_DOWNLOAD + 1)
        except (OSError, http.client.HTTPException) as e:
            error = e
            # a missing or forbidden file will not appear on a second try
            if isinstance(e, urllib.error.HTTPError) and e.code < 500 and e.code not in (408, 429):
                break
        else:
            if len(data) > MAX_DOWNLOAD:
                raise SpecError(f"download exceeds {MAX_DOWNLOAD} bytes")
            return data
    raise SpecError(f"download failed: {error}")


def read_verified(path, sha256):
    """Return the contents of ``path`` if it exists and has the given hash."""
    try:
        with open(path, "rb") as f:
            data = f.read()
    except FileNotFoundError:
        return None
    return data if hashlib.sha256(data).hexdigest() == sha256 else None


def fetch(url, sha256, cache_dir):
    path = os.path.join(cache_dir, sha256)
    data = read_verified(path, sha256)
    if data is None:
        data = download(url)
        got = hashlib.sha256(data).hexdigest()
        if got != sha256:
            raise SpecError(f"sha256 mismatch: expected {sha256}, got {got}")
        # unique temp name + rename: safe against concurrent runs sharing the cache
        fd, tmp = tempfile.mkstemp(dir=cache_dir, prefix=sha256[:8] + ".")
        with os.fdopen(fd, "wb") as f:
            f.write(data)
        os.replace(tmp, path)
    return data


def extract(data, spec):
    """Apply one ``extract`` step, then any chained ``then`` steps."""
    fmt = spec["format"]
    if fmt == "slice":
        off = spec.get("offset", 0)
        end = off + spec["size"] if "size" in spec else len(data)
        if not off <= end <= len(data):
            raise SpecError(f"slice {off}..{end} is outside the {len(data)} available bytes")
        data = data[off:end]
    elif fmt == "gzip":
        data = gzip.decompress(data)
    elif fmt == "bz2":
        data = bz2.decompress(data)
    elif fmt == "xz":
        data = lzma.decompress(data)
    elif fmt == "hex":  # hex text dump; whitespace and 0x prefixes ignored
        text = data.decode("ascii", "replace").replace("0x", " ")
        data = bytes.fromhex("".join(c for c in text if c in "0123456789abcdefABCDEF"))
    elif fmt == "base64":  # e.g. an OpenSSH key/cert line: "<type> <base64> [comment]"
        text = data.decode("ascii", "replace").split()
        field = spec.get("field", 0)
        data = base64.b64decode(text[field] if text else "", validate=True)
    elif fmt == "zip":
        with zipfile.ZipFile(io.BytesIO(data)) as z:
            data = z.read(spec["member"])
    elif fmt == "tar":
        with tarfile.open(fileobj=io.BytesIO(data)) as t:
            f = t.extractfile(spec["member"])
            if f is None:
                raise SpecError(f"tar member {spec['member']!r} is not a regular file")
            data = f.read()
    else:
        raise SpecError(f"unknown extract format {fmt}")
    return extract(data, spec["then"]) if "then" in spec else data


# --- compile -----------------------------------------------------------------

def compile_spec(ksc, spec, build_root):
    out = os.path.join(build_root, spec[:-4].replace("/", "__"))
    shutil.rmtree(out, ignore_errors=True)  # stale modules from an earlier run
    os.makedirs(out)
    # --outdir, not -d: some ksc launcher scripts swallow -d as a JVM debug flag
    cmd = [ksc, "-t", "python", "--import-path", REPO, "--outdir", out, "--ksc-json-output", spec]
    try:
        p = subprocess.run(cmd, cwd=REPO, capture_output=True, text=True)
    except OSError as e:
        return Build(out, "", "", [f"cannot run {ksc}: {e}"])
    try:
        info = json.loads(p.stdout)[spec]
        errors = [f"{e.get('file')}: /{'/'.join(e.get('path') or [])}: {e.get('message')}"
                  for e in info.get("errors", [])]
        if errors:
            return Build(out, "", "", errors)
        module = info["firstSpecName"]
        return Build(out, module, info["output"]["python"][module]["topLevelName"], [])
    except (ValueError, LookupError, TypeError, AttributeError):
        return Build(out, "", "", [(p.stderr or p.stdout).strip()[-2000:] or f"ksc exited {p.returncode}"])


# --- run ---------------------------------------------------------------------

def run_worker(sample, data_path, build):
    """Parse one prepared sample in a subprocess; return (ok, error)."""
    job = {
        "module": build.module,
        "class": build.cls,
        "file": data_path,
        "deep": sample.get("deep", True),
        "eof": sample.get("eof", False),
        "expect": sample.get("expect", {}),
        "params": sample.get("params", {}),
    }
    timeout = sample.get("timeout", 60)
    pythonpath = os.pathsep.join(filter(None, [build.dir, OPAQUE_DIR, os.environ.get("PYTHONPATH")]))
    env = dict(os.environ, PYTHONPATH=pythonpath, PYTHONDONTWRITEBYTECODE="1")
    try:
        p = subprocess.run([sys.executable, WORKER], input=json.dumps(job),
                           capture_output=True, text=True, timeout=timeout, env=env)
    except subprocess.TimeoutExpired:
        return False, f"timed out after {timeout}s"
    try:
        res = json.loads(p.stdout.splitlines()[-1])
        return res["ok"], res.get("error", "")
    except (ValueError, LookupError, TypeError):  # the worker died without reporting
        return False, (p.stderr or p.stdout)[-4000:].strip() or f"worker exited {p.returncode}"


def verdict(sample, ok, error):
    """Turn a raw outcome into (status, message), honouring ``xfail``."""
    if not sample.get("xfail"):
        return ("pass" if ok else "fail"), error
    if ok:
        return "xpass", f"expected failure ({sample['xfail']}) now passes: remove xfail"
    return "xfail", error


def test_sample(spec, sample, build, cache_dir, data_dir, lock):
    """Fetch, extract and parse one sample; return (status, message, seconds)."""
    # Fetch and extract problems are infrastructure failures, never xfail-able.
    if "data" in sample:  # inline bytes: canonical test vectors, e.g. CRC check input
        data = bytes.fromhex("".join(sample["data"].split()))
    else:
        try:
            with lock:  # one download per hash, however many samples share it
                data = fetch(sample["url"], sample["sha256"], cache_dir)
        except Exception as e:
            return "fail", f"fetch: {e}", 0.0
    try:
        if sample.get("extract") is not None:
            data = extract(data, sample["extract"])
    except Exception as e:
        return "fail", f"extract: {type(e).__name__}: {e}", 0.0
    key = f"{spec}\0{sample_name(sample)}".encode()
    data_path = os.path.join(data_dir, hashlib.sha256(key).hexdigest())
    with open(data_path, "wb") as f:
        f.write(data)
    del data
    t0 = time.monotonic()
    ok, error = run_worker(sample, data_path, build)
    return (*verdict(sample, ok, error), time.monotonic() - t0)


def run(manifests, args, build_root):
    data_dir = os.path.join(build_root, "_data")
    os.makedirs(data_dir, exist_ok=True)
    os.makedirs(args.cache_dir, exist_ok=True)
    locks = {s.get("sha256"): threading.Lock() for m in manifests for s in m.doc["samples"]}
    results = []

    def record(*fields):
        r = Result(*fields)
        results.append(r)
        detail = f"\n      {r.message}" if r.message and r.status != "pass" else ""
        print(f"{r.status.upper():5} {r.spec} :: {r.name}{detail}", flush=True)

    with concurrent.futures.ThreadPoolExecutor(args.jobs) as pool:
        builds = pool.map(lambda m: compile_spec(args.ksc, m.spec, build_root), manifests)
        pending = {}
        for m, build in zip(manifests, builds):
            for s in m.doc["samples"]:
                name = sample_name(s)
                if s.get("skip"):
                    record(m.spec, name, "skip", str(s["skip"]))
                elif build.errors:
                    record(m.spec, name, *verdict(s, False, "compile error: " + "; ".join(build.errors)))
                else:
                    fut = pool.submit(test_sample, m.spec, s, build, args.cache_dir, data_dir, locks[s.get("sha256")])
                    pending[fut] = (m.spec, name)
        for fut in concurrent.futures.as_completed(pending):
            record(*pending[fut], *fut.result())
    return sorted(results)


def coverage():
    """Report sample coverage of file formats.

    Specs without ``meta.file-extension`` are mostly library types (checksums,
    integer encodings, protocol sub-structures) that are tested through the
    formats that import them, so they are listed separately.
    """
    have = {m.spec for m in load_manifests()}
    formats, libraries = [], []
    for dirpath, dirs, files in os.walk(REPO):
        dirs[:] = [d for d in dirs if not d.startswith((".", "_"))]
        for f in files:
            if not f.endswith(".ksy"):
                continue
            spec = os.path.relpath(os.path.join(dirpath, f), REPO).replace(os.sep, "/")
            try:
                with open(os.path.join(REPO, spec), encoding="utf-8") as fh:
                    meta = (yaml.safe_load(fh) or {}).get("meta") or {}
            except (OSError, UnicodeDecodeError, yaml.YAMLError, AttributeError):
                meta = {}
            (formats if meta.get("file-extension") else libraries).append(spec)
    missing = sorted(set(formats) - have)
    print(f"{len(formats) - len(missing)}/{len(formats)} file formats have samples "
          f"({len(have & set(libraries))}/{len(libraries)} other specs)")
    for m in missing:
        print("  missing:", m)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("only", nargs="*", help="glob(s) of spec paths, e.g. 'image/*.ksy'")
    ap.add_argument("--ksc", default=os.environ.get("KSC", "ksc"))
    ap.add_argument("--cache-dir", default=os.environ.get("KSF_SAMPLE_CACHE", os.path.join(REPO, "_test", ".cache")))
    ap.add_argument("--build-dir", help="keep generated parsers and extracted samples here "
                                        "(default: a temporary directory, removed afterwards)")
    ap.add_argument("--junit", help="write JUnit XML here")
    ap.add_argument("--summary", default=os.environ.get("GITHUB_STEP_SUMMARY"), help="append Markdown summary here")
    ap.add_argument("--validate-only", action="store_true", help="check manifests, do not download or parse")
    ap.add_argument("--coverage", action="store_true", help="list specs that have no sample manifest")
    ap.add_argument("-j", "--jobs", type=int, default=os.cpu_count() or 2)
    args = ap.parse_args()

    if args.coverage:
        coverage()
        return 0

    manifests = load_manifests(args.only)
    errs = [e for m in manifests for e in validate(m)]
    by_spec = collections.defaultdict(list)
    for m in manifests:
        by_spec[m.spec].append(m.path)
    errs += [f"{', '.join(paths)}: more than one manifest for {spec}"
             for spec, paths in by_spec.items() if len(paths) > 1]
    if not manifests:
        errs.append("no manifests match " + " ".join(args.only) if args.only else f"no manifests in {SAMPLES_DIR}")
    if errs:
        print("\n".join(errs), file=sys.stderr)
        return 2
    print(f"{len(manifests)} manifests, {sum(len(m.doc['samples']) for m in manifests)} samples")
    if args.validate_only:
        return 0

    if not shutil.which(args.ksc):
        print(f"ksc not found: {args.ksc} (install it, or pass --ksc)", file=sys.stderr)
        return 2
    if args.build_dir:
        results = run(manifests, args, args.build_dir)
    else:  # private to this run, so concurrent runs cannot trample each other
        with tempfile.TemporaryDirectory(prefix="ksf-build-") as build_root:
            results = run(manifests, args, build_root)

    counts = collections.Counter(r.status for r in results)
    line = ", ".join(f"{counts[k]} {k}" for k in STATUSES if counts[k])
    print(f"\n{line}")

    if args.junit:
        write_junit(args.junit, results)
    if args.summary:
        write_summary(args.summary, results, line)
    return 1 if any(counts[k] for k in FAILING) else 0


# --- reports -----------------------------------------------------------------

def write_junit(path, results):
    by_spec = collections.defaultdict(list)
    for r in results:
        by_spec[r.spec].append(r)
    root = ET.Element("testsuites")
    for spec, rs in by_spec.items():
        statuses = collections.Counter(r.status for r in rs)
        suite = ET.SubElement(root, "testsuite", name=spec, tests=str(len(rs)), errors="0",
                              failures=str(statuses["fail"] + statuses["xpass"]),
                              skipped=str(statuses["skip"] + statuses["xfail"]),
                              time=f"{sum(r.seconds for r in rs):.3f}")
        for r in rs:
            case = ET.SubElement(suite, "testcase", classname=spec, name=XML_INVALID.sub("?", r.name),
                                 time=f"{r.seconds:.3f}")
            if r.status == "pass":
                continue
            msg = XML_INVALID.sub("?", r.message)
            tag = "failure" if r.status in FAILING else "skipped"
            ET.SubElement(case, tag, message=f"{r.status}: {msg[:200]}").text = msg
    ET.indent(root)
    ET.ElementTree(root).write(path, encoding="utf-8", xml_declaration=True)


def write_summary(path, results, line):
    icon = {"fail": "❌", "xfail": "⚠️", "xpass": "❗", "skip": "⏭️"}
    with open(path, "a", encoding="utf-8") as f:
        f.write(f"## Sample-file tests\n\n{line}\n\n")
        bad = [r for r in results if r.status != "pass"]
        if bad:
            f.write("| | spec | sample | detail |\n|---|---|---|---|\n")
            for r in bad:
                # '<' would start an HTML tag (e.g. "<frozen importlib>") and hide the text
                msg = " ".join(r.message[:300].split()).replace("|", "\\|").replace("<", "&lt;")
                f.write(f"| {icon[r.status]} | `{r.spec}` | `{r.name}` | {msg} |\n")
        f.write("\n")


if __name__ == "__main__":
    sys.exit(main())
