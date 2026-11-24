# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/pack.ksy
meta:
  id: wii_pack
  title: Wii/GameCube PACK archive
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Generic "PACK" flat archive used by several Wii/GameCube titles. A fixed
  header points to a metric table of (offset, size) pairs; subfile names
  live in a name pool directly after the header. The pool holds one
  NUL-terminated path per metric, in matching order; the metrics do not
  contain name offsets.

  The reader checks the magic, a declared file_size at least as large as
  the available buffer, a metric offset of at least 0x20, and a metric
  table ending before the declared file_size. It strips leading slashes
  when presenting each path. If a payload starts at or beyond file_size,
  it presents an empty member at EOF; if only its end exceeds file_size,
  it truncates the presented length. This schema exposes declared metrics
  and raw bodies and does not perform that clamping or path sanitation.

  The writer sorts subfiles, omits directory entries, writes their paths
  consecutively in the name pool, and pads the pool to a 16-byte boundary.
  It aligns the metric area and payloads according to its configured PACK
  alignment; padding is zero-filled. Those alignment choices are writer
  conventions and should not be imposed on every valid archive.
seq:
  - id: magic
    contents: "PACK"
  - id: file_size
    type: u4
    doc: Declared total archive size, including the payload region.
  - id: num_files
    type: u4
    doc: Number of names and matching (offset,size) metrics.
  - id: offset_metric
    type: u4
    doc: Absolute offset to the (offset,size) metric table and end of name pool.
  - id: name_pool
    size: offset_metric - 16
    type: name_pool_t
    doc: Ordered NUL-terminated paths followed by optional alignment padding.
instances:
  metrics:
    pos: offset_metric
    type: metric
    repeat: expr
    repeat-expr: num_files
    doc: Metrics correspond by index to the paths in name_pool.names.
types:
  name_pool_t:
    seq:
      - id: names
        type: str
        terminator: 0
        encoding: UTF-8
        repeat: expr
        repeat-expr: _root.num_files
        doc: Ordered paths; reader strips any leading slash when extracting.
  metric:
    seq:
      - id: offset
        type: u4
        doc: Absolute file position of this member's bytes.
      - id: size
        type: u4
        doc: Declared member length; reader clamps it at file_size.
    instances:
      body:
        io: _root._io
        pos: offset
        size: size
        doc: Raw declared body; may fail if the metric extends beyond available data.
