meta:
  id: sudoers_ts
  title: Sudoers Time Stamp file
  tags:
    - linux
  license: CC0-1.0
  endian: le
doc: |
  This spec can be used to parse sudo time stamp files located in directories
  such as /run/sudo/ts/$USER or /var/lib/sudo/ts/$USER.
doc-ref: https://www.sudo.ws/docs/man/1.8.27/sudoers_timestamp.man/
seq:
  - id: records
    type: record
    repeat: eos
types:
  record:
    seq:
      - id: version
        type: u2
        doc: version number of the timestamp_entry struct
      - id: len_record
        -orig-id: size
        type: u2
        doc: size of the record in bytes
      - id: payload
        size: len_record - 4
        type:
          switch-on: version
          cases:
            1: record_v1
            2: record_v2
  record_v1:
    seq:
      - id: type
        type: u2
        enum: ts_type
        doc: record type
      - id: flags
        type: ts_flag
        doc: record flags
      - id: auth_uid
        type: u4
        doc: user ID that was used for authentication
      - id: sid
        type: u4
        doc: session ID associated with tty/ppid
      - id: ts
        type: timespec
        doc: time stamp, from a monotonic time source
      - id: ttydev
        type: u4
        if: type == ts_type::tty
        doc: device number of the terminal associated with the session
      - id: ppid
        type: u4
        if: type == ts_type::ppid
        doc: ID of the parent process
  record_v2:
    seq:
      - id: type
        type: u2
        enum: ts_type
        doc: record type
      - id: flags
        type: ts_flag
        doc: record flags
      - id: auth_uid
        type: u4
        doc: user ID that was used for authentication
      - id: sid
        type: u4
        doc: ID of the user's terminal session, if present (when type is TS_TTY)
      - id: start_time
        type: timespec
        doc: |
          start time of the session leader for records of type TS_TTY or of the parent
          process for records of type TS_PPID
      - id: ts
        type: timespec
        doc: actual time stamp, from a monotonic time source
      - id: ttydev
        type: u4
        if: type == ts_type::tty
        doc: device number of the terminal associated with the session
      - id: ppid
        type: u4
        if: type == ts_type::ppid
        doc: ID of the parent process
  timespec:
    seq:
      - id: sec
        type: s8
        doc: seconds
      - id: nsec
        type: s8
        doc: nanoseconds
  ts_flag:
    seq:
      - id: reserved0
        type: b6
        doc: Reserved (unused) bits
      - id: anyuid
        -orig-id: TS_ANYUID
        type: b1
        doc: ignore uid
      - id: disabled
        -orig-id: TS_DISABLED
        type: b1
        doc: entry disabled
      - id: reserved1
        type: b8
        doc: Reserved (unused) bits
enums:
  ts_type:
    1:
      id: global_record
      -orig-id: TS_GLOBAL
    2: tty
    3: ppid
    4: lockexcl
