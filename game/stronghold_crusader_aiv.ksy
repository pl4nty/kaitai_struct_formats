meta:
  id: stronghold_crusader_aiv
  title: AI Village
  application:
    - Stronghold Crusader
    - Stronghold Crusader Extreme
    - Village
  file-extension: aiv
  license: CC0-1.0
  endian: le
doc: |
  The structure of the Stronghold Crusader AI Village file format is similar to
  the one of the map file format. It consists of a directory, specifying
  properties of the following data sections. Some sections are compressed using
  blast compression (PKWARE Data Compression Library "implode"), an
  implementation of which can be found at
  https://github.com/ladislav-zezula/StormLib/tree/master/src/pklib.
  Compressed sections are not decompressed by this spec.
seq:
  - id: dir
    type: dir
  - id: x_view
    type: u4
  - id: y_view
    type: u4
  - id: random
    size: 40016
  - id: bmap_size
    type: compr_sec
  - id: bmap_tile
    type: compr_sec
  - id: tmap
    type: compr_sec
  - id: gmap
    size: 10000
  - id: bmap_id
    type: compr_sec
  - id: bmap_step
    type: compr_sec
  - id: step_cur
    type: u4
  - id: step_tot
    type: u4
  - id: parr
    type: s4
    repeat: expr
    repeat-expr: _root.dir.len_uncompressed[11] / 4
    doc: Always 10 or 50 entries.
  - id: tarr
    type: u4
    repeat: expr
    repeat-expr: 240
  - id: pause
    type: u4
types:
  dir:
    doc: Directory describing the data sections that follow it.
    seq:
      - id: len_dir
        -orig-id: size
        type: u4
        doc: Size of the directory; always 2036.
      - id: len_file_without_dir
        -orig-id: fswd
        type: u4
        doc: File size without the directory.
      - id: num_sections
        -orig-id: sec_cnt
        type: u4
        doc: Number of sections; always 14.
      - id: version
        type: u4
        doc: Always 200.
      - id: padding0
        contents: [
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
        ]
      - id: len_uncompressed
        -orig-id: uncompr_size
        type: u4
        repeat: expr
        repeat-expr: 100
      - id: len_compressed
        -orig-id: compr_size
        type: u4
        repeat: expr
        repeat-expr: 100
      - id: id
        type: u4
        repeat: expr
        repeat-expr: 100
      - id: is_compressed
        -orig-id: is_compr
        type: u4
        repeat: expr
        repeat-expr: 100
      - id: offset
        type: u4
        repeat: expr
        repeat-expr: 100
      - id: padding1
        contents: [0x00, 0x00, 0x00, 0x00]
  uncompr_sec:
    doc: Uncompressed section number `i`.
    params:
      - id: i
        type: s4
    seq:
      - id: data
        size: _root.dir.len_uncompressed[i]
  compr_sec:
    doc: Compressed section.
    seq:
      - id: len_uncompressed
        -orig-id: uncompr_size
        type: u4
      - id: len_compressed
        -orig-id: compr_size
        type: u4
      - id: crc32
        type: u4
      - id: data
        size: len_compressed
        doc: Blast-compressed section data.
