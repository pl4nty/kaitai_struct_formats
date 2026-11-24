# Imported from https://github.com/master801/Out-of-Translation/blob/9bc9f0ea0805dfa5064ee9238ec7be2957a4111a/Formats/CharMenuParam.bin.ksy
meta:
  id: out_of_translation_char_menu_param
  title: CharMenuParam
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-8
seq:
  - id: blocks
    size: 0x264
    type: block
    repeat: eos
types:
  block:
    seq:
      - id: index
        type: u4le
      - id: id
        type: u4le
      - id: title
        size: 0x40
        type: strz
      - id: text_1
        size: 0x100
        type: strz
      - id: unknown_1
        type: u4le
      - id: unknown_2
        type: u4le
      - id: text_2
        size: 0x80
        type: strz
      - id: unknown_3
        type: u4le
      - id: unknown_4
        type: u4le
      - id: unknown_5
        type: u4le
      - id: unknown_6
        type: u4le
      - id: unknown_7
        type: u4le
      - id: unknown_8
        type: u4le
      - id: unknown_9
        type: u4le
      - id: unknown_10
        type: u4le
      - id: unknown_11
        type: u4le
      - id: unknown_12
        type: u4le
      - id: unknown_13
        type: u4le
      - id: unknown_14
        type: u4le
      - id: unknown_15
        size: 0x4
      - id: unknown_16
        type: u4le
      - id: unknown_17
        type: u4le
      - id: unknown_18
        type: u4le
      - id: unknown_19
        type: u4le
      - id: unknown_20
        type: u4le
      - id: unknown_21
        type: u4le
      - id: unknown_22
        type: u4le
      - id: unknown_23
        type: u4le
      - id: unknown_24
        type: u4le
      - id: unknown_25
        size: 0x4
      - id: unknown_26
        type: u4le
      - id: unknown_27
        size: 0x8
      - id: unknown_28
        size: 0x4
      - id: unknown_29
        type: u4le
      - id: unknown_30
        type: u4le
      - id: unknown_31
        type: u4le
      - id: unknown_32
        type: u4le
      - id: unknown_33
        type: u4le
      - id: unknown_34
        type: u4le
      - id: unknown_35
        type: u4le
      - id: unknown_36
        type: u4le
      - id: unknown_37
        type: u4le
      - id: unknown_38
        type: u4le
