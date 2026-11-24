# Imported from https://github.com/Forlos/vn_re/blob/cce0798ad2771034cee74d1ea92d70efd2a4d27d/ksy/akb.ksy
meta:
  id: akb
  title: AKB image format
  file-extension: akb
  license: MIT
  endian: le

seq:
  - id: magic
    contents: "AKB "
  - id: width
    type: u2
  - id: height
    type: u2
  - id: compression
    type: u4
  - id: fill
    type: u4
  - id: left
    type: u4
  - id: top
    type: u4
  - id: right
    type: u4
  - id: bottom
    type: u4
  - id: image_data
    size-eos: true
