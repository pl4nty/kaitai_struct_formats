# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/android_imgdata/android_imgdata.ksy
# Licence and copyright: see _community/README.md
meta:
  id: android_imgdata
  title: LG Android imgdata
  license: CC0-1.0
  encoding: UTF-8
  endian: le
doc-ref:
  https://github.com/NVISOsecurity/nexus_5_bootloader_unpacker/blob/master/imgdata_tool.c
  https://gist.github.com/shinyquagsire23/ba0f6209592d50fb8e4166620228aaa5
seq:
  - id: header
    type: header
  - id: images
    type: image
    repeat: expr
    repeat-expr: header.num_files
types:
  header:
    seq:
      - id: magic
        contents: "IMGDATA!"
      - id: unknown
        type: u4
      - id: num_files
        type: u4
      - id: padding
        size: 8
  image:
    seq:
      - id: name
        size: 16
        type: strz
      - id: image_width
        -orig-id: imgwidth
        type: u4
      - id: image_height
        -orig-id: imgheight
        type: u4
      - id: screen_x_position
        -orig-id: scrxpos
        type: u4
      - id: screen_y_position
        -orig-id: scrypos
        type: u4
      - id: ofs_image
        -orig-id: offset
        type: u4
      - id: len_image
        -orig-id: size
        type: u4
    instances:
      image_body:
        io: _root._io
        pos: ofs_image
        size: len_image
