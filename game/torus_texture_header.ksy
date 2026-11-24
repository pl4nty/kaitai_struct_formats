# Imported from https://github.com/desuex/torus-tools/blob/b2bdf033a06e70c7342ecce8f54172726b7b6568/TorusTool/Formats/Schemas/texture_header.ksy
meta:
  id: torus_texture_header
  title: TSE Texture Header (PC, Little Endian)
  license: MIT OR WTFPL
  endian: le

doc: |
  Body of a TSETextureHeader record. Always paired with a TSETextureData
  record holding the actual pixel bytes. The PC variant inspected from
  Global.hnk:Font_UI0 is 92 bytes; some texture types may vary.

  Format detection uses the leading 4 bytes (format_magic) — see the C#
  wrapper for the byte-pair → codec mapping (e.g. DXT5 = 0xD3,0x3A and a
  PS3-style variant 0x9F,0xBC).

seq:
  - id: format_magic
    size: 4
    doc: |
      4-byte format identifier. The existing parser only switches on the
      first 2 bytes; the remaining 2 bytes appear to be a variant tag.
  - id: data_size
    type: u4
    doc: Size in bytes of the paired TSETextureData record's body.
  - id: reserved_a
    type: u4
  - id: width
    type: u2
  - id: height
    type: u2
  - id: inv_width
    type: f4
    doc: 1.0 / width — UV scale shortcut.
  - id: inv_height
    type: f4
    doc: 1.0 / height — UV scale shortcut.
  - id: reserved_b
    type: u2
  - id: mip_or_layer_count
    type: u4
  - id: reserved_c
    type: u2
  - id: reserved_d
    type: u4
  - id: reserved_e
    type: u4
  - id: name
    size: 40
    type: str
    encoding: ASCII
    doc: |
      Texture name (NUL-terminated within a fixed 40-byte slot). For the
      Font_UI0 fixture this reads "Font_UI0" + 32 zero pad bytes.
  - id: reserved_f
    type: u4
  - id: reserved_g
    type: u4
  - id: reserved_h
    type: u4
