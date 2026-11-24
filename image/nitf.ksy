meta:
  id: nitf
  title: National Imagery Transmission Format
  file-extension:
    - ntf
    - nitf
    - ntf.r0
    - ntf.r1
    - ntf.r2
    - ntf.r3
    - ntf.r4
    - ntf.r5
  xref:
    justsolve: National_Imagery_Transmission_Format
    pronom: fmt/366 # NITF 2.1
    wikidata: Q1961044
  license: MIT
  ks-version: 0.8
  encoding: UTF-8
  endian: be
doc: |
  The NITF (National Image Transition Format) format is a file format developed by
  the U.S. Government for
  storing imagery, e.g. from satellites.

  According to the [foreword of the specification](https://web.archive.org/web/20181105050336/https://www.gwg.nga.mil/ntb/baseline/docs/2500c/2500C.pdf):
  > The National Imagery Transmission Format Standard (NITFS) is the suite of standards for formatting digital
  > imagery and imagery-related products and exchanging them among members of the Intelligence Community (IC) as
  > defined by the Executive Order 12333, and other United States Government departments and agencies."

  This implementation is set to version format (`file_version`) of 02.10 and
  `standard_type` of `BF01`.
  It was implemented by [River Loop Security](https://www.riverloopsecurity.com/).
doc-ref: https://web.archive.org/web/20181105050336/https://www.gwg.nga.mil/ntb/baseline/docs/2500c/2500C.pdf
seq:
  - id: header
    type: header
  - id: image_segments
    type: image_segment(_index)
    repeat: expr
    repeat-expr: header.num_image_segments.to_i
  - id: graphics_segments
    type: graphics_segment(_index)
    repeat: expr
    repeat-expr: header.num_graphics_segments.to_i
  - id: text_segments
    type: text_segment(_index)
    repeat: expr
    repeat-expr: header.num_text_files.to_i
  - id: data_extension_segments
    type: data_extension_segment(_index)
    repeat: expr
    repeat-expr: header.num_data_extension.to_i
  - id: reserved_extension_segments
    type: reserved_extension_segment(_index)
    repeat: expr
    repeat-expr: header.num_reserved_extension.to_i
types:
  header:
    seq:
      - id: file_profile_name
        -orig-id: fhdr
        contents: 'NITF'
      - id: file_version
        -orig-id: fver
        contents: '02.10'
      - id: complexity_level
        -orig-id: clevel
        size: 2
      - id: standard_type
        -orig-id: stype
        contents: 'BF01'
        doc: Value of BF01 indicates the file is formatted using ISO/IEC IS 12087-5.
      - id: originating_station_id
        -orig-id: ostaid
        size: 10
        type: str
      - id: file_date_time
        -orig-id: fdt
        type: date_time
      - id: file_title
        -orig-id: ftitle
        size: 80
        type: str
      - id: file_security
        -orig-id: fclasnfo
        type: clasnfo
      - id: file_copy_number
        -orig-id: fscop
        size: 5
        type: str
      - id: file_num_of_copys
        -orig-id: fscpys
        size: 5
        type: str
      - id: encryption
        -orig-id: encryp
        type: encrypt
      - id: file_bg_color
        -orig-id: fbkgc
        size: 3
      - id: originator_name
        -orig-id: oname
        size: 24
        type: str
      - id: originator_phone
        -orig-id: ophone
        size: 18
        type: str
      - id: file_length
        -orig-id: fl
        size: 12
        type: str
      - id: file_header_length
        -orig-id: hl
        size: 6
        type: str
      - id: num_image_segments
        -orig-id: numi
        size: 3
        type: str
      - id: linfo
        type: length_image_info
        repeat: expr
        repeat-expr: num_image_segments.to_i
      - id: num_graphics_segments
        -orig-id: nums
        size: 3
        type: str
      - id: lnnfo
        type: length_graphic_info
        repeat: expr
        repeat-expr: num_graphics_segments.to_i
      - id: reserved_numx
        -orig-id: numx
        size: 3
        type: str
      - id: num_text_files
        -orig-id: numt
        size: 3
        type: str
      - id: ltnfo
        type: length_text_info
        repeat: expr
        repeat-expr: num_text_files.to_i
      - id: num_data_extension
        -orig-id: numdes
        size: 3
        type: str
      - id: ldnfo
        type: length_data_info
        repeat: expr
        repeat-expr: num_data_extension.to_i
      - id: num_reserved_extension
        -orig-id: numres
        size: 3
        type: str
      - id: lrnfo
        type: length_reserved_info
        repeat: expr
        repeat-expr: num_reserved_extension.to_i
      - id: user_defined_header
        type: tre_header
      - id: extended_header
        type: tre_header
  date_time:
    seq:
      - size: 14
        type: str
        doc: |
          UTC time of image acquisition in the format CCYYMMDDhhmmss: CC century, YY last
          two digits of the year, MM month, DD day, hh hour, mm minute, ss second
  encrypt:
    seq:
      - size: 1
        type: str
  clasnfo:
    seq:
      - id: security_class
        -orig-id: sclas
        size: 1
        type: str
      - id: security_system
        -orig-id: sclsy
        size: 2
        type: str
      - id: codewords
        -orig-id: scode
        size: 11
        type: str
      - id: control_and_handling
        -orig-id: sctlh
        size: 2
        type: str
      - id: releaseability
        -orig-id: srel
        size: 20
        type: str
      - id: declass_type
        -orig-id: sdctp
        size: 2
        type: str
      - id: declass_date
        -orig-id: sdcdt
        size: 8
        type: str
      - id: declass_exemption
        -orig-id: sdcxm
        size: 4
        type: str
      - id: downgrade
        -orig-id: sdg
        size: 1
        type: str
      - id: downgrade_date
        -orig-id: sdgdt
        size: 8
        type: str
      - id: class_text
        -orig-id: scltx
        size: 43
        type: str
      - id: class_authority_type
        -orig-id: scatp
        size: 1
        type: str
      - id: class_authority
        -orig-id: scaut
        size: 40
        type: str
      - id: class_reason
        -orig-id: scrsn
        size: 1
        type: str
      - id: source_date
        -orig-id: ssrdt
        size: 8
        type: str
      - id: control_number
        -orig-id: sctln
        size: 15
        type: str
  length_image_info:
    seq:
      - id: length_image_subheader
        -orig-id: lish
        size: 6
        type: str
      - id: length_image_segment
        -orig-id: li
        size: 10
        type: str
  length_graphic_info:
    seq:
      - id: length_graphic_subheader
        -orig-id: lssh
        size: 4
        type: str
      - id: length_graphic_segment
        -orig-id: ls
        size: 6
        type: str
  length_text_info:
    seq:
      - id: length_text_subheader
        -orig-id: ltsh
        size: 4
        type: str
      - id: length_text_segment
        -orig-id: lt
        size: 5
        type: str
  length_data_info:
    seq:
      - id: length_data_extension_subheader
        -orig-id: ldsh
        size: 4
        type: str
      - id: length_data_extension_segment
        -orig-id: ld
        size: 9
        type: str
  length_reserved_info:
    seq:
      - id: length_reserved_extension_subheader
        -orig-id: lresh
        size: 4
        type: str
      - id: length_reserved_extension_segment
        -orig-id: lre
        size: 7
        type: str
  image_segment:
    params:
      - id: idx
        type: u2
    seq:
      - id: image_sub_header
        type: image_sub_header
      - id: image_data_mask
        type: image_data_mask
        if: has_mask
      - id: image_data_field
        size: 'has_mask ? _parent.header.linfo[idx].length_image_segment.to_i - image_data_mask.total_size : _parent.header.linfo[idx].length_image_segment.to_i'
    instances:
      has_mask:
        value: image_sub_header.img_compression.substring(0, 1) == 'M' or image_sub_header.img_compression.substring(1, 2) == 'M'
  image_sub_header:
    seq:
      - id: file_part_type
        -orig-id: im
        contents: 'IM'
      - id: image_id_1
        -orig-id: iid1
        size: 10
        type: str
      - id: image_date_time
        -orig-id: idatim
        type: date_time
      - id: target_id
        -orig-id: tgtid
        size: 17
        type: str
      - id: image_id_2
        -orig-id: iid2
        size: 80
        type: str
      - id: image_security_classification
        -orig-id: iclasnfo
        type: clasnfo
      - id: encryption
        -orig-id: encryp
        type: encrypt
      - id: image_source
        -orig-id: isorce
        size: 42
        type: str
      - id: num_sig_rows
        -orig-id: nrows
        size: 8
        type: str
        doc: |
          Total number of rows of significant pixels in the image; only rows indexed 0 to
          (NROWS - 1) of the image contain significant data.
      - id: num_sig_cols
        -orig-id: ncols
        size: 8
        type: str
      - id: pixel_value_type
        -orig-id: pvtype
        size: 3
        type: str
      - id: image_representation
        -orig-id: irep
        size: 8
        type: str
        doc: MONO, RGB, RGB/LUT, MULTI, NODISPLY, NVECTOR, POLAR, VPH, YCbCr601
      - id: image_category
        -orig-id: icat
        size: 8
        type: str
        doc: |
          VIS, SL, TI, FL, RD, EO, OP, HR, HS,CP, BP, SAR, SARIQ, IR, MAP, MS, FP, MRI,
          XRAY, CAT, VD, PAT, LEG, DTEM, MATR, LOCG, BARO, CURRENT, DEPTH, WIND
      - id: actual_bits_per_pixel_per_band
        -orig-id: abpp
        size: 2
        type: str
      - id: pixel_justification
        -orig-id: pjust
        size: 1
        type: str
      - id: image_coordinate_rep
        -orig-id: icords
        size: 1
        type: str
      - id: image_geo_loc
        -orig-id: igeolo
        size: 60
        type: str
        if: image_coordinate_rep != ' '
      - id: num_img_comments
        -orig-id: nicom
        size: 1
        type: str
      - id: img_comments
        -orig-id: icom
        type: image_comment
        repeat: expr
        repeat-expr: num_img_comments.to_i
      - id: img_compression
        -orig-id: ic
        size: 2
        type: str
      - id: compression_rate_code
        -orig-id: comrat
        size: 4
        type: str
        if: img_compression.substring(0, 1) != 'N'
      - id: num_bands
        -orig-id: nbands
        size: 1
        type: str
      - id: num_multispectral_bands
        -orig-id: xbands
        size: 5
        type: str
        if: num_bands.to_i == 0
      - id: bands
        type: band_info
        repeat: expr
        repeat-expr: "num_bands.to_i != 0 ? num_bands.to_i : num_multispectral_bands.to_i"
      - id: img_sync_code
        -orig-id: isync
        size: 1
        type: str
        doc: Reserved for future use.
      - id: img_mode
        -orig-id: imode
        size: 1
        type: str
        doc: |
          B = Band Interleaved by Block, P = Band Interleaved by Pixel, R = Band
          Interleaved by Row, S = Band Sequential
      - id: num_blocks_per_row
        -orig-id: nbpr
        size: 4
        type: str
      - id: num_blocks_per_col
        -orig-id: nbpc
        size: 4
        type: str
      - id: num_pixels_per_block_horz
        -orig-id: nppbh
        size: 4
        type: str
      - id: num_pixels_per_block_vert
        -orig-id: nppbv
        size: 4
        type: str
      - id: num_pixels_per_band
        -orig-id: nbpp
        size: 2
        type: str
      - id: img_display_level
        -orig-id: idlvl
        size: 3
        type: str
      - id: attachment_level
        -orig-id: ialvl
        size: 3
        type: str
      - id: img_location
        -orig-id: iloc
        size: 10
        type: str
      - id: img_magnification
        -orig-id: imag
        size: 4
        type: str
      - id: user_def_img_data_len
        -orig-id: udidl
        size: 5
        type: str
      - id: user_def_overflow
        -orig-id: udofl
        size: 3
        type: str
        if: user_def_img_data_len.to_i != 0
      - id: user_def_img_data
        -orig-id: udid
        type: u1
        repeat: expr
        repeat-expr: user_def_img_data_len.to_i - 3
        if: user_def_img_data_len.to_i > 2
      - id: image_extended_sub_header
        type: tre_header
  band_info:
    seq:
      - id: representation
        -orig-id: irepband
        size: 2
        type: str
        doc: |
          Indicates processing required to display the nth band of image w.r.t. the
          general image type recorded by IREP field
      - id: subcategory
        -orig-id: isubcat
        size: 6
        type: str
      - id: img_filter_condition
        -orig-id: ifc
        contents: 'N'
      - id: img_filter_code
        -orig-id: imflt
        size: 3
        type: str
        doc: Reserved
      - id: num_luts
        -orig-id: nluts
        size: 1
        type: str
      - id: num_lut_entries
        -orig-id: nelut
        size: 5
        type: str
        if: num_luts.to_i != 0
        doc: Number of entries in each of the LUTs for the nth image band
      - id: luts
        -orig-id: lutd
        size: num_lut_entries.to_i
        repeat: expr
        repeat-expr: num_luts.to_i
  image_comment:
    seq:
      - size: 80
        type: str
  image_data_mask:
    seq:
      - id: blocked_img_data_offset
        -orig-id: imdatoff
        type: u4
      - id: bmrlnth
        type: u2
        doc: Block Mask Record Length
      - id: tmrlnth
        type: u2
        doc: Pad Pixel Mask Record Length
      - id: tpxcdlnth
        type: u2
        doc: Pad Output Pixel Code Length
      - id: tpxcd
        size: tpxcd_size
        doc: Pad Output Pixel Code
      - id: bmrbnd
        type: u4
        repeat: expr
        repeat-expr: bmrtmr_count
        if: has_bmr
        doc: Block n, Band m Offset
      - id: tmrbnd
        type: u4
        repeat: expr
        repeat-expr: bmrtmr_count
        if: has_tmr
        doc: Pad Pixel n, Band m
    instances:
      tpxcd_size:
        value: "(tpxcdlnth % 8 == 0 ? tpxcdlnth : tpxcdlnth + (8 - tpxcdlnth % 8)) / 8"
      bmrtmr_count:
        value: >
          _parent.image_sub_header.num_blocks_per_row.to_i * _parent.image_sub_header.num_blocks_per_col.to_i *
          (_parent.image_sub_header.img_mode != 'S' ?
            1 :
            (_parent.image_sub_header.num_bands.to_i != 0 ?
              _parent.image_sub_header.num_bands.to_i :
              _parent.image_sub_header.num_multispectral_bands.to_i))
      has_bmr:
        value: bmrlnth != 0
      has_tmr:
        value: tmrlnth != 0
      bmrbnd_size:
        value: "has_bmr ? bmrtmr_count * 4 : 0"
      tmrbnd_size:
        value: "has_tmr ? bmrtmr_count * 4 : 0"
      total_size:
        value: 4 + 2 + 2 + 2 + tpxcd_size + bmrbnd_size + tmrbnd_size
  graphics_segment:
    params:
      - id: idx
        type: u2
    seq:
      - id: graphic_sub_header
        type: graphic_sub_header
      - id: graphic_data_field
        size: _parent.header.lnnfo[idx].length_graphic_segment.to_i
  graphic_sub_header:
    seq:
      - id: file_part_type_sy
        -orig-id: sy
        contents: 'SY'
      - id: graphic_id
        -orig-id: sid
        size: 10
        type: str
      - id: graphic_name
        -orig-id: sname
        size: 20
        type: str
      - id: graphic_classification
        -orig-id: sclasnfo
        type: clasnfo
      - id: encryption
        -orig-id: encryp
        type: encrypt
      - id: graphic_type
        -orig-id: sfmt
        contents: 'C'
      - id: reserved1
        -orig-id: sstruct
        size: 13
        type: str
        doc: Reserved
      - id: graphic_display_level
        -orig-id: sdlvl
        size: 3
        type: str
      - id: graphic_attachment_level
        -orig-id: salvl
        size: 3
        type: str
      - id: graphic_location
        -orig-id: sloc
        size: 10
        type: str
      - id: first_graphic_bound_loc
        -orig-id: sbnd1
        size: 10
        type: str
      - id: graphic_color
        -orig-id: scolor
        size: 1
        type: str
      - id: second_graphic_bound_loc
        -orig-id: sbnd2
        size: 10
        type: str
      - id: reserved2
        -orig-id: sres2
        size: 2
        type: str
        doc: Reserved
      - id: graphics_extended_sub_header
        type: tre_header
  tre_header:
    seq:
      - id: header_data_length
        -orig-id: hdl
        size: 5
        type: str
      - id: header_overflow
        -orig-id: ofl
        size: 3
        type: str
        if: header_data_length.to_i != 0
      - id: tres
        size: header_data_length.to_i - 3
        type: tre_entries
        if: header_data_length.to_i != 0
  text_segment:
    params:
      - id: idx
        type: u2
    seq:
      - id: text_sub_header
        size: 1
      - id: text_data_field
        size: _parent.header.ltnfo[idx].length_text_segment.to_i
  text_sub_header:
    seq:
      - id: text_date_time
        -orig-id: txtdt
        size: 14
        type: str
      - id: text_title
        -orig-id: txtitl
        size: 80
        type: str
      - id: text_security_class
        -orig-id: tclasnfo
        type: clasnfo
      - id: encryp
        type: encrypt
      - id: text_format
        -orig-id: txtfmt
        size: 3
        type: str
        doc: MTF (USMTF see MIL-STD-6040), STA (indicates BCS), UT1 (indicates ECS), U8S
      - id: text_extended_sub_header
        type: tre_header
  data_extension_segment:
    params:
      - id: idx
        type: u2
    seq:
      - id: data_sub_header
        size: _parent.header.ldnfo[idx].length_data_extension_subheader.to_i
        type: data_sub_header
      - id: data_data_field
        size: _parent.header.ldnfo[idx].length_data_extension_segment.to_i
  data_sub_header_base:
    seq:
      - id: file_part_type_de
        -orig-id: de
        contents: 'DE'
        doc: File Part Type desigantor for Data Extension
      - id: desid
        size: 25
        type: str
      - id: data_definition_version
        -orig-id: desver
        size: 2
        type: str
      - id: declasnfo
        type: clasnfo
  data_sub_header:
    seq:
      - id: des_base
        type: data_sub_header_base
      - id: overflowed_header_type
        -orig-id: desoflw
        size: 6
        type: str
        if: tre_ofl
      - id: data_item_overflowed
        -orig-id: desitem
        size: 3
        type: str
        if: tre_ofl
      - id: des_defined_subheader_fields_len
        -orig-id: desshl
        size: 4
        type: str
      - id: desshf
        size: des_defined_subheader_fields_len.to_i
        type: str
      - id: des_defined_data_field
        -orig-id: desdata
        size-eos: true
        type: str
    instances:
      tre_ofl:
        value: des_base.desid == 'TRE_OVERFLOW'
  data_sub_header_tre:
    seq:
      - id: des_base
        type: data_sub_header_base
      - id: overflowed_header_type
        -orig-id: desoflw
        size: 6
        type: str
        if: des_base.desid == 'TRE_OVERFLOW'
      - id: data_item_overflowed
        -orig-id: desitem
        size: 3
        type: str
        if: des_base.desid == 'TRE_OVERFLOW'
      - id: des_defined_subheader_fields_len
        -orig-id: desshl
        size: 4
        type: str
      - id: des_defined_data_field
        -orig-id: desdata
        size: des_defined_subheader_fields_len.to_i
        type: str
  data_sub_header_streaming:
    doc: Streaming file Header Data Extension Segment Subheader
    seq:
      - id: des_base
        type: data_sub_header_base
      - id: des_defined_subheader_fields_len
        -orig-id: desshl
        size: 4
        type: str
      - id: sfh_l1
        size: 7
        type: str
        doc: 'SFH Length 1: number of bytes in sfh_dr field'
      - id: sfh_delim1
        type: u4
        doc: Shall contain the value 0x0A6E1D97.
      - id: sfh_dr
        type: u1
        repeat: expr
        repeat-expr: sfh_l1.to_i
      - id: sfh_delim2
        type: u4
        doc: Shall contain the value 0x0ECA14BF.
      - id: sfh_l2
        size: 7
        type: str
        doc: A repeat of sfh_l1.
  reserved_extension_segment:
    params:
      - id: idx
        type: u2
    seq:
      - id: reserved_sub_header
        size: _parent.header.lrnfo[idx].length_reserved_extension_subheader.to_i
        type: reserved_sub_header
      - id: reserved_data_field
        size: _parent.header.lrnfo[idx].length_reserved_extension_segment.to_i
  reserved_sub_header:
    seq:
      - id: file_part_type_re
        -orig-id: re
        contents: 'RE'
      - id: res_type_id
        -orig-id: resid
        size: 25
        type: str
      - id: res_version
        -orig-id: resver
        size: 2
        type: str
      - id: reclasnfo
        type: clasnfo
      - id: res_user_defined_subheader_length
        -orig-id: resshl
        size: 4
        type: str
      - id: res_user_defined_subheader_fields
        -orig-id: resshf
        size: res_user_defined_subheader_length.to_i
        type: str
      - id: res_user_defined_data
        -orig-id: resdata
        size-eos: true
        type: str
  tre:
    seq:
      - id: extension_type_id
        -orig-id: etag
        size: 6
        type: str
        doc: RETAG or CETAG
      - id: edata_length
        -orig-id: el
        size: 5
        type: str
        doc: REL or CEL
      - id: edata
        size: edata_length.to_i
        type: str
        doc: REDATA or CEDATA
  tre_entries:
    seq:
      - id: entries
        type: tre
        repeat: eos
