# Imported from https://github.com/L1nkZ/raglib/blob/bfd5a931017371311a95194d336d35f564308950/kaitai/gat.ksy
meta:
  id: ragnarok_gat
  title: Ragnarok Altitude Resource
  application: Ragnarok Online clients
  license: MIT
  ks-version: 0.9
  endian: le

seq:
  - id: magic
    size: 4
    contents: ["GRAT"]
    doc: File identification, must be "GRAT"
  - id: version
    type: u2be

  - id: width
    type: u4
    valid:
      expr: _ <= 512
  - id: height
    type: u4
    valid:
      expr: _ <= 512

  - id: cells
    type: cell
    repeat: expr
    repeat-expr: width * height

types:
  cell:
    seq:
      - id: height
        type: f4
        repeat: expr
        repeat-expr: 4
      - id: type
        type: u4
