# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/huawei_hwnp/hwnp.ksy
meta:
  id: huawei_hwnp
  title: Huawei HWNP
  license: Unlicense
  encoding: UTF-8
  endian: le
doc: |
  Test files: https://www.zhiwanyuzhou.com/download/Firmware/Router/Huawei/HG/HG8245V100R006C00SPC205%20Software/
doc-ref:
  - https://github.com/0xuserpag3/HuaweiFirmwareTool
seq:
  - id: header
    type: header
  - id: products_and_items
    size: header.len_header
    type: products_and_items
types:
  header:
    seq:
      - id: magic
        contents: 'HWNP'
      - id: len_data
        type: u4
      - id: crc32
        type: u4
      - id: len_header
        type: u4
      - id: header_crc32
        type: u4
      - id: num_items
        type: u4
      - id: unknown
        size: 2
      - id: len_product_list
        type: u2
      - id: len_item
        type: u4
      - id: reserved
        size: 4
  products_and_items:
    seq:
      - id: product_list
        size: _root.header.len_product_list
      - id: items
        size: _root.header.len_item
        type: item
        repeat: expr
        repeat-expr: _root.header.num_items
  item:
    seq:
      - id: iter
        type: u4
      - id: crc32
        type: u4
      - id: ofs_data
        type: u4
      - id: len_data
        type: u4
      - id: name
        size: 256
        type: strz
      - id: section
        size: 16
        type: strz
      - id: version
        size: 64
        type: strz
      - id: policy
        type: u4
      - id: reserved
        size: 4
    instances:
      data:
        io: _root._io
        pos: ofs_data
        size: len_data
