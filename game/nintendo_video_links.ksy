# Imported from https://github.com/Nintendo-Video-research-project/Kaitais/blob/d5e1ee1f171a6361fd23b08ad0c1f66a53e764e2/kaitais/links.ksy
meta:
  id: nintendo_video_links
  title: Nintendo Video episode links
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: meta_len
    type: u4
    doc: Total length of the metadata block

  - id: link_id
    size: 0x30
    type: str
    encoding: UTF-8
    doc: Text identifier for link

  - id: unknown
    size: 0x8
    doc: Padding? / unknown block preceding the URL data

  - id: url_addr
    size: 0x100
    type: str
    terminator: 0
    encoding: UTF-8
    doc: Fixed 256-byte interactive url string layout

  - id: link_color
    type: u4
    doc: 4-byte RGBA button color value

instances:
  color_r:
    value: link_color & 0xff
  color_g:
    value: (link_color >> 8) & 0xff
  color_b:
    value: (link_color >> 16) & 0xff
  color_a:
    value: (link_color >> 24) & 0xff
