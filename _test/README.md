# Sample-file tests

Regression tests that parse real-world sample files with the specs in this
repository. A spec at `image/png.ksy` gets its samples from
`_test/samples/image/png.yml`.

```sh
pip install kaitaistruct pyyaml
python3 _test/run_samples.py                 # everything
python3 _test/run_samples.py 'image/*.ksy'   # a subset (globs on spec paths)
python3 _test/run_samples.py --validate-only # schema check, no network
python3 _test/run_samples.py --coverage      # file formats (meta.file-extension) without samples
```

Needs `ksc` 0.11+ on `PATH` (or `--ksc`). A few specs need more at parse
time: opaque types and custom `process:` routines come from `_test/opaque`
(see its README), `process: kaitai.compress.*` needs the `kaitai_compress`
Python runtime on `PYTHONPATH`, and some compressors need `lz4` or `brotli`.
Downloads are cached by SHA-256 in
`_test/.cache` (`KSF_SAMPLE_CACHE` overrides). Generated parsers go to a
temporary directory; pass `--build-dir DIR` to keep them, e.g. to look up a
line number from a failure message.

## What a test checks

For each sample the runner:

1. downloads `url` and verifies `sha256` (a mismatch is a failure, never retried as a pass);
2. applies `extract`, if present;
3. compiles the spec to Python (`ksc -t python`), once per spec;
4. parses the bytes with the top-level type, in a subprocess with a timeout;
5. with `deep: true` (default), reads every seq field and every lazy
   `instances` value recursively, because Python only evaluates instances on
   access and many spec bugs live there (bounded by depth 32, 20k nodes, 30 s;
   past those bounds the rest is silently left unread);
6. with `eof: true`, requires the parse to consume the whole stream;
7. evaluates each `expect` entry.

## Manifest schema

```yaml
samples:
  - url: https://raw.githubusercontent.com/<owner>/<repo>/<commit-sha>/path/file.png
    sha256: <64 lowercase hex>
    name: optional-unique-name     # default: last URL segment (`data` for inline bytes)
    extract:                       # optional
      format: zip                  # zip | tar | gzip | bz2 | xz | hex | base64 | slice
      member: path/in/archive      # zip, tar (required)
      offset: 0                    # slice (default 0)
      size: 1234                   # slice (default: to the end)
      field: 1                     # base64: whitespace-separated field to decode (default 0)
      then: { format: slice, offset: 40 }   # optional, chained
    deep: true                     # force all instances (default true)
    eof: false                     # require the whole input to be consumed
    timeout: 60                    # seconds for the parse (default 60)
    expect:                        # Python expressions over the root object
      ihdr.width: 300
      ihdr.color_type: truecolor   # enums compare by name (or by value if an int)
      magic: 89504e47              # bytes compare as hex or as latin-1 text
      len(chunks): 5
    params:                        # for specs with top-level `params:`; all of them, by id
      array: _data                 # Python expression (always a string, so quote
      num_digits: '4'              # numbers); `_data` is the sample's bytes
    xfail: why this sample fails today   # known spec bug; passing turns red (XPASS)
    skip: why it is not run              # e.g. too large
```

Library types with no file form (CRCs, checksums, number encodings) can use
inline bytes instead of a download: `data: <hex byte pairs>` replaces `url`,
`sha256` and `extract`. Use it only for canonical test vectors (e.g. the CRC
catalogue's `123456789` check input), never for real-world files. One
exception: a short excerpt re-packed from a pinned real file that the runner
cannot extract itself (e.g. u-blox words stored byte-swapped). The comment
must give the source URL, its sha256, the offsets and the re-packing steps.

Formats with no public real-world file can use a small generated file
committed under `_test/fixtures/<spec path>/`: `fixture: <path relative to
_test/fixtures>` replaces `url`, keeps `sha256`, and needs `recipe:` (the
exact tool, version and command that produced it). Expects must come from the
generating tool or its inputs, not from the spec. Prefer real files: a fixture
only shows the spec agrees with one writer.

Rules for sample URLs:

- Git LFS files: use `media.githubusercontent.com/media/<owner>/<repo>/<sha>/<path>`;
  `raw.githubusercontent.com` serves the LFS pointer.
- Pin to an immutable revision (a commit SHA for GitHub raw URLs, never a branch).
- Prefer small files (under ~5 MB).
- Do not link to issue or pull-request pages; link to the file itself.
- `expect` values must come from an independent source (the format's
  reference tool, a hex dump, the sample's documentation), not from the
  spec's own output, or the test only proves the spec agrees with itself.

## Results

`fail` and `xpass` fail the run. `xfail` and `skip` are reported but do not.
Fetch and extract errors always fail: a dead URL needs a new URL, not an
`xfail`. Invalid manifests, or globs that match none, stop the run with exit
status 2 before anything is downloaded.
In CI the runner writes JUnit XML and a Markdown table to the job summary.
