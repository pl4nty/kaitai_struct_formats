# Imported from https://github.com/Nintendo-Video-research-project/Kaitais/blob/d5e1ee1f171a6361fd23b08ad0c1f66a53e764e2/kaitais/header.ksy
meta:
  id: nintendo_video_boss_header
  title: Nintendo Video BOSS content header
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    type: u4
  - id: version
    type: u4
  - id: file_size
    type: u4
  - id: serial
    type: u8
  - id: const
    type: u2
  - id: padding
    type: u2
  - id: hash 
    type: u2
  - id: rsa
    type: u2
  - id: iv # Short for initialization vector
    size: 12
