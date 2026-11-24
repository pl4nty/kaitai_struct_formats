# Imported from https://github.com/UrsulaProject/kaitai-groove-coaster-mobile/blob/8f3f01be4bc9470a5cde32d06329f4b189d5cc2b/uv_list.ksy
meta:
  id: groove_coaster_uv_list
  title: Groove Coaster texture UV lists
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: Recovered from UVList::LoadListData and UVList::Load.
seq:
  - id: file_size
    type: u4
    valid:
      eq: _io.size
  - id: num_lists
    type: u2
  - id: list_refs
    type: list_ref
    repeat: expr
    repeat-expr: num_lists
types:
  list_ref:
    seq:
      - id: offset
        type: u4
    instances:
      group:
        io: _root._io
        pos: offset
        type: uv_group
  uv_group:
    seq:
      - id: texture_index
        type: u2
      - id: num_rects
        type: u2
      - id: rects
        type: uv_rect
        repeat: expr
        repeat-expr: num_rects
  uv_rect:
    seq:
      - id: left
        type: u2
      - id: top
        type: u2
      - id: right
        type: u2
      - id: bottom
        type: u2
