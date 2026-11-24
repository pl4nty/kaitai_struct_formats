# Imported from https://github.com/desuex/torus-tools/blob/b2bdf033a06e70c7342ecce8f54172726b7b6568/TorusTool/Formats/Schemas/font_descriptor.ksy
meta:
  id: torus_font_descriptor
  title: TSE Font Descriptor (PC, Little Endian)
  license: LicenseRef-All-Rights-Reserved
  endian: le

doc: |
  Body of a TSEFontDescriptorData record. Layout:

    0x00..0x0F  Platform header (8 x u16 — counts and metrics, platform-endian
                on consoles but always LE for PC)
    0x10..0x23  File header (5 x u4 LE — table count + four table offsets)
    Pre-glyph table    (one entry per Unicode codepoint the font knows)
    Glyph element table (more entries, multiple per pre-glyph; the engine
                        composes a rendered glyph from one or more elements)
    Codepoint table    (parallel to pre-glyph table — maps array slot to
                        Unicode codepoint)

  Each table's position is given by the offsets in the file header.
  Lengths come from the platform-header counts:

    pre-glyphs   : count = glyph_count
    glyph data   : count = glyph_data_count
    codepoints   : count = glyph_count

  The fourth offset slot (here ofs_unknown_table) appears unused in the PC
  fixtures we have — typically zero — but tableCount=4 implies it could
  point somewhere in some variants. Preserved on write either way.

seq:
  # Platform header — 8 x u16
  - id: version_or_flags
    type: u2
  - id: line_height
    type: u2
  - id: bbox_min_x
    type: s2
  - id: ascender
    type: u2
  - id: bbox_min_y
    type: s2
  - id: glyph_count
    type: u2
  - id: glyph_data_count
    type: u2
  - id: reserved_header
    type: u2

  # File header — 5 x u4 (always LE)
  - id: table_count
    type: u4
  - id: ofs_pre_glyphs
    type: u4
  - id: ofs_glyph_data
    type: u4
  - id: ofs_unknown_table
    type: u4
    doc: Fourth table slot. Often zero in PC corpus; preserved for round-trip.
  - id: ofs_codepoints
    type: u4

instances:
  pre_glyphs:
    pos: ofs_pre_glyphs
    type: pre_glyph_entry
    repeat: expr
    repeat-expr: glyph_count

  glyph_data:
    pos: ofs_glyph_data
    type: glyph_data_entry
    repeat: expr
    repeat-expr: glyph_data_count

  codepoints:
    pos: ofs_codepoints
    type: u4
    repeat: expr
    repeat-expr: glyph_count

types:
  pre_glyph_entry:
    seq:
      - id: field0
        type: u2
      - id: field1
        type: u2
      - id: field2
        type: s2
      - id: field3
        type: s2
        doc: |
          Often interpreted as "first index in glyph_data table for this
          pre-glyph"; -1 (0xFFFF as signed) means no rendered elements.

  glyph_data_entry:
    seq:
      - id: glyph_index
        type: u2
      - id: element_id
        type: u2
        doc: |
          Indexes into something we haven't fully decoded yet — range 31..3791
          dense, plus 0xFFFF as a sentinel. Likely points into the RenderSprite
          record paired with this font (e.g. "RenderSprite/Font_UI"), but the
          indirection isn't 1:1 with sprite block count.
      - id: param1
        type: s2
      - id: param2
        type: s2
