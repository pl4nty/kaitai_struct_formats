# Imported from https://github.com/jharuda/mafia-kaitai-struct/blob/d95ef5d3ef8031410ee3b03d6406f07deb679872/src_ks/mf_sounds_dat.ksy
meta:
  id: mafia_format_sounds
  file-extension: dat
  license: GPL-3.0-only
  endian: le

seq:
  - id: magic_number
    contents: [0x02, 0x00, 0x00, 0x00]
  - id: unknown1
    type: u4
  - id: unknown2
    type: u4
  - id: blocks_first
    type: block_first_t
  - id: blocks_second
    type: block_second_t

types:
  block_first_t:
    seq:
      - id: records_count
        type: u4
      - id: records
        type: record_t
        repeat: expr
        repeat-expr: records_count

    types:
      record_t:
        seq:
          - id: name
            size: 32 # string ends with '\0' and then there are 0xCC bytes
            type: str
            encoding: ASCII
          - id: number
            type: u4

  block_second_t:
    seq:
      - id: records_count
        type: u4
      - id: records
        type: record_t
        repeat: expr
        repeat-expr: records_count

    types:
      record_t:
        seq:
          - id: sound_name_size
            type: u4
          - id: sound_name
            size: sound_name_size
            type: str
            encoding: ASCII
          - id: number
            type: u4
          - id: unknown1
            type: u4
          - id: wav_count
            type: u1    #count of WAW records
          - id: unknown_data_count
            type: u1
          - id: wav_descriptions
            type: wav_description_t
            repeat: expr
            repeat-expr: wav_count
          - id: unknown_data
            type: unknown_data_t
            repeat: expr
            repeat-expr: unknown_data_count
            if: wav_count != 0

      wav_description_t:
        seq:
          - id: wav_name_size
            type: u4
          - id: wav_name
            size: wav_name_size
            type: str
            encoding: ASCII
          - id: unknown
            type: u4
            
      unknown_data_t:
        seq:
          - id: data
            type: u1
            repeat: expr
            repeat-expr: 36
