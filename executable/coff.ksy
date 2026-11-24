meta:
  id: coff
  title: COFF
  tags:
    - dos
  license: CC0-1.0
  ks-version: 0.9
  encoding: ASCII
  endian: le
doc-ref: https://wiki.osdev.org/COFF
seq:
  - id: header
    type: header
    if: not is_bigobj
  - id: bigobj_header
    type: bigobj_header
    if: is_bigobj
  - id: optional_header
    type: optional_header
    if: not is_bigobj and header.len_optional_header != 0
  - id: section_headers
    type: section_header
    repeat: expr
    repeat-expr: num_sections
instances:
  first_word:
    pos: 0
    type: u4
  is_bigobj:
    value: first_word == 0xffff_0000
    doc: |
      Microsoft "big object" format (`/bigobj`, MinGW `-Wa,-mbig-obj`): Sig1 =
      0 and Sig2 = 0xffff, where a regular header has its machine type and
      number of sections.
  num_sections:
    value: 'is_bigobj ? bigobj_header.num_sections : header.num_sections'
  ofs_symbol_table:
    value: 'is_bigobj ? bigobj_header.ofs_symbol_table : header.ofs_symbol_table'
  num_symbols:
    value: 'is_bigobj ? bigobj_header.num_symbols : header.num_symbols'
  symbol_table_and_string_table:
    pos: ofs_symbol_table
    type: symbol_table_and_string_table(num_symbols)
types:
  header:
    seq:
      - id: magic
        size: 2
      - id: num_sections
        type: u2
      - id: time_and_date
        type: u4
      - id: ofs_symbol_table
        type: u4
      - id: num_symbols
        type: u4
      - id: len_optional_header
        type: u2
        valid:
          any-of: [0, 28]
      - id: flags
        type: u2
  bigobj_header:
    doc: ANON_OBJECT_HEADER_BIGOBJ (winnt.h)
    doc-ref: https://learn.microsoft.com/en-us/cpp/build/reference/bigobj-increase-number-of-sections-in-dot-obj-file
    seq:
      - id: sig1
        contents: [0, 0]
      - id: sig2
        contents: [0xff, 0xff]
      - id: version
        type: u2
      - id: machine
        type: u2
      - id: time_and_date
        type: u4
      - id: class_id
        size: 16
        doc: '{D1BAA1C7-BAEE-4ba9-AF20-FAF66AA4DCB8} for big object files'
      - id: len_data
        type: u4
      - id: flags
        type: u4
      - id: len_metadata
        type: u4
      - id: ofs_metadata
        type: u4
      - id: num_sections
        type: u4
      - id: ofs_symbol_table
        type: u4
      - id: num_symbols
        type: u4
  optional_header:
    seq:
      - id: magic
        type: u2
      - id: version_stamp
        type: u2
      - id: len_text
        type: u4
      - id: len_initialized_data
        type: u4
      - id: len_uninitialized_data
        type: u4
      - id: entry_point
        type: u4
      - id: text_start
        type: u4
      - id: data_start
        type: u4
  section_header:
    seq:
      - id: name
        size: 8
        type: strz
      - id: physical_address
        type: u4
      - id: virtual_address
        type: u4
      - id: len_section
        type: u4
      - id: ofs_section
        type: u4
      - id: ofs_relocation_table
        type: u4
      - id: ofs_line_number_table
        type: u4
      - id: num_relocation_entries
        type: u2
      - id: num_line_number_table_entries
        type: u2
      - id: flags
        type: u4
    instances:
      section:
        io: _root._io
        pos: ofs_section
        size: len_section
        if: ofs_section != 0
      relocation_table:
        io: _root._io
        pos: ofs_relocation_table
        type: relocation_table(num_relocation_entries)
        if: ofs_relocation_table != 0 and num_relocation_entries != 0
      line_number_table:
        io: _root._io
        pos: ofs_line_number_table
        type: line_number_table(num_line_number_table_entries)
        if: ofs_line_number_table != 0 and num_line_number_table_entries != 0
      is_text:
        value: flags & 0x20 == 0x20
      is_data:
        value: flags & 0x40 == 0x40
      is_bss:
        value: flags & 0x80 == 0x80
  line_number_table:
    params:
      - id: num_line_number_table_entries
        type: u4
    seq:
      - id: entries
        type: line_number_entry
        repeat: expr
        repeat-expr: num_line_number_table_entries
  line_number_entry:
    seq:
      - id: symbol_index_or_physical_address
        type: u4
      - id: line_number
        type: u2
  relocation_table:
    params:
      - id: num_relocation_entries
        type: u4
    seq:
      - id: entries
        type: relocation_entry
        repeat: expr
        repeat-expr: num_relocation_entries
  relocation_entry:
    seq:
      - id: reference_address
        type: u4
      - id: symbol_index
        type: u4
      - id: relocation_type
        type: u2
  symbol_table_and_string_table:
    params:
      - id: num_symbols
        type: u4
    seq:
      - id: symbols
        type: symbol
        repeat: expr
        repeat-expr: num_symbols
      - id: len_strings_table
        type: u4
      - id: strings_table
        size: len_strings_table - len_strings_table._sizeof
        type: strings_table
  strings_table:
    seq:
      - id: strings
        type: strz
        repeat: eos
  symbol:
    seq:
      - id: name
        size: 8
      - id: value
        type: u4
      - id: section_number
        type:
          switch-on: _root.is_bigobj
          cases:
            true: s4
            false: u2
        doc: 32-bit in big object files, where symbol records are 20 bytes long
      - id: symbol_type
        type: u2
      - id: storage_class
        type: u1
      - id: auxiliary_count
        type: u1
