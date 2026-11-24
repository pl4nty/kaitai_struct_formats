# Imported from https://github.com/entriphy/klonoa2-tools/blob/8632014b9c20857d4069b4db5bb11b08ebf72e31/lib/structs/ks/klfb.ksy
meta:
  id: klonoa2_klfb
  title: Klonoa 2 KLFB file
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: count
    type: u4
  - id: local_joints_offset
    type: u4
  - id: global_joints_offset
    type: u4
  - id: parent_joints
    type: u2
    repeat: expr
    repeat-expr: count
    doc: |
      Defines parent joints for each joint. 0xFFFF means a joint
      does not have a parent.
instances:
  local_joints:
    pos: local_joints_offset
    type: coordinate
    repeat: expr
    repeat-expr: count
  global_joints:
    pos: global_joints_offset
    type: coordinate
    repeat: expr
    repeat-expr: count
types:
  coordinate:
    doc: Y and Z axes are inverted.
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
      - id: zero
        type: f4
