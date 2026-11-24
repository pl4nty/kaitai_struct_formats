# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/image/sgi/sgi.ksy
meta:
  id: sgi_image
  title: SGI Image File Format
  file-extension:
    - sgi
    - rgb
    - rgba
    - bw
    - int
    - inta
  xref:
    justsolve: SGI_(image_file_format)
    mime: image/sgi
    pronom: x-fmt/140
    wikidata: Q7514956
  license: CC0-1.0
  ks-version: 0.11
  encoding: ASCII
  endian: be
doc-ref: https://media.xiph.org/svt/SGIIMAGESPEC
seq:
  - id: header
    size: 512
    type: header
  - id: body
    type:
      switch-on: header.storage_format
      cases:
        storage_format::verbatim: verbatim
        storage_format::rle: rle
types:
  header:
    seq:
      - id: magic
        contents: [0x01, 0xda]
      - id: storage_format
        type: u1
        enum: storage_format
      - id: bytes_per_pixel
        type: u1
      - id: num_dimensions
        type: u2
        valid:
          any-of: [1, 2, 3]
      - id: xsize
        type: u2
      - id: ysize
        type: u2
      - id: zsize
        type: u2
      - id: min_pix
        type: u4
      - id: max_pix
        type: u4
      - id: ignored1
        type: padding(4)
      - id: name
        size: 80
        type: strz
      - id: colormap
        type: u4
        enum: colormap
        valid:
          in-enum: true
      - id: ignored
        type: padding(404)
  padding:
    params:
      - id: num_padding
        type: u4
    seq:
      - id: padding_bytes
        type: padding_byte
        repeat: expr
        repeat-expr: num_padding
  padding_byte:
    seq:
      - id: padding_byte
        contents: [0x00]
  verbatim:
    seq:
      - id: data
        size: _root.header.xsize * _root.header.ysize * _root.header.zsize * _root.header.bytes_per_pixel
  rle:
    seq:
      - id: start_table_entries
        type: u4
        repeat: expr
        repeat-expr: _root.header.ysize * _root.header.zsize
      - id: length_table_entries
        type: u4
        repeat: expr
        repeat-expr: _root.header.ysize * _root.header.zsize
    instances:
      scanlines:
        type: scanline(_index)
        repeat: expr
        repeat-expr: _root.header.ysize * _root.header.zsize
  scanline:
    params:
      - id: i
        type: u4
    instances:
      data:
        io: _root._io
        pos: _parent.start_table_entries[i]
        size: _parent.length_table_entries[i]
enums:
  storage_format:
    0: verbatim
    1: rle
  colormap:
    0: normal
    1: dithered
    2: screen
    3: colormap
