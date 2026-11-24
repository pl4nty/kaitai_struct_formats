# Imported from https://github.com/vardonir/pyDXHR/blob/be481db8c36f82e7c37306a9f7a5b6cc97504e87/ksy/PCD.ksy
# Licence and copyright: see _community/README.md
meta:
  id: dxhr_pcd
  title: 'Deus Ex: Human Revolution PC texture (PCD)'
  license: MIT
  endian: le

doc: |
  Texture image type used in the PC version of the game. 

seq:
  - id: magic
    contents: "PCD9"
  - id: format
    type: u4
    enum: texture_format
  - id: len_data
    type: u4
  - id: len_mipmaps
    type: u4
  - id: width
    type: u2
  - id: height
    type: u2
  - id: unk14
    type: u4
  - id: unk18
    type: u4
  - id: payload
    size: len_data

enums:
  texture_format:
    0x15: a8r8g8b8
    0x31545844: dxt1
    0x33545844: dxt3
    0x35545844: dxt5
