# Imported from https://github.com/HemanthJabalpuri/nb0-unpack/blob/b97ad1f69a263da35768c982a48706064c50c4d1/ksy/nb0.ksy
# Licence and copyright: see _community/README.md
meta:
  id: nb0
  title: Nokia .nb0 firmware file
  file-extension: nb0
  license: CC0-1.0
  endian: le
seq:
# Since there are no magic signatures in this file type, it can be simply verified by
# adding last file offset and last file size must be equal to total file size
  - id: num_part_headers
    type: u4
  - id: part_headers
    type: part_header
    repeat: expr
    repeat-expr: num_part_headers
types:
  part_header:
    seq:
      - id: lo_data_offset
        type: u4
      - id: lo_file_size
        type: u4
      - id: hi_data_offset
        type: u4
      - id: hi_file_size
        type: u4
      - id: file_name
        size: 48
        type: strz
        encoding: ASCII
    -webide-representation: '{file_name} off:{ofs_part} len:{len_part}'
    instances:
      ofs_part:
        value: _root.num_part_headers._sizeof + _root.num_part_headers * 64 + hi_data_offset * 0x100000000 + lo_data_offset
        # Above 64 value is size of part_header
      len_part:
        value: hi_file_size * 0x100000000 + lo_file_size
      part:
        io: _root._io
        pos: ofs_part
        size: len_part
