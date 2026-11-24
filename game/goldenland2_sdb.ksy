# Imported from https://github.com/fersatgit/Goldenland-2-Cold-Heaven/blob/18053233e7c88dd223836ac25e98c1176e919289/kaitai/sdb.ksy
# Licence and copyright: see _community/README.md
meta:
  id: goldenland2_sdb
  title: "Златогорье 2 SDB"
  file-extension: sdb
  license: Unlicense
  endian: le
  bit-endian: le
seq:
  - id: signature
    size: 4
    type: str
    encoding: "windows-1251"
  - id: data
    type: string_entry
    repeat: eos
    if: signature=="SDB "
instances:
  encrypted_data:
    pos: 0
    type: encrypted_string_entry
    repeat: eos
    if: signature!="SDB "
types:
  string_entry:
    seq:
      - id: id
        type: u4
      - id: len
        type: u4
      - id: text
        size: len
        type: str
        encoding: "windows-1251"
  encrypted_string_entry:
    seq:
      - id: id
        type: u4
      - id: len
        type: u4
      - id: text
        size: len
        type: str_wrapper
        process: xor(0xAA)
  str_wrapper:
    seq:
      - id: value
        size-eos: true
        type: str
        encoding: "windows-1251"
