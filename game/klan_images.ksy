# Imported from https://github.com/deefha/klan2016-re/blob/e48e34b7abbc9da902e03c0763f48bb7ede2582f/structs/images.ksy
meta:
  id: klan_images
  title: KLAN images library
  application: KLAN discmag engine
  file-extension: lib
  license: LicenseRef-All-Rights-Reserved
  imports:
    - klan_t_header
  encoding: ASCII
  endian: le

doc-ref: https://wiki.klan2016.cz/knihovny/obrazky.html

seq:
  - id: header
    type: klan_t_header
  - id: fat
    type: t_fat
  - id: data
    type: t_data

types:
  t_fat:
    seq:
      - id: count
        type: u4
      - id: foo_1
        type: u4
      - id: foo_2
        type: u4
      - id: foo_3
        type: u4
      - id: offsets
        type: u4
        repeat: expr
        repeat-expr: 8192

  t_data:
    instances:
      images:
        type: t_image(_parent.fat.offsets[_index])
        repeat: expr
        repeat-expr: 8192
      
  t_image:
    params:
      - id: param_offset
        type: u4
    instances:
      content:
        pos: param_offset
        type: t_image_content
        if: param_offset != 0

  t_image_content:
    seq:
      - id: data_size
        type: u4
      - id: width
        type: u2
      - id: height
        type: u2
      - id: mode
        type: u2
      - id: foo
        size: 6
      - id: data
        type:
          switch-on: mode
          cases:
            1: t_image_data_indexed(data_size)
            4: t_image_data_lossy(data_size)
            5: t_image_data_rgb565(data_size)
            256: t_image_data_indexed(data_size)
            257: t_image_data_indexed(data_size)
            258: t_image_data_indexed(data_size)
            261: t_image_data_rgb565(data_size)

  t_image_data_common:
    params:
      - id: param_data_size
        type: u4
    seq:
      - id: content
        size: param_data_size

  t_image_data_indexed:
    params:
      - id: param_data_size
        type: u4
    seq:
      - id: colormap
        size: 768
      - id: content
        size: param_data_size - 768

  t_image_data_lossy:
    params:
      - id: param_data_size
        type: u4
    seq:
      - id: quality
        type: u4
      - id: hufftree_size
        type: u4
      - id: hufftree
        size: hufftree_size
      - id: content
        size: param_data_size - 4 - 4 - hufftree_size

  t_image_data_rgb565:
    params:
      - id: param_data_size
        type: u4
    seq:
      - id: content
        size: param_data_size
