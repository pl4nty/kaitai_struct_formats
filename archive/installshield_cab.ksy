meta:
  id: installshield_cab
  title: InstallShield cabinet (version 5 and later)
  application:
    - InstallShield
    - unshield
  file-extension:
    - cab
    - hdr
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Cabinet format of InstallShield 5 and later (not to be confused with
  Microsoft Cabinet files). An installation consists of a header file
  (`data1.hdr`) and one or more cabinet volumes (`data1.cab`, `data2.cab`,
  ...); a single-volume installation may keep the header in `data1.cab`.

  Every file starts with a common header (signature `ISc(`), followed by a
  volume header that locates the file data stored in that volume. The
  header (in `.hdr`, or in a `.cab` with a non-empty cabinet descriptor)
  holds the cabinet descriptor, the file table with the directory names
  and file descriptors, and linked lists of file groups and components.
  Offsets inside the header are relative to the cabinet descriptor.

  This spec parses the common header, the volume header, the cabinet
  descriptor, the directories, the file descriptors and the file groups,
  following unshield. The layout of the file descriptors and volume
  header differs between version 5 (and older "version 0" files, handled
  the same way) and version 6 and later; strings are UTF-16LE from
  version 17. Components and the (compressed, possibly obfuscated) file
  data are not parsed.
doc-ref:
  - https://github.com/twogood/unshield/blob/3914dffb32ad05ebcb3e7f64a033e69b59127f47/lib/cabfile.h
  - https://github.com/twogood/unshield/blob/3914dffb32ad05ebcb3e7f64a033e69b59127f47/lib/libunshield.c
  - https://github.com/twogood/unshield/blob/3914dffb32ad05ebcb3e7f64a033e69b59127f47/lib/file.c
  - https://github.com/twogood/unshield/blob/3914dffb32ad05ebcb3e7f64a033e69b59127f47/lib/file_group.c
seq:
  - id: common_header
    type: common_header
  - id: volume_header_v5
    type: volume_header_v5
    if: major_version <= 5
  - id: volume_header_v6
    type: volume_header_v6
    if: major_version > 5
instances:
  raw_major_version:
    value: |
      common_header.version >> 24 == 1 ? (common_header.version >> 12) & 0xf
        : common_header.version >> 24 == 2 or common_header.version >> 24 == 4 ? (common_header.version & 0xffff) / 100
        : 0
  major_version:
    value: 'raw_major_version < 5 ? 5 : raw_major_version'
    doc: |
      InstallShield major version derived from `common_header.version` as
      unshield does; versions below 5 (including 0) are handled as 5.
  has_cab_descriptor:
    value: common_header.len_cab_descriptor != 0
  cab_descriptor:
    pos: common_header.ofs_cab_descriptor
    type: cab_descriptor
    if: has_cab_descriptor
  ofs_file_table:
    value: common_header.ofs_cab_descriptor + cab_descriptor.ofs_file_table
    if: has_cab_descriptor
  file_table:
    pos: ofs_file_table
    type: u4
    repeat: expr
    repeat-expr: cab_descriptor.num_directories + cab_descriptor.num_files
    if: has_cab_descriptor
    doc: |
      Offsets, relative to the file table, of the directory names, followed (in
      version 5) by the offsets of the file descriptors.
  directories:
    type: directory(_index)
    repeat: expr
    repeat-expr: cab_descriptor.num_directories
    if: has_cab_descriptor
  files:
    type: file_ref(_index)
    repeat: expr
    repeat-expr: cab_descriptor.num_files
    if: has_cab_descriptor
  file_groups:
    type: offset_list(cab_descriptor.ofs_file_groups[_index])
    repeat: expr
    repeat-expr: 71
    if: has_cab_descriptor
    doc: Hash table of linked lists of file groups (empty entries have offset 0).
types:
  common_header:
    seq:
      - id: signature
        contents: [ISc(]
      - id: version
        type: u4
        doc: |
          Version of the format: `0x01xxxxxx` with the major version in bits 12-15,
          or `0x02xxxxxx` / `0x04xxxxxx` with the major version times 100 in the low
          16 bits.
      - id: volume_info
        type: u4
      - id: ofs_cab_descriptor
        type: u4
      - id: len_cab_descriptor
        type: u4
        doc: 0 in cabinet volumes without the header.
  volume_header_v5:
    doc: Locates the file data in this volume; meaningful in `.cab` volumes.
    seq:
      - id: ofs_data
        type: u4
      - id: unknown
        type: u4
      - id: first_file_index
        type: u4
      - id: last_file_index
        type: u4
      - id: first_file_offset
        type: u4
      - id: first_file_size_expanded
        type: u4
      - id: first_file_size_compressed
        type: u4
      - id: last_file_offset
        type: u4
      - id: last_file_size_expanded
        type: u4
      - id: last_file_size_compressed
        type: u4
  volume_header_v6:
    doc: Locates the file data in this volume; meaningful in `.cab` volumes.
    seq:
      - id: ofs_data
        type: u8
      - id: first_file_index
        type: u4
      - id: last_file_index
        type: u4
      - id: first_file_offset
        type: u8
      - id: first_file_size_expanded
        type: u8
      - id: first_file_size_compressed
        type: u8
      - id: last_file_offset
        type: u8
      - id: last_file_size_expanded
        type: u8
      - id: last_file_size_compressed
        type: u8
  cab_descriptor:
    seq:
      - id: unknown1
        size: 0xc
      - id: ofs_file_table
        type: u4
        doc: Offset of the file table, relative to the cabinet descriptor.
      - id: unknown2
        size: 4
      - id: len_file_table
        type: u4
      - id: len_file_table2
        type: u4
      - id: num_directories
        type: u4
      - id: unknown3
        size: 8
      - id: num_files
        type: u4
      - id: ofs_file_table2
        type: u4
        doc: |
          Offset of the file descriptors (version 6 and later), relative to the file
          table.
      - id: unknown4
        size: 0xe
      - id: ofs_file_groups
        type: u4
        repeat: expr
        repeat-expr: 71
      - id: ofs_components
        type: u4
        repeat: expr
        repeat-expr: 71
  directory:
    params:
      - id: index
        type: u4
    instances:
      name:
        io: _root._io
        pos: _root.ofs_file_table + _root.file_table[index]
        type: is_string
  file_ref:
    params:
      - id: index
        type: u4
    instances:
      descriptor_v5:
        io: _root._io
        pos: _root.ofs_file_table + _root.file_table[_root.cab_descriptor.num_directories + index]
        type: file_descriptor_v5
        if: _root.major_version <= 5
      descriptor_v6:
        io: _root._io
        pos: _root.ofs_file_table + _root.cab_descriptor.ofs_file_table2 + index * 0x57
        size: 0x57
        type: file_descriptor_v6
        if: _root.major_version > 5
      ofs_name:
        value: '_root.major_version <= 5 ? descriptor_v5.ofs_name : descriptor_v6.ofs_name'
      name:
        io: _root._io
        pos: _root.ofs_file_table + ofs_name
        type: is_string
        if: ofs_name != 0
  file_descriptor_v5:
    seq:
      - id: ofs_name
        type: u4
        doc: Offset of the file name, relative to the file table.
      - id: directory_index
        type: u2
      - id: unknown1
        size: 2
      - id: flags
        type: file_flags
      - id: len_expanded
        type: u4
      - id: len_compressed
        type: u4
      - id: unknown2
        size: 0x14
      - id: ofs_data
        type: u4
        doc: Offset of the file data in its cabinet volume.
      - id: md5
        size: 16
        if: _root.major_version == 5
  file_descriptor_v6:
    seq:
      - id: flags
        type: file_flags
      - id: len_expanded
        type: u8
      - id: len_compressed
        type: u8
      - id: ofs_data
        type: u8
        doc: Offset of the file data in its cabinet volume.
      - id: md5
        size: 16
      - id: unknown1
        size: 16
      - id: ofs_name
        type: u4
        doc: Offset of the file name, relative to the file table.
      - id: directory_index
        type: u2
      - id: unknown2
        size: 0xc
      - id: link_previous
        type: u4
      - id: link_next
        type: u4
      - id: link_flags
        type: u1
        doc: Bit 0 if linked to a previous file, bit 1 if linked to a next file.
      - id: volume
        type: u2
        doc: Number of the cabinet volume that holds the file data.
  file_flags:
    meta:
      bit-endian: le
    seq:
      - id: split
        type: b1
        doc: The file spans several cabinet volumes.
      - id: obfuscated
        type: b1
      - id: compressed
        type: b1
      - id: invalid
        type: b1
      - id: reserved
        type: b12
  offset_list:
    params:
      - id: ofs_entry
        type: u4
        doc: Offset of the entry, relative to the cabinet descriptor; 0 for none.
    instances:
      entry:
        io: _root._io
        pos: _root.common_header.ofs_cab_descriptor + ofs_entry
        type: offset_list_entry
        if: ofs_entry != 0
  offset_list_entry:
    seq:
      - id: ofs_name
        type: u4
      - id: ofs_descriptor
        type: u4
      - id: ofs_next
        type: u4
    instances:
      name:
        io: _root._io
        pos: _root.common_header.ofs_cab_descriptor + ofs_name
        type: is_string
      file_group:
        io: _root._io
        pos: _root.common_header.ofs_cab_descriptor + ofs_descriptor
        type: file_group
      next:
        type: offset_list(ofs_next)
  file_group:
    seq:
      - id: ofs_name
        type: u4
      - id: unknown
        size: '_root.major_version <= 5 ? 0x48 : 0x12'
      - id: first_file
        type: s4
        doc: Index of the first file of the group.
      - id: last_file
        type: s4
    instances:
      name:
        io: _root._io
        pos: _root.common_header.ofs_cab_descriptor + ofs_name
        type: is_string
  is_string:
    doc: NUL-terminated string, in UTF-16LE from version 17 and in ANSI before.
    seq:
      - id: ansi
        type: strz
        encoding: windows-1252
        if: _root.major_version < 17
      - id: utf16
        type: strz
        encoding: UTF-16LE
        if: _root.major_version >= 17
    instances:
      value:
        value: '_root.major_version < 17 ? ansi : utf16'
