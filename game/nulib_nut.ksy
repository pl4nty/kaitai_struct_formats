meta:
  id: nulib_nut
  title: Namco Texture Bank
  application: Games with Namco NU library
  file-extension: nut
  license: MIT
  endian: be
seq:
  - id: signature
    type: u4
    enum: signature
    valid:
      any-of:
        - signature::ntp3
        # TODO: - signature::ntwu
        - signature::ntwd
        - signature::ntlx
  - id: body
    type: nut_body

types:
  nothing: {}
  nut_body:
    meta:
      endian:
        switch-on: _root.signature
        cases:
          'signature::ntwd': le
          'signature::ntlx': le
          _: be
    seq:
      - id: header
        size: 0xC
        type: header
      - id: textures
        type: texture(_index)
        repeat: expr
        repeat-expr: header.num_textures
    types:
      header:
        seq:
          - id: version
            type: u2
            valid:
              any-of:
                - 2
          - id: num_textures
            type: u2
      texture:
        params:
          - id: i
            type: u4
        seq:
          - id: size
            type: u4
          - id: padding
            size: 4
            type: nothing
          - id: data_size
            type: u4
          - id: header_size
            type: u2
          - id: texture_data
            size: 2
            # very important this way we save the current header offset
            # and we can calculate the data position properly
            type: texture_data(_root._io.pos)
          - id: texture_info
            # total size - header - gidx
            size: header_size - 0x10 - 0x20
            type: texture_info
          - id: gidx
            size: 0x20
            type: gidx
      texture_data:
        params:
          - id: offset
            type: u4
        instances:
          data_offset:
            value: offset - 0x10 + _parent.texture_info.data_offset
          surfaces:
            io: _root._io
            pos: data_offset
            size: _parent.data_size
            type: surfaces
      gidx:
        seq:
          - id: signature
            contents: ['eXt', 0]
          - id: version
            type: u4
          - id: version2
            type: u4
          - size: 4
            type: nothing
          - id: type
            contents: 'GIDX'
          - size: 4
            type: nothing
          - id: hash_id
            type: u4
      texture_info:
        seq:
          - id: padding
            size: 1
            type: nothing
          - id: num_mipmaps
            type: u1
          - id: padding3
            size: 1
            type: nothing
          - id: pixel_format
            type: u1
            enum: pixel_format
            valid:
              any-of:
                - pixel_format::dxt1
                - pixel_format::dxt3
                - pixel_format::dxt5
          - id: width
            type: u2
          - id: height
            type: u2
          - id: texture_type
            type: u4
            enum: texture_type
            valid:
              any-of:
                - texture_type::dds
            doc: It's a little unclear if this is actually that
          - id: cubemap
            size: 4
            type: cubemap
          - id: data_offset
            type: u4
          - id: padding4
            size: 12
            type: nothing
          - id: mipmap_sizes
            type: u4
            repeat: expr
            repeat-expr: num_mipmaps - 1
        instances:
          surface_count:
            value: |
              1 +
              cubemap.sides[0].to_i +
              cubemap.sides[1].to_i +
              cubemap.sides[2].to_i +
              cubemap.sides[3].to_i +
              cubemap.sides[4].to_i +
              cubemap.sides[5].to_i
      cubemap:
        seq:
          - id: padding
            type: b5
          - id: is_cubemap
            type: b1
          - id: sides
            type: b1
            repeat: expr
            repeat-expr: 6
            doc: +x -x +y -y +z -z
      surfaces:
        seq:
          - id: surfaces
            type: texture_surface
            repeat: expr
            repeat-expr: _parent._parent.texture_info.surface_count
      texture_surface:
        seq:
          - id: mipmaps
            size: _parent._parent._parent.data_size
            # TODO: mipmaps?
            #size: '_parent._parent._parent.texture_info.surface_count == 1
            #  ? _parent._parent._parent.data_size
            #  : _parent._parent._parent.texture_info.mipmap_sizes[_index]'
            #repeat: expr
            #repeat-expr: _parent._parent._parent.texture_info.num_mipmaps

enums:
  signature:
    0x4E_54_50_33: ntp3
    0x4E_54_57_55: ntwu
    0x4E_54_57_44: ntwd
    0x4E_54_4C_58: ntlx
  pixel_format:
    0x00: dxt1
    0x01: dxt3
    0x02: dxt5
    0x08: rgb16  # TODO...
    0x0C: rgba16 # TODO...
    0x0E: rgba   # TODO...
    0x0F: argb   # TODO...
  texture_type:
    0: dds
    1: gxt # TODO
