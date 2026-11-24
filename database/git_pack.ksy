meta:
  id: git_pack
  title: Git pack file
  application: Git
  file-extension: pack
  license: CC0-1.0
  ks-version: '0.11'
  imports:
    - /common/vlq_base128_le
  endian: be
doc: |
  A Git pack file (`objects/pack/pack-*.pack`, also sent over the wire
  by the fetch/push protocols) stores many Git objects, each zlib
  compressed and optionally stored as a delta against another object.

  The pack does not record the compressed size of its objects, so the
  object entries cannot be walked without inflating each zlib stream.
  This spec therefore parses the pack header, the first object entry
  header and the trailing checksum; the `object_entry` type can be
  used to parse any object entry at an offset taken from the
  corresponding pack index (see `git_pack_index`). The zlib compressed
  data of an entry starts right after its header (`len_header`).

  The checksum size depends on the repository's hash function
  (20 bytes for SHA-1, 32 bytes for SHA-256) and is not stored in the
  pack; SHA-1 is assumed (change `len_hash` for SHA-256 packs).
doc-ref: https://github.com/git/git/blob/77904e546de3bd940621092ecec47a88d0cede5d/Documentation/gitformat-pack.adoc
seq:
  - id: magic
    contents: PACK
  - id: version
    type: u4
    valid:
      any-of: [2, 3]
  - id: num_objects
    type: u4
instances:
  first_object:
    pos: 12
    type: object_entry
    if: num_objects > 0
  len_hash:
    value: 20
  checksum:
    pos: _io.size - len_hash
    size: len_hash
    doc: Checksum of all of the above.
types:
  object_entry:
    seq:
      - id: has_more_size
        type: b1
      - id: type
        type: b3
        enum: object_type
      - id: size_low
        type: b4
      - id: size_high
        type: vlq_base128_le
        if: has_more_size
      - id: base_offset
        type: offset_encoding
        if: type == object_type::ofs_delta
        doc: Distance back from the start of this entry to the base object.
      - id: base_name
        size: _root.len_hash
        if: type == object_type::ref_delta
        doc: Name of the base object.
    instances:
      len_uncompressed:
        value: 'has_more_size ? (size_high.value << 4) | size_low : size_low'
        doc: |
          Size of the uncompressed object, or of the uncompressed delta
          data for delta entries.
      len_header:
        value: |
          1
          + (has_more_size ? size_high.len : 0)
          + (type == object_type::ofs_delta ? base_offset.groups.size : 0)
          + (type == object_type::ref_delta ? _root.len_hash : 0)
        doc: |
          Size of the entry header; the zlib compressed (delta) data of
          the entry follows it.
  offset_encoding:
    doc: |
      Big-endian base-128 number where each continuation adds one to
      the accumulated value before shifting, so that every value has a
      single encoding.
    seq:
      - id: groups
        type: 'offset_group(_index == 0, _index == 0 ? 0 : groups[_index - 1].value)'
        repeat: until
        repeat-until: not _.has_next
    instances:
      value:
        value: groups.last.value
  offset_group:
    params:
      - id: is_first
        type: bool
      - id: prev_value
        type: u8
    seq:
      - id: has_next
        type: b1
      - id: chunk
        type: b7
    instances:
      value:
        value: 'is_first ? chunk : ((prev_value + 1) << 7) | chunk'
enums:
  object_type:
    1: commit
    2: tree
    3: blob
    4: tag
    6: ofs_delta
    7: ref_delta
