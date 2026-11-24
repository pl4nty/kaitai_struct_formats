# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/other/ue4pak_footer.ksy
meta:
  id: unreal_pak_info
  title: Unreal Engine 4 .pak container footer (FPakInfo)
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: |
  Unreal Engine 4 .pak container FPakInfo footer, per lib-ue4pak.c
  (used by Mario & Luigi: Brothership, Yoshi's Crafted World, Shin
  Megami Tensei V and other UE4 Switch titles). The footer has no
  fixed file position -- the reference reader searches the last 512
  bytes of the file for the magic word. This definition models the
  footer's own fixed layout starting at that magic, not the whole
  file; the index table it points to (compression-block tables,
  per-entry metadata) is not modeled here.
seq:
  - id: magic
    contents: [0xe1, 0x12, 0x6f, 0x5a]
  - id: version
    type: u4
  - id: index_offset
    type: u8
  - id: index_size
    type: u8
  - id: index_hash
    size: 20
  - id: compression_methods
    size: 32
    type: str
    terminator: 0
    encoding: ASCII
    repeat: expr
    repeat-expr: 5
