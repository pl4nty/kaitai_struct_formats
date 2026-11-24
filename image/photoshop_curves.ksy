# Imported from https://gist.githubusercontent.com/zermylf/069da5125fa8d532f370c342f0b569ba/raw/b5ee90f109846a9d0545aa07e0970e59b3186d74/curves.format_spec.ksy
meta:
  id: photoshop_curves
  title: PS Curves Art Layer settings parser
  application: Adobe Photoshop
  license: LicenseRef-All-Rights-Reserved
  endian: be

doc: |
  Binary parser of PS action descriptor code,
  getted via legacyContentData() method.

doc-ref: https://www.adobe.com/devnet-apps/photoshop/fileformatashtml/#50577411_pgfId-1056330

seq:
  - id: magic_1
    contents: [0,0]
  - id: magic_2
    contents: [1]
  - id: unknowns_data1
    type: u2
  - id: unknowns_data2
    type: u1
  - id: channel_state
    type: bitmap_u1
  - id: raw_curves
    type: curve
    repeat: expr
    repeat-expr: channel_state.active
  - id: extra_data_magic
    contents: [0x43, 0x72, 0x76, 0x20]
  - id: extra_data_ver
    contents: [0,4]
  - id: unknown_data3
    type: u2
  - id: extra_data_items_count
    type: u2
  - id: extra_data_items
    type: extra_data_item
    repeat: expr
    repeat-expr: extra_data_items_count

types:
  bitmap_u1:
    seq:
      - id: b8
        type: b1
      - id: b7
        type: b1
      - id: b6
        type: b1
      - id: b5
        type: b1
      - id: b4
        type: b1
      - id: b3
        type: b1
      - id: b2
        type: b1
      - id: b1
        type: b1
    instances:
      active:
        value: >
          b1.to_i +
          b2.to_i +
          b3.to_i +
          b4.to_i +
          b5.to_i +
          b6.to_i +
          b7.to_i +
          b8.to_i

  curve:
    seq:
      - id: points_count
        type: u2
      - id: points
        type: curve_point
        repeat: expr
        repeat-expr: points_count

  curve_point:
    seq:
      - id: input
        type: u2
      - id: output
        type: u2

  extra_data_item:
    seq:
      - id: channel_index
        type: u2
      - id: item
        type: curve
