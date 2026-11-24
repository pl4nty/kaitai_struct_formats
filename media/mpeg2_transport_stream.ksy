meta:
  id: mpeg2_transport_stream
  title: MPEG-2 transport stream
  application:
    - FFmpeg
    - TSDuck
    - digital television (DVB, ATSC, ISDB)
    - HTTP Live Streaming
  file-extension:
    - ts
    - mts
    - m2t
    - tsv
  xref:
    iso: 13818-1
    mime: video/mp2t
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  The MPEG-2 transport stream (ISO/IEC 13818-1, ITU-T H.222.0) carries
  one or more programs of audio, video and data over lossy channels such
  as broadcast television, and is also used for files (.ts) and HLS
  segments. It is a sequence of fixed-size 188-byte packets, each
  starting with the sync byte 0x47 and carrying a 13-bit packet
  identifier (PID). A packet can contain an adaptation field (carrying
  among others the program clock reference) and a payload.

  Payloads with the same PID together form either packetized elementary
  stream (PES) packets, i.e. the compressed audio or video, or program
  specific information (PSI) sections, i.e. tables such as the program
  association table (PAT, always on PID 0) that lists the PIDs of the
  program map tables (PMT), which in turn list the PIDs and types of each
  program's elementary streams.

  This spec parses each packet on its own. For a payload that starts a
  PES packet or a PSI section (payload_unit_start_indicator set, not
  scrambled), the start of the PES header, or the first PSI section
  header, is decoded, telling them apart by the 00 00 01 start code that
  begins every PES packet. A PSI section is decoded further (PAT and PMT
  tables) only when it fits in the packet; reassembling PES packets and
  sections spanning several packets is left to the application, which
  needs the PAT and PMT to know what each PID carries.

  Not covered: the 192-byte packets of M2TS / Blu-ray (a 4-byte
  timestamp header before each packet) and 204-byte packets with
  Reed-Solomon parity; the contents of the adaptation field extension,
  of descriptors and of DVB/ATSC tables; and the MPEG program stream.
doc-ref:
  - https://github.com/FFmpeg/FFmpeg/blob/e5b51e8b609e8bc5667f07d4c5a6eaeccedb9f1c/libavformat/mpegts.c
  - https://github.com/FFmpeg/FFmpeg/blob/e5b51e8b609e8bc5667f07d4c5a6eaeccedb9f1c/libavformat/mpegts.h
  - https://github.com/tsduck/tsduck/blob/42a201f45ed4ec220787f6ac08818fc9ac4ce6ad/src/libtsduck/dtv/transport/tsTSPacket.cpp
  - https://www.itu.int/rec/T-REC-H.222.0
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
          The payload starts a PES packet, or contains the start of a PSI
          section (then preceded by a pointer field).
      - id: transport_priority
        type: b1
      - id: pid
        type: b13
        enum: pid
      - id: transport_scrambling_control
        type: b2
        doc: 0 if the payload is not scrambled.
      - id: adaptation_field_control
        type: b2
        doc: Bit 1 set if an adaptation field follows, bit 0 if a payload.
      - id: continuity_counter
        type: b4
        doc: Incremented for each packet with a payload of this PID.
      - id: adaptation_field
        type: adaptation_field
        if: has_adaptation_field
      - id: payload
        size-eos: true
        type:
          switch-on: 'payload_unit_start_indicator and transport_scrambling_control == 0 ? 1 : 0'
          cases:
            1: unit_start_payload
        if: has_payload
    instances:
      has_adaptation_field:
        value: adaptation_field_control & 0b10 != 0
      has_payload:
        value: adaptation_field_control & 0b01 != 0
  adaptation_field:
    seq:
      - id: len_body
        type: u1
        doc: At most 183, or 182 if a payload follows.
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
        doc: The next PES packet of this PID starts at an entry point (e.g. a key frame).
      - id: elementary_stream_priority_indicator
        type: b1
      - id: has_pcr
        type: b1
      - id: has_opcr
        type: b1
      - id: has_splice_countdown
        type: b1
      - id: has_private_data
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
        if: has_splice_countdown
        doc: Packets of this PID left until a splicing point.
      - id: len_private_data
        type: u1
        if: has_private_data
      - id: private_data
        size: len_private_data
        if: has_private_data
      - id: len_extension
        type: u1
        if: has_extension
      - id: extension
        size: len_extension
        if: has_extension
        doc: Legal time window, piecewise rate and seamless splice fields.
      - id: stuffing
        size-eos: true
        doc: 0xFF bytes.
  clock_reference:
    doc: 27 MHz clock, in a 90 kHz base and a 27 MHz extension.
    seq:
      - id: base
        type: b33
        doc: In units of 1/90000 s.
      - id: reserved
        type: b6
      - id: extension
        type: b9
        doc: 0 to 299.
    instances:
      value:
        value: base * 300 + extension
        doc: In units of 1/27000000 s.
  unit_start_payload:
    seq:
      - id: pes_header
        type: pes_header
        if: is_pes
      - id: psi
        type: psi_payload
        if: not is_pes and _io.size > 0
    instances:
      start_code:
        pos: 0
        size: 3
        if: _io.size >= 3
      is_pes:
        value: '_io.size >= 3 and start_code == [0x00, 0x00, 0x01]'
  pes_header:
    doc: |
      Start of a PES packet. The PES packet data (`data`) is continued in
      the payloads of the following packets of the same PID.
    seq:
      - id: start_code
        contents: [0x00, 0x00, 0x01]
      - id: stream_id
        type: u1
        doc: |
          0xC0-0xDF for MPEG audio, 0xE0-0xEF for video, 0xBD for
          private stream 1 (e.g. AC-3, subtitles).
      - id: len_pes_packet
        type: u2
        doc: |
          Number of bytes of the PES packet after this field; 0 means
          unbounded (allowed for video).
      - id: optional_header
        type: pes_optional_header
        if: has_optional_header
      - id: data
        size-eos: true
        doc: Start of the elementary stream data.
    instances:
      has_optional_header:
        value: |
          stream_id != 0xbc and stream_id != 0xbe and stream_id != 0xbf
          and stream_id != 0xf0 and stream_id != 0xf1 and stream_id != 0xf2
          and stream_id != 0xf8 and stream_id != 0xff
        doc: |
          False for the program stream map, padding stream, private
          stream 2, ECM, EMM, DSM-CC, H.222.1 type E and program stream
          directory.
  pes_optional_header:
    seq:
      - id: marker
        type: b2
        valid: 0b10
      - id: scrambling_control
        type: b2
      - id: priority
        type: b1
      - id: data_alignment_indicator
        type: b1
      - id: copyright
        type: b1
      - id: original_or_copy
        type: b1
      - id: pts_dts_flags
        type: b2
        doc: 2 if a PTS follows, 3 if a PTS and a DTS follow.
      - id: has_escr
        type: b1
      - id: has_es_rate
        type: b1
      - id: has_dsm_trick_mode
        type: b1
      - id: has_additional_copy_info
        type: b1
      - id: has_crc
        type: b1
      - id: has_extension
        type: b1
      - id: len_fields
        type: u1
        doc: Length of the optional fields and stuffing that follow.
      - id: fields
        size: len_fields
        type: pes_optional_fields(pts_dts_flags)
  pes_optional_fields:
    params:
      - id: pts_dts_flags
        type: u1
    seq:
      - id: pts
        type: timestamp
        if: pts_dts_flags >= 2
        doc: Presentation time stamp.
      - id: dts
        type: timestamp
        if: pts_dts_flags == 3
        doc: Decoding time stamp.
      - id: other
        size-eos: true
        doc: |
          ESCR, ES rate, DSM trick mode, additional copy info, CRC and
          extension fields as flagged, then 0xFF stuffing.
  timestamp:
    doc: 33-bit 90 kHz timestamp, split by marker bits.
    seq:
      - id: prefix
        type: b4
        doc: 0b0010 for a lone PTS, 0b0011 for a PTS followed by a DTS, 0b0001 for that DTS.
      - id: bits_32_30
        type: b3
      - id: marker1
        type: b1
      - id: bits_29_15
        type: b15
      - id: marker2
        type: b1
      - id: bits_14_0
        type: b15
      - id: marker3
        type: b1
    instances:
      value:
        value: (bits_32_30 << 30) | (bits_29_15 << 15) | bits_14_0
        doc: In units of 1/90000 s.
  psi_payload:
    seq:
      - id: len_previous_section_end
        -orig-id: pointer_field
        type: u1
        doc: |
          Number of bytes, belonging to the end of the previous section,
          before the first section that starts in this packet.
      - id: previous_section_end
        size: len_previous_section_end
      - id: table_id
        type: u1
        enum: table_id
        doc: 0xFF means stuffing until the end of the packet.
      - id: section
        type: section_header
        if: table_id != table_id::stuffing
      - id: section_data
        size: section.len_section - 5
        type: long_section_data(table_id)
        if: |
          table_id != table_id::stuffing and section.section_syntax_indicator
          and section.len_section >= 9
          and section.len_section - 5 <= _io.size - _io.pos
        doc: |
          Present only when the whole section is in this packet; otherwise
          it continues in the next packets of this PID. Further sections or
          0xFF stuffing may follow.
  long_section_data:
    params:
      - id: table_id
        type: u1
        enum: table_id
    seq:
      - id: body
        size: _io.size - 4
        type:
          switch-on: table_id
          cases:
            'table_id::program_association': pat
            'table_id::program_map': pmt
      - id: crc32
        type: u4
        doc: CRC-32/MPEG-2 of the whole section, from table_id on.
  section_header:
    seq:
      - id: section_syntax_indicator
        type: b1
        doc: Set for the long section form with version and CRC.
      - id: private_indicator
        type: b1
      - id: reserved1
        type: b2
      - id: len_section
        type: b12
        doc: Number of bytes of the section after this field.
      - id: table_id_extension
        type: u2
        if: section_syntax_indicator
        doc: transport_stream_id in a PAT, program_number in a PMT.
      - id: reserved2
        type: b2
        if: section_syntax_indicator
      - id: version_number
        type: b5
        if: section_syntax_indicator
      - id: current_next_indicator
        type: b1
        if: section_syntax_indicator
        doc: Unset if the table is not yet applicable.
      - id: section_number
        type: u1
        if: section_syntax_indicator
      - id: last_section_number
        type: u1
        if: section_syntax_indicator
  pat:
    doc: Program association table.
    seq:
      - id: programs
        type: pat_entry
        repeat: eos
  pat_entry:
    seq:
      - id: program_number
        type: u2
      - id: reserved
        type: b3
      - id: pid
        type: b13
        doc: PID of the program map table, or of the network information table for program 0.
  pmt:
    doc: Program map table.
    seq:
      - id: reserved1
        type: b3
      - id: pcr_pid
        type: b13
        doc: PID of the packets carrying the PCR of this program, 0x1FFF for none.
      - id: reserved2
        type: b4
      - id: len_program_info
        type: b12
      - id: program_info
        size: len_program_info
        type: descriptors
        doc: Descriptors of the program.
      - id: streams
        type: pmt_stream
        repeat: eos
  pmt_stream:
    seq:
      - id: stream_type
        type: u1
        enum: stream_type
      - id: reserved1
        type: b3
      - id: elementary_pid
        type: b13
      - id: reserved2
        type: b4
      - id: len_es_info
        type: b12
      - id: es_info
        size: len_es_info
        type: descriptors
  descriptors:
    seq:
      - id: descriptors
        type: descriptor
        repeat: eos
  descriptor:
    seq:
      - id: tag
        type: u1
      - id: len_data
        type: u1
      - id: data
        size: len_data
enums:
  pid:
    0x0000: pat
    0x0001: cat
    0x0002: tsdt
    0x0003: ipmp
    0x0010: nit
    0x0011: sdt_bat
    0x0012: eit
    0x0013: rst
    0x0014: tdt_tot
    0x0015: net_sync
    0x0016: rnt
    0x001c: link_local
    0x001d: measurement
    0x001e: dit
    0x001f: sit
    0x1fff: null_packet
  table_id:
    0x00: program_association
    0x01: conditional_access
    0x02: program_map
    0x03: transport_stream_description
    0x40: network_information_actual
    0x41: network_information_other
    0x42: service_description_actual
    0x46: service_description_other
    0x4a: bouquet_association
    0x4e: event_information_actual
    0x4f: event_information_other
    0x70: time_date
    0x71: running_status
    0x72: stuffing_section
    0x73: time_offset
    0x74: application_information
    0x7e: discontinuity_information
    0x7f: selection_information
    0xff: stuffing
  stream_type:
    0x01: video_mpeg1
    0x02: video_mpeg2
    0x03: audio_mpeg1
    0x04: audio_mpeg2
    0x05: private_section
    0x06: private_data
    0x0f: audio_aac
    0x10: video_mpeg4
    0x11: audio_aac_latm
    0x12: iso_iec_14496_pes
    0x13: iso_iec_14496_section
    0x15: metadata
    0x1b: video_h264
    0x1c: audio_mpeg4
    0x20: video_mvc
    0x21: video_jpeg2000
    0x24: video_hevc
    0x32: video_jpegxs
    0x33: video_vvc
    0x36: video_lcevc
    0x42: video_cavs
    0x81: ac3
    0x82: dts
    0x83: truehd
    0x84: eac3
    0x86: dts_hd_master_or_scte_35
    0x87: atsc_eac3
    0x90: bluray_subtitle_pgs
    0x92: bluray_subtitle_text
    0xd1: video_dirac
    0xd2: video_avs2
    0xd4: video_avs3
    0xea: video_vc1
