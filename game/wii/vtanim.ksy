# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/vtanim.ksy
meta:
  id: vtanim
  title: Virtua Tennis 2009 animation parameter table
  file-extension: dat
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Headerless. Players/<ID>/rundata.dat uses 56-byte records, swingdata.dat
  256-byte records; the last record is named "end". Use `record_size` 56 or 256.
params:
  - id: record_size
    type: u4
seq:
  - id: records
    type: record
    repeat: eos
types:
  record:
    seq:
      - id: name
        size: 32
        type: strz
        encoding: ASCII
      - id: words
        size: _root.record_size - 32
        doc: A hash, ints and floats; meaning unknown.
