# Imported from https://gist.githubusercontent.com/iconmaster5326/94c25d2adf6479777307f313715ba75b/raw/ab82035d90c875489c884df402ef31d4cd2b5196/rvdatax.ksy
meta:
  id: dragon_spirits_rvdatax
  title: Dragon Spirits rvdatax data file
  license: LicenseRef-All-Rights-Reserved
  endian: le
doc: A `.rvdatax` file, used in Dragon Spirits.
seq:
  - id: header
    size: 3
    doc: Header information?
  - id: num_entries
    type: varnum
    doc: Number of entries.
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: num_entries.value
    doc: Entries.
types:
  varnum:
    doc: A variable-length number.
    seq:
      - id: num_bytes
        type: u1
        doc: The number of bytes this number is.
      - id: bytes_1
        type: u1
        if: num_bytes == 0x01
        doc: The bytes composing this number.
      - id: bytes_2
        type: u2
        if: num_bytes == 0x02
        doc: The bytes composing this number.
      - id: bytes_4
        type: u4
        if: num_bytes == 0x04
        doc: The bytes composing this number.
    instances:
      value:
        value: |
          num_bytes == 0x00 ? 0 :
          num_bytes == 0x01 ? bytes_1 :
          num_bytes == 0x02 ? bytes_2 :
          num_bytes == 0x04 ? bytes_4 :
          (num_bytes - 5)
  entry:
    doc: A single entry in a file.
    seq:
      - id: magic1
        size: 4
        doc: Magic number.
      - id: name
        type: str
        terminator: 0x22 # "
        consume: false
        encoding: UTF-8
        doc: The name of the entity.
      - id: magic2
        size: 1
        doc: Magic number.
      - id: len_contents
        type: varnum
        doc: The byte length of entry contents.
      - id: contents
        size: len_contents.value
        type: str
        encoding: UTF-8
        doc: The contents of this entry.
