# Imported from https://github.com/desuex/torus-tools/blob/b2bdf033a06e70c7342ecce8f54172726b7b6568/TorusTool/Formats/Schemas/render_sprite.ksy
meta:
  id: torus_render_sprite
  title: TSE RenderSprite (PC, Little Endian)
  license: MIT OR WTFPL
  endian: le

doc: |
  Body of a TSERenderSprite record. Layout for the PC version (all LE — the
  010 .bt template assumes PS3/BE; we read PC bytes here):

    0x00 u4   num_blocks       — count of sprite-block slots
    0x04 u4   ofs_blocks       — typically 0x10 (right after header)
    0x08 u2   format           — sprite-format / variant (1 in the font's case)
    0x0A u2   reserved_zero
    0x0C u4   len_blocks_data  — size of region from ofs_blocks to end of record

  At `ofs_blocks` there is a pointer table of `num_blocks` u4 entries. Each
  pointer is a byte offset within the record body. Most non-zero pointers
  lead to a 64-byte sprite_block; zero entries are empty slots and have no
  block. The blocks are NOT required to be contiguous or in sorted order —
  some PC fixtures interleave them. For that reason this schema reads only
  the pointer table; the actual block payloads are addressable via the
  C# wrapper using slice arithmetic.

seq:
  - id: num_blocks
    type: u4
  - id: ofs_blocks
    type: u4
  - id: format
    type: u2
  - id: reserved_zero
    type: u2
  - id: len_blocks_data
    type: u4

instances:
  block_ptrs:
    pos: ofs_blocks
    type: u4
    repeat: expr
    repeat-expr: num_blocks
