# Imported from https://github.com/efonte/patapon-re/blob/7cc421a84994521e4e7692dfc8adf3f7fcb781b5/Kaitai Struct/patapon_bnd.ksy
meta:
  id: patapon_bnd
  title: Patapon (bnd)
  file-extension: bnd
  license: MIT
  endian: le
seq:
  - id: header
    type: header
  - id: padding1
    size: (header.num_entries - entries.size) * 16
  #- id: padding2
  #  size: header.file_offset - _io.pos
instances:
  entries:
    pos: header.info_offset
    type: entry
    repeat: until
    repeat-until: _.current_size == -1

types:
  header:
    seq:
      - id: magic
        contents: ["BND", 0]
      - id: version
        type: u4
      - id: unk1
        type: u4
      - id: unk2
        type: u4
      - id: info_offset
        type: u4
      - id: file_offset
        type: u4
      - id: padding1
        size: 8
      - id: num_files
        type: u4
      - id: num_entries
        type: u4

  entry:
    seq:
      - id: folder_level
        type: s1
      - id: previous_size
        type: s1
      - id: current_size
        type: s1
      - id: crc_offset
        type: u4
      - id: filename
        type: strz
        encoding: UTF-8
    instances:
      crc:
        pos: crc_offset
        type: u4
      info_offset:
        pos: crc_offset + 4
        type: u4
      file_offset:
        pos: crc_offset + 8
        type: u4
      file_size:
        pos: crc_offset + 12
        type: u4
      file_data:
        pos: file_offset
        size: file_size
