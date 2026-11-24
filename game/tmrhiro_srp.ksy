# Imported from https://github.com/dungwinux/pac_patcher/blob/3b0c3b4b3744a898c89350649c46b891c4f28610/srp.ksy
# Licence and copyright: see _community/README.md
meta:
  id: tmrhiro_srp
  title: srp
  application: TmrHiroADVSystem
  file-extension: srp
  license: MIT
  endian: le
seq:
  - id: chunk_count
    type: u4
  - id: chunks
    type: chunk
    repeat: expr
    repeat-expr: chunk_count

types:
  chunk:
    seq:
      - id: code_size
        type: u2
      - id: code_data
        size: code_size
        type: code_meta
  code_select:
    seq:
      - id: count
        type: u1
      - id: buff
        type: u1
  code_meta:
    seq:
      - id: code_type
        type: u4
      - id: raw_text
        size-eos: true
        type: str
        encoding: Shift_JIS
        if: (code_type == 0x00150050) or (code_type & 0x0000FFFF) == 0
      - id: raw
        size-eos: true
