meta:
  id: zeno
  title: Zeno article library
  application:
    - ZenoReader
    - zimlib (first versions)
  file-extension: zeno
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Zeno is the file format of DirectMedia Publishing's ZenoReader, used
  for the 2006/2007 offline editions of the German Wikipedia and other
  encyclopedias. It is the predecessor of the openZIM (Zeno IMproved)
  format and is no longer in use.

  A .zeno file starts with a header (a Delphi record), followed by a
  table of contents of variable-length directory entries, a list of
  32-bit pointers into it (one per article, sorted by namespace and
  title) and the article data, each article stored at an absolute file
  position, optionally compressed.

  This spec covers the header fields shared by the documentation and the
  first zimlib reader, the pointer list, the directory entries and the
  location of each article's data. Not covered: the remaining header
  fields (tree data position and length, total article count of index
  files, "index compressed" flag, and the position and length of the
  namespace count table), whose offsets depend on Delphi record
  alignment and could not be verified; the extra data of index files
  (namespaces V, W, X) with their compressed integers; and decompression
  of article data.

  Titles use "Qunicode", an ad-hoc encoding: bytes 0x20-0xFF are single
  characters (so that umlauts take one byte), 0x01 is followed by a
  16-bit little-endian Unicode code unit, and 0x02 by one whose low byte
  is zero (stored as 1). They are therefore kept as bytes.

  Bytes 16-23 of a directory entry are the redirect target and a
  "logical number" in the Zeno documentation; the first zimlib commit,
  already moving towards ZIM, reads them as offset and size of the
  article within a compressed cluster instead. The documentation also
  says that len_extra includes a terminating zero byte, which zimlib
  does not write; the title is read up to a zero byte or the end of the
  extra data, which works either way.

  The format is described in German on the openZIM wiki; no sample file
  was available to test this spec.
doc-ref:
  - https://www.openzim.org/wiki/Zeno_file_format
  - https://github.com/openzim/libzim/blob/9f8ce14747d35a89f3433339e44a2e23ea16b758/include/zim/fileheader.h
  - https://github.com/openzim/libzim/blob/9f8ce14747d35a89f3433339e44a2e23ea16b758/include/zim/dirent.h
  - https://github.com/openzim/libzim/blob/9f8ce14747d35a89f3433339e44a2e23ea16b758/src/fileimpl.cpp
seq:
  - id: magic
    contents: [0xa3, 0xa0, 0xd2, 0x55]
    doc: 1439867043 as a 32-bit integer.
  - id: version
    type: u4
    doc: Format version; 2 for the 2006 and 3 for the 2007 Wikipedia edition.
  - id: num_index_ptrs
    -orig-id: rCount
    type: u4
    doc: Number of articles.
  - id: unused1
    type: u4
    doc: Alignment gap before the next 64-bit field.
  - id: ofs_index
    -orig-id: rIndexPos
    type: u8
    doc: Position of the table of contents (directory entries).
  - id: len_index
    -orig-id: rIndexLen
    type: u4
  - id: unused2
    type: u4
    doc: Formerly flags.
  - id: ofs_index_ptrs
    -orig-id: rIndexPtrPos
    type: u8
    doc: Position of the pointer list into the table of contents.
  - id: len_index_ptrs
    -orig-id: rIndexPtrLen
    type: u4
    doc: Length of the pointer list, 4 * num_index_ptrs.
instances:
  index_ptrs:
    pos: ofs_index_ptrs
    type: u4
    repeat: expr
    repeat-expr: num_index_ptrs
    doc: |
      Offset of each article's directory entry relative to ofs_index,
      sorted by namespace and title.
  dir_entries:
    type: dir_entry_ptr(index_ptrs[_index])
    repeat: expr
    repeat-expr: index_ptrs.size
    doc: Directory entries in pointer list order.
types:
  dir_entry_ptr:
    params:
      - id: ofs_entry
        type: u4
    instances:
      entry:
        io: _root._io
        pos: _root.ofs_index + ofs_entry
        type: dir_entry
  dir_entry:
    -orig-id: RZenoArticle
    seq:
      - id: ofs_data
        -orig-id: rFilePos
        type: u8
        doc: Absolute position of the article data.
      - id: len_data
        -orig-id: rFileLen
        type: u4
      - id: compression
        -orig-id: rCompression
        type: u1
        enum: compression
      - id: mime_type
        -orig-id: rMime
        type: u1
        enum: mime_type
      - id: redirect_flag
        -orig-id: rRedirectFlag
        type: u1
        doc: Non-zero if this article redirects to another one.
      - id: namespace
        -orig-id: rNamespace
        size: 1
        type: str
        encoding: ASCII
        doc: Namespace character, '-' to 'Z' ('A' for articles, 'B', ...).
      - id: redirect_index
        -orig-id: rRedirectIndex
        type: u4
        doc: Index of the target article if redirect_flag is set.
      - id: logical_number
        -orig-id: rLogicalNumber
        type: u4
        doc: Not used in the Wikipedia editions.
      - id: len_extra
        -orig-id: rExtraLen
        type: u2
        doc: Length of the following title and parameters.
      - id: extra
        -orig-id: rExtra
        size: len_extra
        type: dir_entry_extra
    instances:
      data:
        io: _root._io
        pos: ofs_data
        size: len_data
        doc: Article data, compressed as given by `compression`.
  dir_entry_extra:
    seq:
      - id: title
        terminator: 0
        eos-error: false
        doc: Title in Qunicode encoding.
      - id: parameters
        size-eos: true
        doc: Optional parameters such as `h=200`, separated by zero bytes.
enums:
  compression:
    0: default
    1: none
    2: zip
  mime_type:
    0: text_html
    1: text_plain
    2: image_jpeg
    3: image_png
    4: image_tiff
    5: text_css
    6: image_gif
    7: index
    8: application_javascript
    9: image_icon
    10: text_xml
