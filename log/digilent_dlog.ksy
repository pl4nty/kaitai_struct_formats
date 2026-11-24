# Imported from https://github.com/Digilent/dlog-utils/blob/27ce9e49e752270ffbd301a999ced54c5d39db8a/src/dlog.ksy
meta:
  id: digilent_dlog
  file-extension:
    - dlog
    - log
  license: MIT

seq:
  - id: endianness
    -orig-id: endian
    type: u1
    doc: Endianness of the log file. 0 for little endian, 1 for big endian

  - id: header
    type: header
      
instances:
  data:
    pos: _root.header.header_size
    type: data

types:
  header:
    meta:
      endian:
        switch-on: _root.endianness
        cases:
          0: le
          1: be

    seq:
      - id: bytes_per_sample
        -orig-id: cbSampleEntry
        type: u1
        doc: Number of bytes per sample

      - id: header_length
        -orig-id: cbHeader
        type: u2
        doc: Length of the header structure

      - id: header_size
        -orig-id: cbHeaderInFile
        type: u2
        doc: The space in the file taken by the header, sector aligned (512)

      - id: format
        type: u2
        enum: formats
        doc: Format of the header and potential data

      - id: revision
        type: u4
        doc: Specific header revision

      - id: voltage_scale
        -orig-id: voltageUnits
        type: u8

      - id: stop_reason
        -orig-id: stopReason
        type: u4
        enum: stop_reasons
        doc: Reason logging stopped

      - id: start_index
        -orig-id: iStart
        type: u8
        doc: Sample index of first sample in log, usually 0

      - id: sample_count
        -orig-id: actualCount
        type: u8
        doc: Number of samples in the log

      - id: sample_rate_scale
        -orig-id: sampleFreqUnits
        type: u8
        doc: Sample rate scale 

      - id: sample_rate
        -orig-id: xSPS
        type: u8
        doc: Raw sample rate

      - id: delay_scale
        -orig-id: delayUnits
        type: u8
        doc: Delay scale

      - id: start_delay
        -orig-id: xDelay
        type: u8
        doc: Delay from start of sampling until the first sample was taken, usually 0

      - id: channels_per_sample
        -orig-id: cChannels
        type: u4
        if: format == formats::openlogger
        doc: How many channels in per sample

      - id: channel_map
        -orig-id: rgChannels
        type: u1
        repeat: expr
        repeat-expr: 8
        if: format == formats::openlogger
        doc: The channel order

    instances:
      sample_rate_hz:
        value: 1.0 * sample_rate / sample_rate_scale
        doc: Calculated sample rate 

      start_delay_sec:
        value: 1.0 * start_delay / delay_scale
        doc: Calculated delay
    
  data:
    meta:
      endian:
        switch-on: _root.endianness
        cases:
          0: le
          1: be
    seq:
      - id: samples
        type: sample
        repeat: eos
        
    types:
      sample:
        seq:
          - id: channel
            type:
              switch-on: _root.header.bytes_per_sample
              cases:
                1: s1
                2: s2
                4: s4
            repeat: expr
            repeat-expr: '_root.header.format != formats::openscope ? _root.header.channels_per_sample : 1'

enums:
  formats:
    1: openscope
    3: openlogger
    
  stop_reasons:
    0: normal
    1: forced
    2: error
    3: overflow
    4: unknown
