# Opaque types and custom processes

`run_samples.py` puts this directory on the parse worker's `PYTHONPATH`. It
holds Python code that specs need but cannot express in KSY:

- **opaque types** (`meta.ks-opaque-types: true`, or an external `type:` name),
  for which ksc only generates `import <module>` and a call like
  `module.ClassName(args..., self._io, self, self._root)`;
- **custom `process:` routines** (anything except zlib/xor/rol/ror), which ksc
  imports as `from <name> import <Name>` (or `import a.b` for `a.b.c`) and
  uses as `Name(args...).decode(data)`.

Rules:

- Name the module and class exactly as the generated import line asks. Compile
  the spec with `--build-dir` and check the import line to be sure.
- Follow the Kaitai Python runtime conventions: an opaque type is a class
  (usually a `KaitaiStruct` subclass) whose `__init__` takes the spec's
  arguments, then `_io, _parent=None, _root=None` (match the call site); a
  process is a class whose constructor takes the spec's arguments and whose
  `decode(self, data)` returns bytes.
- Write the code from the format documentation or from the code in the spec's
  own `doc`. Keep it minimal, and note where it departs from that source.
- Never add code here just so a spec passes: if the spec is wrong, the sample
  gets an `xfail`.

| Module | Used by |
|---|---|
| `numpy_parsed_header` | serialization/numpy_npy |
| `lytro_lfp_sections_index`, `lytro_lfp_json_parsed_metadata` | image/lytro_lfp |
| `lookup_object` | game/gbtd_gbr1 |
| `concat`, `decompress` | filesystem/squashfs |
| `util/custom_arc4` | security/gdata_quarantine, security/windef_entries, windef_resources, windef_resource_data |
| `rot` | game/qsp |
