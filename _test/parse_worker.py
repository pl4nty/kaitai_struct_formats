"""Parse one sample with a compiled spec. Runs in its own process.

Reads a JSON job on stdin, prints one JSON result line on stdout.
"""

import builtins
import enum
import importlib
import json
import os
import sys
import time
import traceback

from kaitaistruct import KaitaiStream, KaitaiStruct

MAX_NODES = 20_000  # pointer-following instances can re-parse without bound
MAX_MEMORY = 2 * 1024 ** 3
MAX_DEPTH = 32  # struct nesting; self-referencing instances (e.g. '.' dir entries) recurse forever
MAX_SECONDS = 30


def public_names(obj):
    """Seq fields and params (instance attributes), then instances (properties)."""
    names = [k for k in vars(obj) if not k.startswith("_")]
    for klass in type(obj).__mro__:
        names += [k for k, v in vars(klass).items()
                  if isinstance(v, property) and not k.startswith("_")]
    return dict.fromkeys(names)  # de-duplicated, in order


def deep_eval(root):
    """Touch every seq field and every lazy instance, recursively.

    Generated Python exposes instances as properties, so a plain parse never
    evaluates them; bugs in instances (bad offsets, wrong types) only show up
    when something reads them. Returns ``(path, exception)`` for the first
    failure found, or None. Gives up quietly at the MAX_* bounds.
    """
    seen = {}  # id -> object; holding the object keeps its id from being reused
    stack = [(root, "_root", 0)]
    deadline = time.monotonic() + MAX_SECONDS
    while stack:
        obj, path, depth = stack.pop()
        if isinstance(obj, list):
            # only containers can hide instances; skipping scalars keeps big arrays cheap
            stack += [(v, f"{path}[{i}]", depth) for i, v in enumerate(obj)
                      if isinstance(v, (KaitaiStruct, list))]
            continue
        if id(obj) in seen or depth > MAX_DEPTH:
            continue
        if len(seen) >= MAX_NODES or time.monotonic() > deadline:
            return None
        seen[id(obj)] = obj
        for name in public_names(obj):
            child = f"{path}.{name}"
            try:
                value = getattr(obj, name)
            except MemoryError:
                raise
            except Exception as e:
                return child, e
            if isinstance(value, (KaitaiStruct, list)):
                stack.append((value, child, depth + 1))
    return None


class Names:
    """Namespace for ``expect`` expressions: the root's fields, plus ``_root``."""

    def __init__(self, root):
        self.root = root

    def __getitem__(self, key):
        if key == "_root":
            return self.root
        try:
            return getattr(self.root, key)
        except AttributeError:
            if key in dir(self.root):
                raise  # the field exists; evaluating it failed
            raise KeyError(key) from None  # let eval fall back to builtins


SAFE_BUILTINS = {n: getattr(builtins, n) for n in (
    "len", "min", "max", "sum", "any", "all", "sorted", "set", "list",
    "tuple", "int", "str", "bytes", "bool", "abs", "isinstance", "type")}


def matches(actual, expected):
    if isinstance(actual, enum.Enum):
        if isinstance(expected, str):
            return actual.name == expected
        return actual.value == expected
    if isinstance(actual, (bytes, bytearray)) and isinstance(expected, str):
        hexed = expected.replace(" ", "").lower()
        return actual == expected.encode("latin-1", "replace") or actual.hex() == hexed
    if isinstance(actual, float) and isinstance(expected, (int, float)):
        return abs(actual - expected) <= 1e-9 * max(1.0, abs(expected))
    return actual == expected


def short(v):
    r = repr(v)
    return r if len(r) <= 200 else r[:200] + "..."


def describe(e):
    """Exception summary with the innermost frames, innermost first."""
    frames = [f"{os.path.basename(f.filename)}:{f.lineno} {f.name}"
              for f in traceback.extract_tb(e.__traceback__)[-4:]]
    return f"{type(e).__name__}: {e} [{' <- '.join(reversed(frames))}]"


def check(job):
    """Run one job; return an error message, or None if everything holds."""
    try:
        cls = getattr(importlib.import_module(job["module"]), job["class"])
    except Exception as e:
        return f"import: {describe(e)}"
    params = {}
    if job.get("params"):
        with open(job["file"], "rb") as f:
            data = f.read()
        for name, expr in job["params"].items():
            try:  # _data: the sample's bytes, e.g. for a CRC spec's `array` param
                params[name] = eval(expr, {"__builtins__": SAFE_BUILTINS}, {"_data": data})  # noqa: S307
            except Exception as e:
                return f"param {name!r}: {describe(e)}"
    try:
        if params:
            root = cls(_io=KaitaiStream(open(job["file"], "rb")), **params)
        else:
            root = cls.from_file(job["file"])
    except Exception as e:
        return f"parse: {describe(e)}"

    if job["deep"]:
        try:
            bad = deep_eval(root)
        except MemoryError:
            return f"deep: exceeded {MAX_MEMORY >> 20} MiB; set deep: false for this sample"
        if bad:
            path, e = bad
            return f"instance {path}: {describe(e)}"

    if job["eof"] and not root._io.is_eof():
        return f"eof: parse stopped at {root._io.pos()} of {root._io.size()} bytes"

    names = Names(root)
    for expr, want in job["expect"].items():
        try:
            got = eval(expr, {"__builtins__": SAFE_BUILTINS}, names)  # noqa: S307 (manifest is repo content)
        except Exception as e:
            return f"expect {expr!r}: {describe(e)}"
        if not matches(got, want):
            return f"expect {expr!r}: wanted {short(want)}, got {short(got)}"
    return None


def main():
    try:
        import resource
        resource.setrlimit(resource.RLIMIT_AS, (MAX_MEMORY, MAX_MEMORY))
    except (ImportError, ValueError, OSError):
        pass
    error = check(json.load(sys.stdin))
    print(json.dumps({"ok": True} if error is None else {"ok": False, "error": error}))


if __name__ == "__main__":
    main()
