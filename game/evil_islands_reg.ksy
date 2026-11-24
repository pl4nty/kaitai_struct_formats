meta:
  id: evil_islands_reg
  title: Evil Islands, REG file (packed INI)
  application: Evil Islands
  file-extension: reg
  license: MIT
  endian: le
doc: Packed INI file
doc-ref: https://github.com/aspadm/EIrepack/wiki/reg
seq:
  - id: magic
    contents: [0xFB, 0x3E, 0xAB, 0x45]
  - id: num_sections
    type: u2
  - id: sections_table
    type: section_record
    repeat: expr
    repeat-expr: num_sections
types:
  section_record:
    seq:
      - id: order
        type: s2
        doc: Section order number in file
      - id: ofs_section
        type: u4
        doc: Global section offset in file
    instances:
      section:
        pos: ofs_section
        type: section
    types:
      section:
        seq:
          - id: num_keys
            type: u2
          - id: len_name
            type: u2
            doc: Section name length
          - id: name
            size: len_name
            type: str
            encoding: windows-1251
            doc: Section name
          - id: keys
            type: key_record
            repeat: expr
            repeat-expr: num_keys
        types:
          key_record:
            doc: Named key
            seq:
              - id: order
                type: s2
                doc: Key order in section
              - id: ofs_key
                type: u4
                doc: Key offset in section
            instances:
              key:
                pos: _parent._parent.ofs_section + ofs_key
                type: key_data
          key_data:
            seq:
              - id: packed_type
                type: u1
              - id: len_name
                type: u2
              - id: name
                size: len_name
                type: str
                encoding: windows-1251
              - id: num_values
                type: u2
                if: is_array
              - id: value
                type:
                  switch-on: value_type
                  cases:
                    'key_value_types::integer': int_value
                    'key_value_types::real': float_value
                    'key_value_types::text': string_value
                repeat: expr
                repeat-expr: 'is_array ? num_values : 1'
            instances:
              is_array:
                value: packed_type > 127
              value_type:
                value: packed_type & 0x7F
                enum: key_value_types
            enums:
              key_value_types:
                0: integer
                1: real
                2: text
            types:
              int_value:
                seq:
                  - id: value
                    type: s4
              float_value:
                seq:
                  - id: value
                    type: f4
              string_value:
                seq:
                  - id: len_value
                    type: u2
                  - id: value
                    size: len_value
                    type: str
                    encoding: windows-1251
