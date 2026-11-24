# Imported from https://github.com/AtomCrafty/MajiroTools/blob/e0261df508b6c8065865bb51b4059263cef84394/doc/majiro_readmark.ksy
meta:
  id: majiro_readmark
  file-extension: mss
  license: MIT
  encoding: Shift_JIS
  endian: le

seq:
  - id: entries
    type: entry
    repeat: eos
  
types:
  entry:
    seq:
      - id: script_name
        size: 128
        type: str
      - id: size
        type: u4
      - id: text_count
        type: u4
      - id: placeholder_data
        type: u4
      - id: placeholder_prev
        type: u4
      - id: placeholder_next
        type: u4
      - id: data
        size: size
