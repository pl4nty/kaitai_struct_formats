# Imported from https://github.com/lcdr/lu_formats/blob/eb15852181d3fd55f638eb20ce4a2e9cd7f08dac/common/common.ksy
meta:
  id: lu_common
  title: LEGO Universe common types
  license: LicenseRef-All-Rights-Reserved
  endian: le
  bit-endian: le
types:
  vector2:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
  vector3:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
  object_id:
    seq:
      - id: object_id
        type: u8
  lot:
    seq:
      - id: lot
        type: s4
  quaternion:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
      - id: w
        type: f4
  quaternion_wxyz:
    seq:
      - id: w
        type: f4
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
  u1_str:
    seq:
      - id: length
        type: u1
      - id: str
        size: length
        type: str
        encoding: ASCII
  u1_wstr:
    seq:
      - id: length
        type: u1
      - id: str
        size: length * 2
        type: str
        encoding: UTF-16LE
  u4_str:
    seq:
      - id: length
        type: u4
      - id: str
        size: length
        type: str
        encoding: ASCII
  u4_wstr:
    seq:
      - id: length
        type: u4
      - id: str
        size: length * 2
        type: str
        encoding: UTF-16LE
  bool:
    seq:
      - id: bool
        type: u1
        enum: boolean
enums:
  boolean:
    0: false
    1: true
