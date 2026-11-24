meta:
  id: edf
  title: European Data Format (EDF / EDF+)
  file-extension: edf
  license: MIT
  endian: le

doc: |
  EDF: fixed 256-byte ASCII main header, then 256 bytes per signal of
  field-major signal headers, then data records. Each data record holds,
  for every signal in order, `num_samples` little-endian two's-complement
  int16 samples.

  EDF+: `reserved` starts with "EDF+C" (continuous) or "EDF+D"
  (discontinuous). A signal labelled "EDF Annotations" carries
  time-stamped annotation lists (TALs) as ASCII bytes inside its int16
  samples; this spec parses those as ordinary samples.

  If `num_data_records` is -1 (recording still in progress), records are
  read until the end of the stream.

doc-ref: https://www.edfplus.info/specs/edf.html

seq:
  - id: header
    type: header

  - id: body
    type: body

types:
  header:
    seq:
      - id: "version"
        size: 8
        type: str
        pad-right: 0x20
        encoding: ASCII

      - id: "patient_id"
        size: 80
        type: str
        encoding: ASCII

      - id: "recording_id"
        size: 80
        type: str
        encoding: ASCII

      - id: "start_date"
        size: 8
        type: str
        encoding: ASCII

      - id: "start_time"
        size: 8
        type: str
        encoding: ASCII

      - id: "header_num_bytes"
        size: 8
        type: str
        pad-right: 0x20
        encoding: ASCII

      - id: "reserved"
        size: 44
        type: str
        encoding: ASCII

      - id: "num_data_records"
        size: 8
        type: str
        pad-right: 0x20
        encoding: ASCII

      - id: "data_duration"
        size: 8
        type: str
        pad-right: 0x20
        encoding: ASCII

      - id: "num_signals"
        size: 4
        type: str
        pad-right: 0x20
        encoding: ASCII

      - id: "labels"
        size: 16
        type: str
        pad-right: 0x20
        encoding: ASCII
        repeat: expr
        repeat-expr: ns

      - id: "transducers"
        size: 80
        type: str
        pad-right: 0x20
        encoding: ASCII
        repeat: expr
        repeat-expr: ns

      - id: "phys_dimensions"
        size: 8
        type: str
        pad-right: 0x20
        encoding: ASCII
        repeat: expr
        repeat-expr: ns

      - id: "phys_mins"
        size: 8
        type: str
        pad-right: 0x20
        encoding: ASCII
        repeat: expr
        repeat-expr: ns

      - id: "phys_maxes"
        size: 8
        type: str
        pad-right: 0x20
        encoding: ASCII
        repeat: expr
        repeat-expr: ns

      - id: "dig_mins"
        size: 8
        type: str
        pad-right: 0x20
        encoding: ASCII
        repeat: expr
        repeat-expr: ns

      - id: "dig_maxes"
        size: 8
        type: str
        pad-right: 0x20
        encoding: ASCII
        repeat: expr
        repeat-expr: ns

      - id: "prefiltering"
        size: 80
        type: str
        pad-right: 0x20
        encoding: ASCII
        repeat: expr
        repeat-expr: ns

      - id: "num_samples"
        size: 8
        type: str
        pad-right: 0x20
        encoding: ASCII
        repeat: expr
        repeat-expr: ns

      - id: "signals_reserved"
        size: 32
        type: str
        pad-right: 0x20
        encoding: ASCII
        repeat: expr
        repeat-expr: ns

    instances:
      ns:
        value: num_signals.to_i
      ndr:
        value: num_data_records.to_i

  body:
    seq:
      - id: records
        type: record
        repeat: expr
        repeat-expr: _root.header.ndr
        if: _root.header.ndr >= 0
      - id: records_until_eof
        type: record
        repeat: eos
        if: _root.header.ndr < 0
        doc: Used when `num_data_records` is -1 (recording still in progress).

    types:
      record:
        doc: One data record, holding a block of samples for every signal in turn.
        seq:
          - id: signals
            type: signal_block(_index)
            repeat: expr
            repeat-expr: _root.header.ns

      signal_block:
        params:
          - id: signal_index
            type: s4

        seq:
          - id: samples
            type: s2
            repeat: expr
            repeat-expr: _root.header.num_samples[signal_index].to_i
