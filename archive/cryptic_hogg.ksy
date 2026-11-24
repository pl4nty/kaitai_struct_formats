# Imported from https://github.com/lokkju/pyhogg/blob/8735e744de5579b31aa451f37fb684b26f834fd0/kaitai/hogg_spec.ksy
meta:
  id: cryptic_hogg
  title: Cryptic Studios HOGG archive
  file-extension: hogg
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: hog_header
    type: hog_header
  - id: op_journal
    size: hog_header.op_journal_size
    doc: Operation Journal (not implemented)
  - id: dl_journal
    size: hog_header.dl_journal_size
    type: dl_journal
    doc: DataList Journal
  - id: file_entries
    type: file_header
    repeat: expr
    repeat-expr: hog_header.file_list_size / sizeof_file_header
  - id: ea_entries
    type: ea_header
    repeat: expr
    repeat-expr: hog_header.ea_list_size / sizeof_ea_header
instances:
  sizeof_file_header:
    value: 32
  sizeof_ea_header:
    value: 16
types:
  hog_header:
    doc: Header to archive file
    seq:
      - id: hog_header_flag
        contents: [ 0x0d, 0xf0, 0xad, 0xde]
      - id: version
        type: u2
      - id: op_journal_size
        type: u2
      - id: file_list_size
        type: u4
      - id: ea_list_size
        type: u4
      - id: datalist_file_number
        type: u4
        doc: index of the special file ?DataList
      - id: dl_journal_size
        type: u4
  dl_journal:
    doc: DataList Journal
    seq:
      - id: in_use_flag
        type: u4
      - id: size
        type: u4
      - id: oldsize
        type: u4
      - id: op_entries
        size: size
        type: dlj_op_entries
  file_header:
    seq:
      - id: offset
        type: u8
      - id: size
        type: u4
      - id: timestamp
        type: u4
      - id: checksum
        size: 8
        doc: first 32 bits of a MD5 checksum
      - id: flag_fffe
        size: 2
      - id: reserved
        type: u2
      - id: ea_id
        type: s4
    instances:
      data:
        io: _root._io
        pos: offset
        size: size
  ea_header:
    doc: Extended Attributes (optional) contains more information about a file
    seq:
      - id: name_id
        type: u4
      - id: header_data_id
        type: u4
      - id: unpacked_size
        type: u4
      - id: flags
        type: u4
  dlj_op_entries:
    seq:
      - id: op_entry
        type: dlj_op_entry
        repeat: eos
  dlj_op_entry:
    seq:
      - id: op_type
        type: u1
        enum: dlj_op_types
      - id: id
        type: s4
      - id: datasize
        type: u4
      - id: str
        size: datasize
enums:
  dlj_op_types:
    0: dlj_invalid
    1: dlj_add_or_update
    2: dlj_free
