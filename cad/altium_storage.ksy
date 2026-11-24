# Imported from https://github.com/KiCad/kicad-source-mirror/blob/c508d01f46c7f04fd475d40c6fac93d10fae49b2/eeschema/sch_io/altium/altium_storage_parser.ksy
# Licence and copyright: see _community/README.md
# Can be viewed in: https://ide.kaitai.io/
#
# This file is a formal specification of the binary format used in Altium SchDoc for the Storage file.
# Files need to manually extracted using a program which can read the Microsoft Compound File Format.
#
# While I do not create a parser using this file, it is still very helpful to understand the binary
# format.

meta:
  id: altium_storage
  title: Altium schematic Storage stream
  license: GPL-3.0-or-later
  encoding: UTF-8
  endian: le

seq:
  - id: properties_length
    type: u4
  - id: properties
    size: properties_length
    type: str
  - id: record
    type: record
    repeat: eos


types:
  record:
    seq:
      - size: 5
      - id: filename_length
        type: u1
      - id: filename
        size: filename_length
        type: str
      - id: data_length
        type: u4
      - id: data
        size: data_length
