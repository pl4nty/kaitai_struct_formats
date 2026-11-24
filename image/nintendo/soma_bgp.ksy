# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/nitro/soma_bgp.ksy
meta:
  id: soma_bgp
  title: Monolith Soft BGP1 background graphic (Soma Bringer .bgp)
  file-extension: bgp
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: The `data_offset` / `palette_size` fields locate the two payloads.
seq:
  - id: magic
    contents: 'BGP1'
  - id: file_size
    type: u4
    doc: At least 24, at most the physical file size.
  - id: width
    type: u2
  - id: height
    type: u2
  - id: flags
    type: u4
  - id: data_offset
    type: u4
  - id: palette_size
    type: u4
  - id: rest
    size-eos: true
    doc: Palette and tile map, located by `data_offset` and `palette_size`.
