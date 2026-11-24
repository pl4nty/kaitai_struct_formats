# Imported from https://github.com/UrsulaProject/kaitai-groove-coaster-mobile/blob/8f3f01be4bc9470a5cde32d06329f4b189d5cc2b/texture_list.ksy
meta:
  id: groove_coaster_texture_list
  title: Groove Coaster embedded texture list
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Recovered from MtxTexture::LoadListData. Each adjacent pair of offsets
  delimits one encoded image accepted by MtxcTexture::createFromMemory.
seq:
  - id: file_size
    type: u4
    valid:
      eq: _io.size
  - id: num_textures
    type: u2
  - id: offsets
    type: texture_offset(_index)
    repeat: expr
    repeat-expr: num_textures + 1
types:
  texture_offset:
    params:
      - id: idx
        type: u2
    seq:
      - id: offset
        type: u4
    instances:
      data:
        io: _root._io
        pos: offset
        size: _parent.offsets[idx + 1].offset - offset
        if: idx < _root.num_textures
