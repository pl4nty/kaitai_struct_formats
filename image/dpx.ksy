# Imported from https://github.com/robin-francois/dpx-kaitai-struct/blob/afbf0ff39a5eaac67a169cf93f6f9425fd0c14a2/dpx_struct.ksy
# Licence and copyright: see _community/README.md
meta:
  id: dpx
  file-extension: dpx
  license: GPL-3.0-only

seq:
  - id: magic
    size: 4
  - id: body
    type: body
    
types:
  body:
    meta:
      endian:
        switch-on: _root.magic
        cases:
          '[0x53, 0x44, 0x50, 0x58]': be
          '[0x58, 0x50, 0x44, 0x53]': le
    seq: 
      - id: file_header
        size: 764
        type: file_header
      - id: image_header
        size: 640
        type: image_header
      - id: orientation_header
        size: 256
        type: orientation_header
      - id: film_information_header
        size: 256
        type: film_information_header
      - id: television_information_header
        size: 128
        type: television_information_header
      - id: user_defined_header
        size: file_header.user_size
        if: file_header.user_size != 0
      - id: image_data
        size: file_header.file_size - (file_header.generic_size+file_header.industry_size+file_header.user_size)
    types:
      image_header:
        seq:
          - id: orientation
            type: u2
            enum: orientation_enum
          - id: number_elements
            type: u2
          - id: pixels_per_line
            type: u4
          - id: lines_per_element
            type: u4
          - id: image_element_array
            type: image_element
            repeat: expr
            repeat-expr: 8
          - id: reserved_image
            size: 52
      image_element:
        seq:
          - id: data_sign
            type: u4
          - id: low_data
            type: u4
          - id: low_quantity
            type: f4
          - id: high_data
            type: u4
          - id: high_quantity
            type: f4
          - id: descriptor
            type: u1
            enum: descriptor
          - id: transfer
            type: u1
            enum: transfer_colorimetric
          - id: colorimetric
            type: u1
            enum: transfer_colorimetric
          - id: bit_size
            type: u1
          - id: packing
            type: u2
          - id: encoding
            type: u2
          - id: data_offset
            type: u4
          - id: end_of_line_padding
            type: u4
          - id: end_of_image_padding
            type: u4
          - id: description
            size: 32
            type: str
            encoding: ASCII
      orientation_header:
        seq:
          - id: x_offset
            type: u4
          - id: y_offset
            type: u4
          - id: x_center
            type: f4
          - id: y_center
            type: f4
          - id: x_original_size
            type: u4
          - id: y_original_size
            type: u4
          - id: file_name
            size: 100
            type: str
            encoding: ASCII
          - id: time_date
            size: 24              
            type: str
            encoding: ASCII
          - id: input_name
            size: 32                 
            type: str
            encoding: ASCII
          - id: input_sn
            size: 32
            type: str
            encoding: ASCII
          - id: border
            size: 8
          - id: aspect_ratio
            size: 8
          - id: x_scanned_size
            type: f4
          - id: y_scanned_size
            type: f4
          - id: reserved_o
            size: 20
      file_header:
        seq:
          - id: image_offset
            type: u4
          - id: version
            size: 8
            type: str
            encoding: ASCII
          - id: file_size
            type: u4
          - id: ditto_key
            size: 4
          - id: generic_size
            type: u4
          - id: industry_size
            type: u4
          - id: user_size
            type: u4
          - id: filename
            size: 100
            type: str
            encoding: ASCII
          - id:  timedate
            size: 24
            type: str
            encoding: ASCII
          - id: creator
            size: 100
            type: str
            encoding: ASCII
          - id: project
            size: 200
            type: str
            encoding: ASCII
          - id: copyright
            size: 200
            type: str
            encoding: ASCII
          - id: encryption_key
            type: u4
          - id: reserved
            size: 104
      television_information_header:
        seq:
          - id: time_code
            type: u4
          - id: user_bits
            type: u4
          - id: interlace
            type: u1
          - id: field_number
            type: u1
          - id: video_signal
            type: u1
          - id: padding
            type: u1
          - id: horz_sample_rate
            type: f4
          - id: vert_sample_rate
            type: f4
          - id: frame_rate
            type: f4
          - id: time_offset
            type: f4
          - id: gamma
            type: f4
          - id: black_level
            type: f4
          - id: black_gain
            type: f4
          - id: breakpoint
            type: f4
          - id: white_level
            type: f4
          - id: integration_times
            type: f4
          - id: reserved_t
            size: 76
      film_information_header:
        seq:
          - id: film_mfg_id
            size: 2
            type: str
            encoding: ASCII
          - id: film_type
            size: 2
            type: str
            encoding: ASCII
          - id: offset
            size: 2
            type: str
            encoding: ASCII
          - id: prefix
            size: 6
            type: str
            encoding: ASCII
          - id: count
            size: 4
            type: str
            encoding: ASCII
          - id: format
            size: 32 
            type: str
            encoding: ASCII
          - id: frame_position
            type: u4
          - id: sequence_len
            type: u4
          - id: held_count
            type: u4
          - id: frame_rate
            type: f4
          - id: shutter_angle
            type: f4
          - id: frame_id
            size: 32
            type: str
            encoding: ASCII
          - id: slate_info
            size: 100
            type: str
            encoding: ASCII
          - id: reserved_f
            size: 56
    enums:
      orientation_enum:
        0: l2rt2b
        1: r2lt2b
        2: l2rb2t
        3: r2lb2t
        4: t2bl2r
        5: t2br2f
        6: b2tl2r
        7: b2tr2l
      descriptor:
        0: user_defined
        1: red
        2: green
        3: blue
        4: alpha
        6: luminance_y
        7: chrominance_uv
        8: depth
        9: composite_video
        50: rgb
        51: rgba
        52: abgr
        100: cbycry
        101: cbyacrya
        102: cbycr
        103: cbycra
      transfer_colorimetric: 
        0: user_defined
        1: printing_density
        2: linear
        3: logarithmic
        4: unspecified_video
        5: smpte_240m
        6: ccir_709_1
        7: ccir_601_2_system_b_or_g
        8: ccir_601_2_system_m
        9: ntsc_composite
        10: pal_composite
        11: z_linear
        12: z_homogeneous
