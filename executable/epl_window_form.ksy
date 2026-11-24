# Imported from https://github.com/EplExplorer/MicroLoader/blob/091359f586234a467074554cb6a368f4412c1202/tools/窗口解析.ksy
# Licence and copyright: see _community/README.md
meta:
  id: epl_window_form
  title: EPL (Easy Programming Language) window form data
  license: GPL-3.0-only

seq:
  - id: form_infos
    type: form_infos

types:
  form_infos:
    doc: 窗口信息列表
    seq:
      - id: block
        type: block_id_and_address
      - id: infos
        type: form_info
        repeat: expr
        repeat-expr: block.length / 8

  form_info:
    doc: 窗口信息
    seq:
      - id: unk_before_class
        type: u4le
      - id: class
        type: u4le
      - id: name
        type: string_with_length_prefix
      - id: comment
        type: string_with_length_prefix
      - id: form_elements
        type: form_elements

  form_elements:
    doc: 组件信息列表
    seq:
      - id: block
        type: block_id_and_offest
      - id: form_element
        type: form_element
        repeat: expr
        repeat-expr: block.count
  
  form_element:
    doc: 组件信息
    seq:
      - id: length
        type: u4le
      - id: data_type
        type: u4le
        doc: 组件类型
      - id: data
        type: u1
        repeat: expr
        repeat-expr: length - 4
        doc: 组件属性数据
  
  string_with_length_prefix:
    doc: 长度+字符串
    seq:
      - id: length
        type: u4le
      - id: data
        type: u1
        repeat: expr
        repeat-expr: length

  block_id_and_offest:
    doc: 头部带有id和偏移量的块
    seq:
      - id: count
        type: u4le
      - id: size
        type: u4le
      - id: id_list
        type: u4le
        repeat: expr
        repeat-expr: count
      - id: offset_list
        type: u4le
        repeat: expr
        repeat-expr: count

  block_id_and_address:
    doc: 头部带有id和地址的块
    seq:
      - id: length
        type: u4le
      - id: id_list
        type: u4le
        repeat: expr
        repeat-expr: length / 8
      - id: address_list
        type: u4le
        repeat: expr
        repeat-expr: length / 8
    
