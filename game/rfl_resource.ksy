# Imported from https://gist.githubusercontent.com/ariankordi/3a594fa255032ee5e268bba77bc361fe/raw/27d52b1bcf63c483b568570a3c26b1228d9d63cc/r_f_l_resource.ksy
meta:
  id: rfl_resource
  #id: c_f_l_resource
  title: Resource archive image format for RFL, NFL, CFL.
  license: LicenseRef-All-Rights-Reserved
  endian: be # Set to BE for RFL.

seq:
  - id: total_archive_count
    type: u2
    doc: |
      Amount of total archives within the file.
      RFL = 18 (RFLiArcID_Max), NFL = 20 (?), CFL = 20 (CFLi_PARTS_ID_COUNT)
  - id: version
    type: u2
    doc: |
      Resource version. Set in RFL and CFL, only seen used in CFL debug mode.
      CFL bootloadDB2Res_: nn::dbg::detail::Printf("CFL: Cached Resource Version =
      0x%04x\n");
      / Debug assert; "cfl_resource.cpp",0x19d,"%s", "loader->mVersion >= 0x509"
  - id: offsets
    type: u4
    repeat: expr
    repeat-expr: total_archive_count
    doc: Offsets for each part type.

instances:
  archives:
    io: _root._io
    # Reads from each offset in the list.
    type: archive(_index)
    repeat: expr
    repeat-expr: total_archive_count  # Should match offsets' length.

types:
  archive:
    params:
      - id: i
        type: u4
    instances:
      arc_id:
        value: i
        enum: r_f_li_arc_id
        #enum: c_f_li_parts_id
      body:
        pos: _parent.offsets[i]
        size-eos: true
        type: r_f_li_archive
        # with this, last archive has 0 size
        #size: _parent.offsets[i + 1] - _parent.offsets[i]
  
  #filee:
  #  seq:
  #    - id: offset
  #      type: u4
  #  instances:
  #    as_shape:
  #      #size: _parent.maxsize
  #      type: r_f_li_shape
  #    as_texture:
  #      # TODO: 15 (NLINE_TEX), 17 (CAP_TEX)
  #      # have BLANK TEXTURES that do NOT USE
  #      # THE ENTIRE SIIZEEEE
  #      #size: _parent.maxsize
  #      #size-eos: true
  #      type: r_f_li_texture

  file:
    params:
      - id: i
        type: u4
    instances:
      as_shape:
        pos: 4+(sizeof<u4> * (_parent.num+1)) + _parent.offset[i]
        type: r_f_li_shape
        #type: c_f_li_shape
      as_texture:
        pos: 4+(sizeof<u4> * (_parent.num+1)) + _parent.offset[i]
        type: r_f_li_texture
        #type: c_f_li_tex_header

  r_f_li_archive:
    seq:
      - id: num
        type: u2
        doc: Number of files in the archive.
      - id: maxsize
        type: u2
        doc: Size of the biggest entry in the archive.
      - id: offset
        type: u4
        repeat: expr
        repeat-expr: num + 1
        doc: Offsets of each part in the archive.
    instances:
      files:
        type: file(_index)
        repeat: expr
        repeat-expr: num
        doc: Offsets of each part in the archive.

  c_f_li_tex_header:
    doc: |
      Image width and height are calculated by
      getting the next power of two. In JS:
      const nextPow2 = x => 1 << (32 - Math.clz32(x - 1));
    seq:
      - id: image_w
        type: u2
      - id: image_h
        type: u2
      - id: m_mipmap_size
        type: u1
      - id: m_format
        type: u1
      - id: m_wrap_s
        type: u1
      - id: m_wrap_t
        type: u1
      
  r_f_li_texture:
    seq:
      # TODO: verify
      - id: format
        type: u1
        enum: g_x_tex_fmt
        doc: GXTexFmt
        # enum in range
      - id: alpha
        type: u1
        doc: Unused
      - id: width
        type: u2
      - id: height
        type: u2
      - id: wrap_s
        type: u1
        doc: Only used in RFLiInitTexRes (RFL_Model.c).
        # enum in range
      - id: wrap_t
        type: u1
        doc: Only used in RFLiInitTexRes (RFL_Model.c).
        # enum in range
      - id: index_texture
        type: u1
        doc: Unused
      - id: color_format
        type: u1
        doc: Unused
      - id: num_colors
        type: u2
        doc: Unused
      - id: palette_ofs
        type: u4
        doc: Unused
      - id: enable_lod
        type: u1
        doc: Unused
      - id: enable_edge_lod
        type: u1
        doc: Only used in RFLiInitRFLTexture (Mask)
      - id: enable_bias_clamp
        type: u1
        doc: Only used in RFLiInitRFLTexture (Mask)
      - id: enable_max_aniso
        type: u1
        doc: Only used in RFLiInitRFLTexture (Mask)
      # enum in range:
      - id: min_filt
        type: u1
        doc: Only used in RFLiInitRFLTexture (Mask)
      - id: mag_filt
        type: u1
        doc: Only used in RFLiInitRFLTexture (Mask)
      - id: min_lod
        type: s1
        doc: Only used in RFLiInitRFLTexture (Mask)
      - id: max_lod
        type: s1
        doc: Only used in RFLiInitRFLTexture (Mask)
      - id: mipmap_level
        type: u1
        doc: Unused
      - id: reserved
        type: s1
        doc: Unused
      - id: lod_bias
        type: s2
        doc: Only used in RFLiInitRFLTexture (Mask)
      - id: image_ofs
        type: u4
        # not larger than size
    instances:
      image_data:
        pos: image_ofs
        # this reads until the ENTIRE END
        size-eos: true
        # the size varies based on tex format
        #size: width * height

  r_f_li_shape:
    doc: |
      NOTE: Untyped. Custom type.
      Real data is loaded from "res" in RFLiInitShapeRes
    seq:
      - id: identifier
        size: 4
        type: str
        encoding: ASCII
        doc: |
          4-byte identifier, unused by RFL.
          'nose', 'frhd', 'face', 'hair', 'cap_', 'berd', 'nsln', 'mask', 'glas'
          https://github.com/SMGCommunity/Petari/blob/6b6a7635d3ab985a5866be9ae4db09d52d678f6c/src/RVLFaceLib/RFL_Model.c#L835

      # Faceline transform fields.
      - id: nose_trans
        type: f4
        repeat: expr
        repeat-expr: 3
        if: is_faceline
      - id: beard_trans
        type: f4
        repeat: expr
        repeat-expr: 3
        if: is_faceline
      - id: hair_trans
        type: f4
        repeat: expr
        repeat-expr: 3
        if: is_faceline
      # Position attribute.
      - id: num_vtx_pos
        type: u2
      - id: vtx_pos
        #type: vec3_s16
        type: u2
        repeat: expr
        #repeat-expr: num_vtx_pos
        repeat-expr: num_vtx_pos * 3
      # Normal attribute.
      - id: num_vtx_nrm
        type: u2
      - id: vtx_nrm
        type: u2
        repeat: expr
        repeat-expr: num_vtx_nrm * 3
      # Texcoord attribute (unless skip_txc)
      - id: num_vtx_txc
        type: u2
        if: not skip_txc
      - id: vtx_txc
        type: u2
        repeat: expr
        repeat-expr: num_vtx_txc * 2
        if: not skip_txc
      # Primitives
      - id: prim_count
        type: u1
      - id: primitives
        type: primitive
        repeat: expr
        repeat-expr: prim_count

    instances:
      # NOTE: RFL does not use the identifier.
      # Should use RFLArcID instead.
      skip_txc:
        value: |
          identifier == "frhd" or
          identifier == "hair" or 
          identifier == "berd" or
          identifier == "nose"
      is_faceline:
        value: identifier == "face"

  # one primitive entry in the DL
  primitive:
    seq:
      - id: vtx_count
        type: u1
      - id: prim_type
        type: u1
        enum: g_x_primitive
      - id: vertices
        type: vertex
        repeat: expr
        repeat-expr: vtx_count

  # one vertex‐index tuple
  vertex:
    seq:
      - id: pos_idx
        type: u1
      - id: nrm_idx
        type: u1
      - id: tex_idx
        type: u1
        if: not _parent._parent.skip_txc  # match the r_f_li_shape skip_txc

  c_f_li_shape:
    doc: |
      NOTE: Untyped. Custom type.
      Real data is loaded from "res" in RFLiInitShapeRes
    seq:
      # Faceline transform fields.
      #- id: nose_trans
      #  type: f4
      #  repeat: expr
      #  repeat-expr: 3
      #  if: is_faceline
      #- id: beard_trans
      #  type: f4
      #  repeat: expr
      #  repeat-expr: 3
      #  if: is_faceline
      #- id: hair_trans
      #  type: f4
      #  repeat: expr
      #  repeat-expr: 3
      #  if: is_faceline
      - id: pos_size
        type: u2
      - id: nrm_size
        type: u2
      - id: tex_size
        type: u2
      - id: idx_size
        type: u2
      # Position attribute.
      - id: vtx_pos
        type: s2
        repeat: expr
        repeat-expr: pos_size * 3
      # Normal attribute.
      - id: vtx_nrm
        type: s2
        repeat: expr
        repeat-expr: nrm_size * 3
      # Texcoord attribute.
      - id: vtx_txc
        type: s2
        repeat: expr
        repeat-expr: tex_size * 2
      - id: u16_idx_flag
        type: u2
      - id: idx_count
        type: u2
        if: u16_idx_flag == 4
      - id: idx_buf
        type: u1
        repeat: expr
        repeat-expr: idx_count
        if: u16_idx_flag == 4
        
      # Primitives
      #- id: prim_count
      #  type: u1
      #- id: primitives
      #  type: primitive
      #  repeat: expr
      #  repeat-expr: prim_count
    #instances:
      # NOTE: RFL does not use the identifier.
      # Should use RFLArcID instead.
    #  skip_txc:
    #    value: |
    #      identifier == "frhd" or
    #      identifier == "hair" or 
    #      identifier == "berd" or
    #      identifier == "nose"
    #  is_faceline:
    #    value: identifier == "face"

enums:
  # https://github.com/SMGCommunity/Petari/blob/e98f96d0c2e3efd587584b15eaff298bf7d66d3d/libs/RVL_SDK/include/revolution/gx/GXEnum.h#L701
  g_x_primitive:
    0xB8: points
    0xA8: lines
    0xB0: linestrip
    0x90: triangles
    0x98: trianglestrip
    0xA0: trianglefan
    0x80: quads

  # https://github.com/SMGCommunity/Petari/blob/e98f96d0c2e3efd587584b15eaff298bf7d66d3d/libs/RVL_SDK/include/revolution/gx/GXEnum.h#L289
  g_x_tex_fmt:
    0x0: i4
    0x1: i8
    0x2: ia4
    0x3: ia8
    0x4: rgb565
    0x5: rgb5a3
    0x6: rgba8
    0xe: cmpr

  # https://github.com/SMGCommunity/Petari/blob/e98f96d0c2e3efd587584b15eaff298bf7d66d3d/libs/RVLFaceLib/include/RFLi_Types.h#L23
  r_f_li_arc_id:
    0:  beard
    1:  eye
    2:  eyebrow
    3:  faceline
    4:  face_tex
    5:  fore_head
    6:  glass
    7:  glass_tex
    8:  hair
    9:  mask
    10: mole
    11: mouth
    12: mustache
    13: nose
    14: nline
    15: nline_tex
    16: cap
    17: cap_tex
    18: max

  c_f_li_parts_id:
    0:  beard
    1:  cap
    2:  faceline
    3:  forehead
    4:  glass
    5:  hair
    6:  mask
    7:  nline
    8:  nose
    9:  captex
    #9: shape_count
    10: eye
    11: eyebrow
    12: face_t_beard
    13: face_t_line
    14: face_t_make
    15: glasstex
    16: mole
    17: mouth
    18: mustache
    19: nlinetex
    20: count
