# Imported from https://github.com/mwwhited-notes/shared/blob/e456314f819f7f89fd1116f863b40c46e07f8ca0/projects/eeg-formats-learning/ksy/bdf.ksy
# Licence and copyright: see _community/README.md
meta:
  id: biosemi_bdf
  title: BioSemi Data Format (BDF / BDF+)
  file-extension: bdf
  license: CC0-1.0
  encoding: ASCII
  endian: le
doc: |
  BDF is EDF with a different identification byte string and 24-bit
  little-endian two's-complement samples instead of 16-bit. Header layout,
  field widths and the data record structure are otherwise identical to
  EDF. See edf.ksy for field notes.

  A signal labelled "Status" typically carries trigger bits in the low
  bits of each 24-bit sample.
seq:
  - id: header
    type: header
  - id: records_known
    type: record
    repeat: expr
    repeat-expr: header.num_records_int
    if: header.num_records_int >= 0
  - id: records_until_eof
    type: record
    repeat: eos
    if: header.num_records_int < 0
types:
  header:
    seq:
      - id: magic
        contents: [0xff, "BIOSEMI"]
        doc: Byte 0xFF followed by "BIOSEMI".
      - id: patient_id
        size: 80
        type: str
        pad-right: 0x20
      - id: recording_id
        size: 80
        type: str
        pad-right: 0x20
      - id: start_date
        size: 8
        type: str
      - id: start_time
        size: 8
        type: str
      - id: header_bytes
        size: 8
        type: str
        pad-right: 0x20
      - id: reserved
        size: 44
        type: str
        pad-right: 0x20
        doc: Starts with "24BIT" in BioSemi files.
      - id: num_records
        size: 8
        type: str
        pad-right: 0x20
      - id: record_duration
        size: 8
        type: str
        pad-right: 0x20
      - id: num_signals
        size: 4
        type: str
        pad-right: 0x20
      - id: label
        size: 16
        type: str
        pad-right: 0x20
        repeat: expr
        repeat-expr: num_signals_int
      - id: transducer
        size: 80
        type: str
        pad-right: 0x20
        repeat: expr
        repeat-expr: num_signals_int
      - id: physical_dimension
        size: 8
        type: str
        pad-right: 0x20
        repeat: expr
        repeat-expr: num_signals_int
      - id: physical_min
        size: 8
        type: str
        pad-right: 0x20
        repeat: expr
        repeat-expr: num_signals_int
      - id: physical_max
        size: 8
        type: str
        pad-right: 0x20
        repeat: expr
        repeat-expr: num_signals_int
      - id: digital_min
        size: 8
        type: str
        pad-right: 0x20
        repeat: expr
        repeat-expr: num_signals_int
      - id: digital_max
        size: 8
        type: str
        pad-right: 0x20
        repeat: expr
        repeat-expr: num_signals_int
      - id: prefiltering
        size: 80
        type: str
        pad-right: 0x20
        repeat: expr
        repeat-expr: num_signals_int
      - id: samples_per_record
        size: 8
        type: str
        pad-right: 0x20
        repeat: expr
        repeat-expr: num_signals_int
      - id: signal_reserved
        size: 32
        type: str
        pad-right: 0x20
        repeat: expr
        repeat-expr: num_signals_int
    instances:
      num_signals_int:
        value: num_signals.to_i
      num_records_int:
        value: num_records.to_i
  record:
    seq:
      - id: signals
        type: signal_block(_index)
        repeat: expr
        repeat-expr: _root.header.num_signals_int
  signal_block:
    params:
      - id: sig
        type: u4
    seq:
      - id: samples
        type: s24le
        repeat: expr
        repeat-expr: _root.header.samples_per_record[sig].to_i
  s24le:
    seq:
      - id: b0
        type: u1
      - id: b1
        type: u1
      - id: b2
        type: u1
    instances:
      unsigned:
        value: '(b2 << 16) | (b1 << 8) | b0'
      value:
        value: 'unsigned >= 0x800000 ? unsigned - 0x1000000 : unsigned'
        doc: Sign-extended 24-bit sample.
