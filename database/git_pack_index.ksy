meta:
  id: git_pack_index
  title: Git pack index
  application: Git
  file-extension: idx
  license: CC0-1.0
  ks-version: '0.11'
  endian: be
doc: |
  A Git pack index (`objects/pack/pack-*.idx`) maps object names to
  offsets of the objects in the corresponding pack file
  (`pack-*.pack`), sorted by object name and accompanied by a 256-entry
  fan-out table for fast lookup.

  Both index versions are supported:

  * version 1: fan-out table followed by (offset, name) pairs;
  * version 2: magic `0xff "tOc"`, version, fan-out table, then separate
    tables of names, CRC32s, 31-bit offsets and 64-bit large offsets.

  The object name size (20 bytes for SHA-1, 32 bytes for SHA-256) is not
  stored in the file. It is inferred from the file size: SHA-1 is
  assumed unless the size only fits a SHA-256 index.
doc-ref: https://github.com/git/git/blob/77904e546de3bd940621092ecec47a88d0cede5d/Documentation/gitformat-pack.adoc
seq:
  - id: header
    type: header_v2
    if: is_version_2
  - id: fanout
    type: u4
    repeat: expr
    repeat-expr: 256
    doc: |
      Entry N is the number of objects whose name's first byte is less
      than or equal to N; the last entry is the total number of objects.
  - id: entries_v1
    type: entry_v1
    repeat: expr
    repeat-expr: num_objects
    if: not is_version_2
  - id: object_names
    size: len_hash
    repeat: expr
    repeat-expr: num_objects
    if: is_version_2
    doc: Sorted object names.
  - id: crc32s
    type: u4
    repeat: expr
    repeat-expr: num_objects
    if: is_version_2
    doc: CRC32 of each packed object's data, in the order of `object_names`.
  - id: offsets
    type: offset_v2
    repeat: expr
    repeat-expr: num_objects
    if: is_version_2
  - id: large_offsets
    type: u8
    repeat: expr
    repeat-expr: num_large_offsets
    if: is_version_2
    doc: Pack offsets referred to by offsets with the high bit set.
  - id: pack_checksum
    size: len_hash
    doc: Copy of the checksum at the end of the corresponding pack file.
  - id: index_checksum
    size: len_hash
    doc: Checksum of all of the above.
instances:
  magic:
    pos: 0
    size: 4
  is_version_2:
    value: magic == [0xff, 0x74, 0x4f, 0x63]
  ofs_fanout:
    value: 'is_version_2 ? 8 : 0'
  num_objects:
    pos: ofs_fanout + 255 * 4
    type: u4
  num_large_offsets:
    value: |
      is_version_2 ? (
        len_hash == 20
        ? len_rest_sha1 / 8
        : (_io.size - 8 - 1024 - num_objects * 40 - 64) / 8
      ) : 0
    doc: Derived from the file size (the count is not stored).
  len_rest_sha1:
    value: '_io.size - ofs_fanout - 1024 - num_objects * (is_version_2 ? 28 : 24) - 40'
    doc: |
      Bytes left over when assuming SHA-1: 0 for version 1, 8 times the
      number of large offsets for version 2.
  len_hash:
    value: |
      len_rest_sha1 >= 0
      and len_rest_sha1 % 8 == 0
      and len_rest_sha1 / 8 <= num_objects
      and (is_version_2 or len_rest_sha1 == 0)
      ? 20 : 32
    doc: Size of object names and checksums (20 for SHA-1, 32 for SHA-256).
types:
  header_v2:
    seq:
      - id: magic
        contents: [0xff, 't', 'O', 'c']
      - id: version
        type: u4
        valid: 2
  entry_v1:
    seq:
      - id: ofs_object
        type: u4
        doc: Offset of the object in the pack file.
      - id: object_name
        size: _root.len_hash
  offset_v2:
    seq:
      - id: is_large
        type: b1
        doc: If set, `value` is an index into `large_offsets`.
      - id: value
        type: b31
    instances:
      ofs_object:
        value: 'is_large ? _root.large_offsets[value] : value'
        doc: Offset of the object in the pack file.
