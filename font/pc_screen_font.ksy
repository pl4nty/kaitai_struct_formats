meta:
  id: pc_screen_font
  title: PC Screen Font (PSF)
  file-extension:
    - psf
    - psfu
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  PC Screen Font (PSF) is the bitmap font format used by the Linux
  console (loaded with `setfont`, shipped in the `kbd` package as
  `consolefonts/*.psf[u][.gz]`). It is a fixed-size header, followed by
  a table of monochrome glyph bitmaps, optionally followed by a Unicode
  table mapping every glyph position to the Unicode characters (and
  character sequences) it represents.

  Two versions exist:

  * PSF1 (magic `36 04`): 4-byte header, glyphs are always 8 pixels
    wide, there are 256 or 512 of them, and the Unicode table uses
    UCS-2 little-endian code units with 0xFFFE starting a sequence and
    0xFFFF ending the entry of one glyph.
  * PSF2 (magic `72 b5 4a 86`): 32-byte (or larger) header with
    explicit glyph count and dimensions; the Unicode table uses UTF-8,
    with byte 0xFE starting a sequence and byte 0xFF ending the entry of
    one glyph.

  Each glyph bitmap is `height` rows of `(width + 7) / 8` bytes, most
  significant bit = leftmost pixel.

  Fonts are commonly distributed gzip-compressed; this spec describes
  the uncompressed data.
doc-ref:
  - https://github.com/legionus/kbd/blob/df8ffcb14472ca0491e3d73b0cf64da5804ebffd/src/include/kbd/kfont.h
  - https://github.com/legionus/kbd/blob/df8ffcb14472ca0491e3d73b0cf64da5804ebffd/src/libkfont/psffontop.c
seq:
  - id: magic
    -orig-id: magic
    type: u2
    valid:
      any-of: [0x0436, 0xb572]
    doc: |
      First two bytes of the magic: `36 04` for PSF1, `72 b5` for PSF2
      (whose magic continues with `4a 86`).
  - id: header
    type:
      switch-on: magic
      cases:
        0x0436: psf1_header
        0xb572: psf2_header
instances:
  is_psf2:
    value: magic == 0xb572
  num_glyphs:
    value: 'is_psf2 ? header.as<psf2_header>.num_glyphs : (header.as<psf1_header>.mode_512 ? 512 : 256)'
  len_glyph:
    value: 'is_psf2 ? header.as<psf2_header>.len_glyph : header.as<psf1_header>.len_glyph'
    doc: Size of one glyph bitmap in bytes.
  width:
    value: 'is_psf2 ? header.as<psf2_header>.width : 8'
    doc: Glyph width in pixels.
  height:
    value: 'is_psf2 ? header.as<psf2_header>.height : header.as<psf1_header>.len_glyph'
    doc: Glyph height in pixels (rows).
  ofs_glyphs:
    value: 'is_psf2 ? header.as<psf2_header>.len_header : 4'
  has_unicode_table:
    value: 'is_psf2 ? header.as<psf2_header>.has_unicode_table : header.as<psf1_header>.has_unicode_table'
  glyphs:
    pos: ofs_glyphs
    size: len_glyph
    repeat: expr
    repeat-expr: num_glyphs
    doc: |
      Glyph bitmaps: `height` rows of `(width + 7) / 8` bytes each,
      most significant bit first.
  ofs_unicode_table:
    value: ofs_glyphs + num_glyphs * len_glyph
  unicode_table_psf1:
    pos: ofs_unicode_table
    type: psf1_unicode_entry
    repeat: expr
    repeat-expr: num_glyphs
    if: has_unicode_table and not is_psf2
  unicode_table_psf2:
    pos: ofs_unicode_table
    type: psf2_unicode_entry
    terminator: 0xff
    repeat: expr
    repeat-expr: num_glyphs
    if: has_unicode_table and is_psf2
types:
  psf1_header:
    -orig-id: psf1_header
    seq:
      - id: mode
        type: u1
        valid:
          max: 5
        doc: |
          Bit 0: 512 glyphs instead of 256; bit 1: has Unicode table;
          bit 2: Unicode table contains sequences.
      - id: len_glyph
        -orig-id: charsize
        type: u1
        doc: Bytes per glyph, equal to glyph height since PSF1 glyphs are 8 pixels wide.
    instances:
      mode_512:
        value: mode & 0x01 != 0
      has_unicode_table:
        value: mode & 0x06 != 0
        doc: |
          The reference implementation treats either the "has table" or
          the "has sequences" bit as indicating a Unicode table.
  psf2_header:
    -orig-id: psf2_header
    seq:
      - id: magic_rest
        contents: [0x4a, 0x86]
      - id: version
        type: u4
        valid: 0
      - id: len_header
        -orig-id: headersize
        type: u4
        doc: Offset of the glyph bitmaps from the start of the file.
      - id: flags
        type: u4
      - id: num_glyphs
        -orig-id: length
        type: u4
      - id: len_glyph
        -orig-id: charsize
        type: u4
        doc: Bytes per glyph, `height * ((width + 7) / 8)`.
      - id: height
        type: u4
      - id: width
        type: u4
    instances:
      has_unicode_table:
        value: flags & 0x01 != 0
        doc: PSF2_HAS_UNICODE_TABLE
  psf1_unicode_entry:
    doc: |
      Unicode description of one glyph: UCS-2 values that the glyph
      represents, optionally followed by sequences, each introduced by
      0xFFFE; terminated by 0xFFFF (included in the list).
    seq:
      - id: code_units
        type: u2
        repeat: until
        repeat-until: _ == 0xffff
  psf2_unicode_entry:
    doc: |
      Unicode description of one glyph (without its 0xFF terminator):
      UTF-8 characters that the glyph represents, then zero or more
      sequences of characters (e.g. a letter plus combining accents),
      each introduced by byte 0xFE.
    seq:
      - id: chars
        type: str
        terminator: 0xfe
        eos-error: false
        encoding: UTF-8
      - id: sequences
        type: str
        terminator: 0xfe
        eos-error: false
        encoding: UTF-8
        repeat: eos
