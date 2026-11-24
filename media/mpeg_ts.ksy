meta:
  id: mpeg_ts
  title: MPEG transport stream
  application:
    - FFmpeg
    - TSDuck
  file-extension:
    - ts
    - mts
    - m2t
    - tsv
  xref:
    iso: 13818-1
    mime: video/MP2T
  license: CC0-1.0
  ks-version: '0.11'
  endian: be
doc: |
  MPEG-2 transport stream (ITU-T H.222.0 | ISO/IEC 13818-1), the container used
  for digital TV broadcasting (DVB, ATSC, ISDB), IPTV and HLS segments.

  A transport stream is a sequence of 188-byte packets, each starting with the
  sync byte 0x47. A 4-byte header gives the PID (packet identifier) of the
  elementary stream or table the packet belongs to, a continuity counter and
  whether an adaptation field and/or payload follow. The adaptation field
  carries timing (PCR/OPCR), splicing and private data and is also used for
  stuffing.

  This spec covers the packet header and the adaptation field (with the PCR,
  OPCR, splice countdown, transport private data and the raw adaptation field
  extension). Payloads (PES packets and PSI sections such as PAT/PMT) are
  usually split across several packets of the same PID and must be reassembled
  first, so they are exposed as raw bytes.

  Streams with 192-byte packets (M2TS/BDAV with a 4-byte timestamp prefix) or
  204-byte packets (with Reed-Solomon parity) are not covered.
doc-ref:
  - https://www.itu.int/rec/T-REC-H.222.0
  - https://github.com/FFmpeg/FFmpeg/blob/master/libavformat/mpegts.c
  - https://github.com/tsduck/tsduck/blob/master/src/libtsduck/dtv/transport/tsTSPacket.cpp
seq:
  - id: packets
    size: 188
    type: packet
    repeat: eos
types:
  packet:
    seq:
      - id: sync_byte
        contents: [0x47]
      - id: transport_error_indicator
        type: b1
      - id: payload_unit_start_indicator
        type: b1
        doc: |
          A PES packet or a PSI section starts in this packet. For PSI the
          payload then begins with a 1-byte pointer field.
      - id: transport_priority
        type: b1
      - id: pid
        type: b13
        doc: |
          Packet identifier. Fixed values include 0x0000 (PAT), 0x0001 (CAT),
          0x0002 (TSDT), 0x0010 (DVB NIT), 0x0011 (DVB SDT/BAT), 0x0012 (DVB
          EIT), 0x0014 (DVB TDT/TOT) and 0x1FFF (null packets); the PIDs of PMTs
          and elementary streams are given by the PAT and PMTs.
      - id: transport_scrambling_control
        type: b2
        doc: 0 - not scrambled; other values are user-defined.
      - id: has_adaptation_field
        type: b1
      - id: has_payload
        type: b1
      - id: continuity_counter
        type: b4
        doc: Incremented for each packet with payload of the same PID.
      - id: adaptation_field
        type: adaptation_field
        if: has_adaptation_field and not transport_error_indicator
      - id: payload
        size-eos: true
        if: has_payload and not transport_error_indicator
      - id: errored_data
        size-eos: true
        if: transport_error_indicator
        doc: |
          Rest of a packet flagged as containing uncorrectable errors, which is
          not parsed further.
  adaptation_field:
    seq:
      - id: len_body
        -orig-id: adaptation_field_length
        type: u1
        doc: Number of bytes following this field.
      - id: body
        size: len_body
        type: adaptation_field_body
        if: len_body > 0
  adaptation_field_body:
    seq:
      - id: discontinuity_indicator
        type: b1
      - id: random_access_indicator
        type: b1
      - id: elementary_stream_priority_indicator
        type: b1
      - id: has_pcr
        type: b1
      - id: has_opcr
        type: b1
      - id: has_splicing_point
        type: b1
      - id: has_transport_private_data
        type: b1
      - id: has_extension
        type: b1
      - id: pcr
        type: clock_reference
        if: has_pcr
        doc: Program clock reference.
      - id: opcr
        type: clock_reference
        if: has_opcr
        doc: Original program clock reference.
      - id: splice_countdown
        type: s1
        if: has_splicing_point
      - id: len_transport_private_data
        type: u1
        if: has_transport_private_data
      - id: transport_private_data
        size: len_transport_private_data
        if: has_transport_private_data
      - id: len_extension
        type: u1
        if: has_extension
      - id: extension
        size: len_extension
        if: has_extension
      - id: stuffing
        size-eos: true
        doc: Stuffing bytes (0xFF).
  clock_reference:
    doc: 42-bit 27 MHz clock value, as a 33-bit 90 kHz base and a 9-bit extension.
    seq:
      - id: base
        type: b33
      - id: reserved
        type: b6
      - id: extension
        type: b9
    instances:
      value:
        value: base * 300 + extension
        doc: Clock value in 27 MHz units.
