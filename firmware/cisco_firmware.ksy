# Imported from https://github.com/PAGalaxyLab/vxhunter/blob/5984b985963e2e370b536a239771110865d44ef0/firmware_tools/kaitai_ksy/cisco_firmware.ksy
# Licence and copyright: see _community/README.md
meta:
  id: cisco_firmware
  title: Cisco Firmware Image layout
  application: Firmware Image
  file-extension: ros
  license: BSD-2-Clause
  endian: le
seq:
  - id: image_header
    size: 80
    type: image_header
  - id: file_header
    type: file_header
    repeat: expr
    repeat-expr: image_header.file_count

types:
  image_header:
    seq:
      - id: unknown1
        size: 32
      - id: file_count
        type: u4
      - id: unknown2
        size: 28
      - id: version
        size: 16
        type: str
        encoding: UTF-8
  file_header:
    seq:
      - id: file_name
        size: 16
        type: str
        encoding: UTF-8
      - id: file_offset
        type: u4
      - id: file_length
        type: u4
      - id: file_type
        type: u4
      - id: unknown2
        type: u4

    instances:
      file_data:
        pos: file_offset
        size: file_length
        -webide-parse-mode: eager
    -webide-representation: "{value} (data_offs={file_offset})"
