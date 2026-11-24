# Imported from https://github.com/vii1/DIV/blob/3692483012cbdf9c85b2f93f2ae6a35ac4dd193e/formats/game_exe.ksy
# Licence and copyright: see _community/README.md
meta:
  id: div_game_exe
  file-extension: exe
  license: GPL-3.0-only
  encoding: ASCII
  endian: le
  bit-endian: le
    
seq:
  - id: stub
    size: 602
  - id: flags
    size: 4
    type: program_flags
  - id: imem
    type: u4
  - id: imem2
    type: u4
  - id: max_process
    type: u4
  - id: reserved
    type: u4
  - id: iloc1
    type: u4
  - id: iloc
    type: u4
  - id: reserved2
    type: u4
  - id: mem_size
    type: u4
  - id: len_descomp
    type: u4
  - id: data
    size-eos: true
    process: zlib
    
types:
  program_flags:
    seq:
      - id: setup_program
        type: b1
      - id: dummy
        type: b6
      - id: debug_at_start
        type: b1
      - id: dummy2
        type: b1
      - id: ignore_errors
        type: b1
      - id: demo
        type: b1
