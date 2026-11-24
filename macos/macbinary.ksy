# Imported from https://github.com/adespoton/kaitai-applebackup/blob/37c7fa8503f1e6b8ac87d9d5e7068e836fa04daf/macbinary.ksy
meta:
  id: macbinary
  title: MacBinary III flattened Macintosh file
  application: macbinary I through III
  file-extension: bin
  license: MIT
  endian: be
doc: |
  The binary format consists of a 128-byte header containing all the information
  necessary 
  to reproduce the document's directory entry on the receiving Macintosh; 
  followed by the document's Data Fork (if it has one), padded with nulls to 
  a multiple of 128 bytes (if necessary); followed by the document's Resource Fork 
  (again, padded if necessary). The lengths of these forks (either or both of
  which may be zero) 
  are contained in the header.
doc-ref: http://web.archive.org/web/20050305044255/http://www.lazerware.com:80/formats/macbinary/macbinary_iii.html
seq:
  - id: old_section_header
    contents: [0]
  - id: filename_length
    type: u1
  - id: filename
    size: filename_length
    type: str
    encoding: ASCII
  - id: filename_padding
    size: (63 - filename_length)
  - id: file_type
    size: 4
    type: str
    encoding: ASCII
  - id: file_creator
    size: 4
    type: str
    encoding: ASCII
  - id: finder_flags_8_f
    size: 1
    doc: |
      Bit 7 - isAlias. 
      Bit 6 - isInvisible. 
      Bit 5 - hasBundle. 
      Bit 4 - nameLocked. 
      Bit 3 - isStationery. 
      Bit 2 - hasCustomIcon. 
      Bit 1 - reserved. 
      Bit 0 - hasBeenInited.
  - id: zero_fill
    contents: [0]
  - id: win_y_pos
    type: u2
  - id: win_x_pos
    type: u2
  - id: win_id
    type: u2
  - id: protected_flag
    type: u1
  - id: zero_fill_2
    contents: [0]
  - id: data_fork_length
    type: u4
  - id: resource_fork_length
    type: u4
  - id: creation_date
    type: u4
    doc: seconds since Jan 1, 1904
  - id: modification_date
    type: u4
    doc: seconds since Jan 1, 1904
  - id: get_info_length
    type: u2
  - id: finder_flags_0_7
    type: u1
    doc: |
      Bit 7 - hasNoInits 
      Bit 6 - isShared 
      Bit 5 - requiresSwitchLaunch
      Bit 4 - ColorReserved
      Bits 1-3 - color 
      Bit 0 - isOnDesk
  - id: signature
    type: u4
  - id: fd_script
    type: u1
    doc: script of file name from fdScript field of fxInfo record
  - id: fd_x_flags
    type: u1
    doc: extended finder flags from fdXFlags field of fxInfo record
  - id: padding
    size: 8
  - id: total_unpacked_files_length
    type: u4
  - id: second_header_length
    type: u2
    doc: |
      if non-zero, skip this many bytes, 
      rounded up to the next multiple of 128.
      This was reserved for future use, and has never been used.
      So this value should always be 0.
  - id: second_header
    size: second_header_length
    if: second_header_length != 0
  - id: second_header_padding
    size: (128 - (second_header_length % 128))
    if: second_header_length != 0
  - id: macbinary_version
    type: u1
  - id: min_macbinary_version_needed
    type: u1
  - id: crc_check
    type: u4
  - id: data_fork
    size: data_fork_length
    if: data_fork_length != 0
  - id: data_fork_padding
    size: (128 - (data_fork_length % 128))
    if: (data_fork_length % 128) != 0
  - id: resource_fork
    size: resource_fork_length
  - id: resource_fork_padding
    size: (128 - (resource_fork_length % 128))
