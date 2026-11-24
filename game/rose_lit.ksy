# Imported from https://github.com/SevenHearts/portship.js/blob/124d26389d1f7c0bd621894f1d44a9c75c8c9c2e/src/format/LIT.ksy
meta:
  id: rose_lit
  title: ROSE Online lightmap info (.lit)
  file-extension: lit
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: obj_count
    type: u4
  - id: objects
    type: obj_info
    repeat: expr
    repeat-expr: obj_count
  - id: dds_count
    type: u4
  - id: dds_names
    type: bstr
    repeat: expr
    repeat-expr: dds_count
types:
  bstr:
    seq:
      - id: len
        type: u1
      - id: data
        size: len
        type: str
        encoding: ASCII
  obj_info:
    seq:
      - id: part_count
        type: u4
      - id: object_id
        type: u4
      - id: parts
        type: part_info
        repeat: expr
        repeat-expr: part_count
    types:
      part_info:
        seq:
          - id: original_name
            type: bstr
          - id: part_id
            type: u4
          - id: dds_name
            type: bstr
          - id: dds_id
            type: u4
          - id: dds_division_size
            type: u4
          - id: dds_division_count
            type: u4
          - id: dds_part_id
            type: u4
