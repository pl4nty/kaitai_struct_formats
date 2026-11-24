meta:
  id: vector_blf
  title: Vector Binary Logging Format (BLF)
  application:
    - Vector CANoe
    - Vector CANalyzer
    - python-can
  file-extension: blf
  license: CC0-1.0
  ks-version: '0.11'
  imports:
    - /windows/windows_systemtime
  endian: le
doc: |
  BLF is the binary bus logging format of Vector Informatik tools,
  used to record CAN, CAN FD, LIN, FlexRay, Ethernet and other traffic
  in automotive applications. No official specification is published;
  this spec follows the reverse-engineered reader and writer of
  python-can (which is based on Toby Lorenz' Vector BLF library).

  A file starts with a `LOGG` header and continues with objects, each
  starting with a `LOBJ` base header. On the top level these are
  normally log containers holding (usually zlib compressed) chunks of
  a stream of further objects, up to 128 KiB uncompressed each. Since
  an object of that inner stream may be split across two containers,
  the containers' payloads are exposed as (decompressed) bytes; after
  concatenating them, the stream can be parsed as a sequence of
  `log_object`.

  Each object is followed by `object_size % 4` padding bytes.
  Object bodies are decoded for CAN messages (types 1 and 86), CAN
  error frames (73), CAN FD messages (100 and 101) and global markers
  (96); other types are kept as raw bytes.
doc-ref:
  - https://github.com/hardbyte/python-can/blob/a59478192423f6d229d4d5b561d2721e6842aa1d/can/io/blf.py
seq:
  - id: header
    size: header_peek.len_header
    type: file_header
  - id: objects
    type: log_object
    repeat: eos
instances:
  header_peek:
    pos: 0
    type: file_header
types:
  file_header:
    seq:
      - id: magic
        contents: LOGG
      - id: len_header
        type: u4
        doc: Size of the file header (144 when written by python-can).
      - id: application_id
        type: u1
      - id: application_version_major
        type: u1
      - id: application_version_minor
        type: u1
      - id: application_version_build
        type: u1
      - id: bin_log_version
        type: version
        doc: Version of the binary logging library that wrote the file.
      - id: len_file
        type: u8
      - id: len_uncompressed
        type: u8
      - id: num_objects
        type: u4
      - id: num_objects_read
        type: u4
      - id: time_start
        type: windows_systemtime
      - id: time_stop
        type: windows_systemtime
  version:
    seq:
      - id: major
        type: u1
      - id: minor
        type: u1
      - id: build
        type: u1
      - id: patch
        type: u1
  log_object:
    seq:
      - id: base_header
        type: object_header_base
      - id: body
        size: base_header.len_object - 16
        type:
          switch-on: base_header.object_type
          cases:
            object_type::log_container: log_container
            _: object_with_header(base_header)
      - id: padding
        size: base_header.len_object % 4
  object_header_base:
    seq:
      - id: magic
        contents: LOBJ
      - id: len_header
        type: u2
        doc: Size of the object header (base header plus versioned header).
      - id: header_version
        type: u2
      - id: len_object
        type: u4
        doc: Size of the object including all headers, excluding padding.
      - id: object_type
        type: u4
        enum: object_type
  log_container:
    seq:
      - id: compression_method
        type: u2
        enum: compression_method
      - id: reserved1
        size: 6
      - id: len_uncompressed
        type: u4
      - id: reserved2
        size: 4
      - id: data_uncompressed
        size-eos: true
        if: compression_method == compression_method::none
      - id: data_zlib
        size-eos: true
        process: zlib
        if: compression_method == compression_method::zlib_deflate
        doc: Decompressed contents; `len_uncompressed` bytes.
  object_with_header:
    params:
      - id: base_header
        type: object_header_base
    seq:
      - id: header_v1
        type: object_header_v1
        if: base_header.header_version == 1
      - id: header_v2
        type: object_header_v2
        if: base_header.header_version == 2
      - id: payload
        type:
          switch-on: base_header.object_type
          cases:
            object_type::can_message: can_message
            object_type::can_message2: can_message
            object_type::can_error_ext: can_error_ext
            object_type::can_fd_message: can_fd_message
            object_type::can_fd_message_64: can_fd_message_64(base_header)
            object_type::global_marker: global_marker
        if: base_header.header_version == 1 or base_header.header_version == 2
    instances:
      timestamp_flags:
        value: 'base_header.header_version == 1 ? header_v1.flags : header_v2.flags'
        if: base_header.header_version == 1 or base_header.header_version == 2
      timestamp:
        value: 'base_header.header_version == 1 ? header_v1.timestamp : header_v2.timestamp'
        if: base_header.header_version == 1 or base_header.header_version == 2
        doc: |
          Time since `time_start` of the file, in units of 10 us if
          `timestamp_flags` is 1, or 1 ns if it is 2.
  object_header_v1:
    seq:
      - id: flags
        type: u4
        doc: 1 = timestamp in 10 us units, 2 = timestamp in 1 ns units.
      - id: client_index
        type: u2
      - id: object_version
        type: u2
      - id: timestamp
        type: u8
  object_header_v2:
    seq:
      - id: flags
        type: u4
        doc: 1 = timestamp in 10 us units, 2 = timestamp in 1 ns units.
      - id: timestamp_status
        type: u1
      - id: reserved
        type: u1
      - id: object_version
        type: u2
      - id: timestamp
        type: u8
      - id: original_timestamp
        type: u8
  can_id:
    seq:
      - id: raw
        type: u4
    instances:
      is_extended:
        value: (raw & 0x8000_0000) != 0
      id:
        value: raw & 0x1fff_ffff
  can_message:
    seq:
      - id: channel
        type: u2
        doc: 1-based channel number.
      - id: flags
        type: u1
        doc: Bit 0 = transmitted (TX), bit 7 = remote frame.
      - id: dlc
        type: u1
      - id: can_id
        type: can_id
      - id: data
        size: 8
        doc: Only the first `dlc` bytes are meaningful.
  can_error_ext:
    seq:
      - id: channel
        type: u2
      - id: length
        type: u2
      - id: flags
        type: u4
      - id: ecc
        type: u1
      - id: position
        type: u1
      - id: dlc
        type: u1
      - id: reserved1
        type: u1
      - id: frame_length
        type: u4
      - id: can_id
        type: can_id
      - id: flags_ext
        type: u2
      - id: reserved2
        size: 2
      - id: data
        size: 8
  can_fd_message:
    seq:
      - id: channel
        type: u2
      - id: flags
        type: u1
        doc: Bit 0 = transmitted (TX), bit 7 = remote frame.
      - id: dlc
        type: u1
      - id: can_id
        type: can_id
      - id: frame_length
        type: u4
      - id: bit_count
        type: u1
      - id: fd_flags
        type: u1
        doc: Bit 0 = EDL (FD frame), bit 1 = BRS, bit 2 = ESI.
      - id: num_valid_bytes
        type: u1
      - id: reserved
        size: 5
      - id: data
        size: 64
        doc: Only the first `num_valid_bytes` bytes are meaningful.
  can_fd_message_64:
    params:
      - id: base_header
        type: object_header_base
    seq:
      - id: channel
        type: u1
      - id: dlc
        type: u1
      - id: num_valid_bytes
        type: u1
      - id: tx_count
        type: u1
      - id: can_id
        type: can_id
      - id: frame_length
        type: u4
      - id: flags
        type: u4
        doc: |
          Bit 4 = remote frame, bit 12 = EDL (FD frame), bit 13 = BRS,
          bit 14 = ESI.
      - id: btr_cfg_arb
        type: u4
        doc: Bit rate used in the arbitration phase.
      - id: btr_cfg_data
        type: u4
        doc: Bit rate used in the data phase.
      - id: time_offset_brs_ns
        type: u4
      - id: time_offset_crc_del_ns
        type: u4
      - id: bit_count
        type: u2
      - id: direction
        type: u1
        doc: 0 = received.
      - id: ofs_ext_data
        type: u1
        doc: Offset of extended data relative to the object start, or 0.
      - id: crc
        type: u4
      - id: data
        size: |
          (ofs_ext_data != 0 ? ofs_ext_data : base_header.len_object)
          - base_header.len_header - 40 < num_valid_bytes
          ? (ofs_ext_data != 0 ? ofs_ext_data : base_header.len_object)
            - base_header.len_header - 40
          : num_valid_bytes
        doc: |
          Payload; may be shorter than `num_valid_bytes`, in which case
          the missing bytes are zero.
  global_marker:
    seq:
      - id: commented_event_type
        type: u4
      - id: foreground_color
        type: u4
      - id: background_color
        type: u4
      - id: reserved1
        size: 3
      - id: is_relocatable
        type: u1
      - id: len_group_name
        type: u4
      - id: len_marker_name
        type: u4
      - id: len_description
        type: u4
      - id: reserved2
        size: 12
      - id: group_name
        size: len_group_name
        doc: In the ANSI code page of the writer.
      - id: marker_name
        size: len_marker_name
      - id: description
        size: len_description
enums:
  object_type:
    1: can_message
    10: log_container
    73: can_error_ext
    86: can_message2
    96: global_marker
    100: can_fd_message
    101: can_fd_message_64
  compression_method:
    0: none
    2: zlib_deflate
