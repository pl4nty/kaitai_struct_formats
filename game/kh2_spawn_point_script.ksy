# Imported from https://github.com/krokettenkoal/khkh_xldM/blob/e545017f81fe0e928dc5b6e2ff0ce910205104a7/Parser/13-spawn-point-script/13.ksy
meta:
  id: kh2_spawn_point_script
  file-extension: bin
  license: Apache-2.0
  endian: le
seq:
  - id: header
    type: header
    repeat: until
    repeat-until: _.id == 0xffff
types:
  header:
    seq:
      - id: id
        type: u2
      - id: len
        type: u2
      - id: script
        size: len - 4
        type: script_header
        if: len != 0
  script_header:
    seq:
      - id: skip
        size: 4
      - id: code_block
        type: code_block
        repeat: eos
        #repeat: until
        #repeat-until: _.type == 1
  code_block:
    seq:
      - id: type
        type: u2
      - id: argument
        type:
          switch-on: type
          cases:
            12: type_0c
            7: map_occlusion
            1: spawn
            0: nop
            _: unk
  unk:
    seq:
      - id: dummy
        size: 1
        repeat: eos
  type_0c:
    seq:
      - id: data
        size: 34
  nop:
    seq:
      - id: data
        size: 0
  spawn:
    seq:
      - id: data
        size: 4
        type: str
        encoding: ASCII
  map_occlusion:
    seq:
      - id: data
        size: 6
