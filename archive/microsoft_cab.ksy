meta:
  id: microsoft_cab
  title: Microsoft Cabinet (CAB) archive
  application:
    - Microsoft Windows
    - makecab
    - cabextract
  file-extension: cab
  xref:
    justsolve: CAB
    mime: application/vnd.ms-cab-compressed
    wikidata: Q216264
  license: CC0-1.0
  ks-version: '0.11'
  imports:
    - /common/dos_datetime_backwards
  encoding: ASCII
  endian: le
doc: |
  Microsoft Cabinet files store one or more files compressed in
  "folders". A folder is a single compressed stream (uncompressed,
  MSZIP, Quantum or LZX) split into data blocks of up to 32 KiB of
  uncompressed data each; files are byte ranges within the
  uncompressed stream of a folder. Large archives may be split into a
  set of cabinets, with folders and files spanning cabinet boundaries.

  This spec parses the cabinet header (including the optional
  reserved areas and the previous/next cabinet names), the folder
  table, the file table and the (still compressed) data blocks of
  each folder. Decompression is not performed.
doc-ref:
  - https://github.com/kyz/libmspack/blob/8f2a2a91ae2d12f985a196d481962ca4731f0f4d/libmspack/mspack/cab.h
  - https://github.com/kyz/libmspack/blob/8f2a2a91ae2d12f985a196d481962ca4731f0f4d/libmspack/mspack/cabd.c
  - https://github.com/wine-mirror/wine/blob/ff2631c6ed3d1721cd050d951671c307ade32b90/dlls/cabinet/fci.c
seq:
  - id: header
    type: header
  - id: folders
    type: folder
    repeat: expr
    repeat-expr: header.num_folders
instances:
  files:
    pos: header.ofs_files
    type: file
    repeat: expr
    repeat-expr: header.num_files
types:
  header:
    -orig-id: CFHEADER
    seq:
      - id: signature
        contents: MSCF
      - id: reserved1
        type: u4
      - id: len_cabinet
        -orig-id: cbCabinet
        type: u4
        doc: Size of this cabinet file in bytes.
      - id: reserved2
        type: u4
      - id: ofs_files
        -orig-id: coffFiles
        type: u4
        doc: Offset of the first CFFILE entry.
      - id: reserved3
        type: u4
      - id: version_minor
        -orig-id: versionMinor
        type: u1
        doc: Currently 3.
      - id: version_major
        type: u1
        doc: Currently 1.
      - id: num_folders
        -orig-id: cFolders
        type: u2
      - id: num_files
        -orig-id: cFiles
        type: u2
      - id: flags
        type: header_flags
      - id: set_id
        -orig-id: setID
        type: u2
        doc: Identifier shared by all cabinets of a set.
      - id: idx_cabinet
        -orig-id: iCabinet
        type: u2
        doc: Zero-based number of this cabinet in its set.
      - id: len_header_reserve
        -orig-id: cbCFHeader
        type: u2
        if: flags.reserve_present
      - id: len_folder_reserve
        -orig-id: cbCFFolder
        type: u1
        if: flags.reserve_present
      - id: len_data_reserve
        -orig-id: cbCFData
        type: u1
        if: flags.reserve_present
      - id: header_reserve
        size: len_header_reserve
        if: flags.reserve_present
        doc: Application-defined data (e.g. Authenticode signature info).
      - id: prev_cabinet_name
        type: strz
        if: flags.prev_cabinet
      - id: prev_disk_name
        type: strz
        if: flags.prev_cabinet
      - id: next_cabinet_name
        type: strz
        if: flags.next_cabinet
      - id: next_disk_name
        type: strz
        if: flags.next_cabinet
    instances:
      folder_reserve_size:
        value: 'flags.reserve_present ? len_folder_reserve : 0'
      data_reserve_size:
        value: 'flags.reserve_present ? len_data_reserve : 0'
  header_flags:
    meta:
      bit-endian: le
    seq:
      - id: prev_cabinet
        -orig-id: cfheadPREV_CABINET
        type: b1
      - id: next_cabinet
        -orig-id: cfheadNEXT_CABINET
        type: b1
      - id: reserve_present
        -orig-id: cfheadRESERVE_PRESENT
        type: b1
      - id: reserved
        type: b13
  folder:
    -orig-id: CFFOLDER
    seq:
      - id: ofs_first_data_block
        -orig-id: coffCabStart
        type: u4
        doc: Offset of the first CFDATA block of this folder.
      - id: num_data_blocks
        -orig-id: cCFData
        type: u2
        doc: Number of CFDATA blocks of this folder in this cabinet.
      - id: compression
        -orig-id: typeCompress
        type: compression_type
      - id: reserve
        size: _root.header.folder_reserve_size
    instances:
      data_blocks:
        pos: ofs_first_data_block
        type: data_block
        repeat: expr
        repeat-expr: num_data_blocks
  compression_type:
    meta:
      bit-endian: le
    seq:
      - id: method
        type: b4
        enum: compression_method
      - id: reserved1
        type: b4
      - id: window_or_level
        type: b5
        doc: |
          For LZX, the window size as a power of two (15..21).
          For Quantum, the window size as a power of two (10..21).
      - id: reserved2
        type: b3
  file:
    -orig-id: CFFILE
    seq:
      - id: len_uncompressed
        -orig-id: cbFile
        type: u4
      - id: ofs_in_folder
        -orig-id: uoffFolderStart
        type: u4
        doc: Offset of the file within the uncompressed folder stream.
      - id: idx_folder
        -orig-id: iFolder
        type: u2
        doc: |
          Index into the folder table, or one of the special values
          0xfffd (continued from the previous cabinet), 0xfffe (continued
          to the next cabinet) or 0xffff (both).
      - id: timestamp
        type: dos_datetime_backwards
      - id: attributes
        -orig-id: attribs
        type: file_attributes
      - id: name
        type: strz
        encoding: UTF-8
        if: attributes.name_is_utf8
      - id: name_ansi
        terminator: 0
        if: not attributes.name_is_utf8
        doc: File name in the code page of the system that created the cabinet.
    instances:
      is_continued_from_prev:
        value: idx_folder == 0xfffd or idx_folder == 0xffff
      is_continued_to_next:
        value: idx_folder == 0xfffe or idx_folder == 0xffff
  file_attributes:
    meta:
      bit-endian: le
    seq:
      - id: read_only
        -orig-id: _A_RDONLY
        type: b1
      - id: hidden
        -orig-id: _A_HIDDEN
        type: b1
      - id: system
        -orig-id: _A_SYSTEM
        type: b1
      - id: reserved1
        type: b2
      - id: archive
        -orig-id: _A_ARCH
        type: b1
      - id: execute
        -orig-id: _A_EXEC
        type: b1
      - id: name_is_utf8
        -orig-id: _A_NAME_IS_UTF
        type: b1
      - id: reserved2
        type: b8
  data_block:
    -orig-id: CFDATA
    seq:
      - id: checksum
        -orig-id: csum
        type: u4
        doc: Checksum of this block, or 0 if not computed.
      - id: len_data
        -orig-id: cbData
        type: u2
      - id: len_uncompressed
        -orig-id: cbUncomp
        type: u2
        doc: 0 if this block is continued in the next cabinet of the set.
      - id: reserve
        size: _root.header.data_reserve_size
      - id: data
        size: len_data
        doc: Compressed data (for MSZIP, prefixed with the "CK" signature).
enums:
  compression_method:
    0: none
    1: mszip
    2: quantum
    3: lzx
