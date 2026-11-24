# Imported from https://github.com/ttepatti/qnx-boot-script-kaitai-struct/blob/30f122cd00e0090abb6890c1238c0d79930d3cbf/qnx_boot_script_parser.ksy
meta:
  id: qnx_boot_script
  title: QNX Boot Script Parser
  tags:
    - qnx
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: entries
    type: entry
    repeat: eos
types:
  entry:
    seq:
      - id: entry_len
        type: u2
      - id: entry_type
        type: u2
      - id: entry_body
        size: entry_len - 4
        type:
          switch-on: entry_type
          cases:
            0: entry_type_external
            1: entry_type_waitfor
            2: entry_type_reopen
            3: entry_type_display_msg
            4: entry_type_procmgr_symlink
            5: entry_type_extsched_aps
            _: entry_type_unknown
        if: entry_len != 0
  entry_type_external:
    seq:
      - id: cpu
        type: u1
      - id: priority
        type: u1
      - id: policy
        type: u1
      - id: flags
        type: u1
      - id: reserved_ext
        type: u2
      - id: arg_entry_count
        type: u1
      - id: env_entry_count
        type: u1
      - id: command
        type: str
        terminator: 0x00
        encoding: UTF-8
      - id: arg
        type: str
        terminator: 0x00
        encoding: UTF-8
        repeat: expr
        repeat-expr: arg_entry_count
      - id: env
        type: str
        terminator: 0x00
        encoding: UTF-8
        repeat: expr
        repeat-expr: env_entry_count
  entry_type_waitfor:
    seq:
      - id: checks
        type: u2
      - id: wait_for_target
        type: str
        terminator: 0x00
        encoding: UTF-8
  entry_type_reopen:
    seq:
      - id: checks
        type: u2
      - id: reopen_target
        type: str
        terminator: 0x00
        encoding: UTF-8
  entry_type_display_msg:
    seq:
      - id: message_data
        type: str
        terminator: 0x00
        encoding: UTF-8
  entry_type_procmgr_symlink:
    seq:
      - id: src_name
        type: str
        terminator: 0x00
        encoding: UTF-8
      - id: dest_name
        type: str
        terminator: 0x00
        encoding: UTF-8
  entry_type_extsched_aps:
    seq:
      - id: stringtest
        type: str
        terminator: 0x00
        encoding: UTF-8
  entry_type_unknown:
    seq:
      - id: stringtest
        type: str
        terminator: 0x00
        encoding: UTF-8
