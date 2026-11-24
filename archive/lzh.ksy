meta:
  id: lzh
  application: LHA (AKA LHarc) by Yoshizaki Haruyasu
  file-extension: lzh
  xref:
    justsolve: LHA
    pronom: fmt/626
    wikidata: Q368782
  license: CC0-1.0
  imports:
    - /common/dos_datetime
  endian: le
doc: |
  LHA (LHarc, LZH) is a file format used by a popular freeware
  eponymous archiver, created in 1988 by Haruyasu Yoshizaki. Over the
  years, many ports and implementations were developed, sporting many
  extensions to original 1988 LZH.

  File format is pretty simple and essentially consists of a stream of
  records.
seq:
  - id: entries
    type: record
    repeat: eos
types:
  record:
    seq:
      - id: header_len
        type: u1
      - id: file_record
        type: file_record
        if: header_len > 0
  file_record:
    seq:
      - id: header
        size: _parent.header_len - 1
        type: header
      - id: file_uncompr_crc16
        type: u2
        if: header.header1.lha_level == 0
      - id: len_first_ext_header
        type: u2
        if: header.header1.lha_level == 1
        doc: Size of the first extended header, 0 if there are none
      - id: ext_headers
        type: ext_header(len_first_ext_header)
        if: header.header1.lha_level == 1 and len_first_ext_header != 0
        doc: |
          Level 1 extended headers. Unlike level 2, they are not counted in
          the header size but in `file_size_compr`.
      - id: body
        size: header.header1.file_size_compr - len_ext_headers
    instances:
      len_ext_headers:
        value: 'header.header1.lha_level == 1 and len_first_ext_header != 0 ? ext_headers.len_total : 0'
  ext_header:
    doc: |
      Extended header, followed by the next one as long as the size of the
      next header is non-zero.
    params:
      - id: len_header
        type: u2
        doc: Size of this extended header, including the next header size field
    seq:
      - id: header_type
        type: u1
      - id: data
        size: len_header - 3
      - id: len_next_header
        type: u2
      - id: next
        type: ext_header(len_next_header)
        if: len_next_header != 0
    instances:
      len_total:
        value: 'len_header + (len_next_header != 0 ? next.len_total.as<u4> : 0)'
        doc: Total size of this and all following extended headers
  header:
    seq:
      - id: header1
        type: header1
        doc: |
          Level-neutral header, same for all LHA levels. Subsequent
          fields order and meaning varies, based on LHA level
          specified in this header.
      - id: filename_len
        type: u1
        if: header1.lha_level == 0 or header1.lha_level == 1
      - id: filename
        size: filename_len
        type: str
        encoding: ASCII
        if: header1.lha_level == 0 or header1.lha_level == 1
      - id: file_uncompr_crc16
        type: u2
        if: header1.lha_level == 1 or header1.lha_level == 2
      - id: os
        type: u1
        if: header1.lha_level == 1 or header1.lha_level == 2
      - id: ext_header_size
        type: u2
        if: header1.lha_level == 2
  header1:
    seq:
      - id: header_checksum
        type: u1
      - id: method_id
        size: 5
        type: str
        encoding: ASCII
      - id: file_size_compr
        type: u4
        doc: |
          Compressed file size. In level 1 headers it also includes the
          size of all extended headers.
      - id: file_size_uncompr
        type: u4
        doc: Uncompressed file size
      - id: file_timestamp
        size: 4
        type: dos_datetime
        doc: Original file date/time
      - id: attr
        type: u1
        doc: File or directory attribute
      - id: lha_level
        type: u1
