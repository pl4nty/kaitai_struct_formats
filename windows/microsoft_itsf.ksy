meta:
  id: microsoft_itsf
  title: Microsoft Compiled HTML Help (CHM) / Info-Tech Storage Format (ITSF)
  application: Microsoft HTML Help
  file-extension:
    - chm
    - chi
    - chq
    - chw
  xref:
    justsolve: CHM
    mime: application/vnd.ms-htmlhelp
    pronom: fmt/634
    wikidata: Q1023647
  tags:
    - windows
  license: CC0-1.0
  ks-version: '0.9'
  imports:
    - /common/vlq_base128_be
  encoding: UTF-8
  endian: le
doc: |
  ITSF ("Info-Tech Storage Format") is the container format of Microsoft
  Compiled HTML Help (`.chm`) files. It is a simple file system: a header
  pointing to two header sections, a directory made of fixed-size chunks
  (`PMGL` listing chunks and optional `PMGI` index chunks), and a content
  area. Each directory entry gives a file name, the content section it lives
  in, and its offset and length within that section.

  Content section 0 is stored uncompressed directly in the file. Section 1
  (`MSCompressed`) is itself stored as the file
  `::DataSpace/Storage/MSCompressed/Content` in section 0 and is compressed
  with LZX.

  This spec parses the header, both header sections and all directory chunks
  with their entries. For files in section 0, their data is available via
  `directory_entry.body`. LZX-compressed section 1 is not decompressed.
  Integers in directory entries (ENCINT) are big-endian base-128 numbers.
doc-ref:
  - https://web.archive.org/web/2024/http://www.russotto.net/chm/chmformat.html
  - https://github.com/kyz/libmspack/blob/8f2a2a91ae2d12f985a196d481962ca4731f0f4d/libmspack/mspack/chmd.c
seq:
  - id: magic
    contents: ITSF
  - id: version
    type: u4
    doc: 3 for most files, 2 for some older ones.
  - id: len_header
    type: u4
    doc: Total header length, including the header section table and the content offset.
  - id: unknown1
    type: u4
  - id: timestamp
    type: u4be
  - id: language_id
    type: u4
    doc: Windows language ID (LCID).
  - id: guid1
    size: 16
    doc: '{7C01FD10-7BAA-11D0-9E0C-00A0C922E6EC}'
  - id: guid2
    size: 16
    doc: '{7C01FD11-7BAA-11D0-9E0C-00A0C922E6EC}'
  - id: header_sections
    type: header_section_entry
    repeat: expr
    repeat-expr: 2
    doc: Location of header section 0 (file length) and header section 1 (directory).
  - id: ofs_content_section0_v3
    type: u8
    if: version >= 3
instances:
  header_section0:
    pos: header_sections[0].ofs_body
    size: header_sections[0].len_body
    type: header_section0
  directory:
    pos: header_sections[1].ofs_body
    type: directory
  ofs_content_section0:
    value: |
      version >= 3
        ? ofs_content_section0_v3
        : header_sections[1].ofs_body + directory.header.len_header + directory.header.len_chunk * directory.header.num_chunks
    doc: |
      Absolute offset of content section 0; offsets of files in section 0 are relative
      to it.
types:
  header_section_entry:
    seq:
      - id: ofs_body
        type: u8
      - id: len_body
        type: u8
  header_section0:
    seq:
      - id: unknown1
        type: u4
        doc: Usually 0x1FE.
      - id: unknown2
        type: u4
      - id: len_file
        type: u8
        doc: Total size of the file.
      - id: unknown3
        type: u4
      - id: unknown4
        type: u4
  directory:
    seq:
      - id: header
        type: directory_header
      - id: chunks
        size: header.len_chunk
        type: directory_chunk
        repeat: expr
        repeat-expr: header.num_chunks
  directory_header:
    seq:
      - id: magic
        contents: ITSP
      - id: version
        type: u4
      - id: len_header
        type: u4
        doc: Length of this header, usually 0x54.
      - id: unknown1
        type: u4
      - id: len_chunk
        type: u4
        doc: Size of each directory chunk, usually 0x1000.
      - id: quickref_density
        type: u4
        doc: Density of the quickref area, usually 2.
      - id: index_depth
        type: u4
        doc: |
          Depth of the index tree; 1 if there is no index, 2 with one level of PMGI
          chunks.
      - id: index_root_chunk
        type: s4
        doc: Chunk number of the root PMGI chunk, -1 if there is none.
      - id: first_pmgl_chunk
        type: u4
      - id: last_pmgl_chunk
        type: u4
      - id: unknown2
        type: s4
      - id: num_chunks
        type: u4
        doc: Total number of directory chunks.
      - id: language_id
        type: u4
      - id: guid
        size: 16
        doc: '{5D02926A-212E-11D0-9DF9-00A0C922E6EC}'
      - id: len_header2
        type: u4
      - id: unknown3
        size: len_header - 0x48
  directory_chunk:
    seq:
      - id: magic
        size: 4
        type: str
        encoding: ASCII
      - id: body
        type:
          switch-on: magic
          cases:
            '"PMGL"': listing_chunk
            '"PMGI"': index_chunk
  listing_chunk:
    doc: |
      Listing chunk (PMGL), holding directory entries sorted by name
      (case-insensitively), followed by free space and the quickref area,
      which is written backwards from the end of the chunk.
    seq:
      - id: len_free_space
        type: u4
        doc: Length of the free space and quickref area at the end of the chunk.
      - id: unknown1
        type: u4
      - id: prev_chunk
        type: s4
        doc: Previous listing chunk, -1 for the first.
      - id: next_chunk
        type: s4
        doc: Next listing chunk, -1 for the last.
      - id: entries
        type: directory_entry
        repeat: expr
        repeat-expr: num_entries
    instances:
      num_entries:
        pos: _io.size - 2
        type: u2
  index_chunk:
    doc: Index chunk (PMGI), mapping names to the chunks where listings for them start.
    seq:
      - id: len_free_space
        type: u4
      - id: entries
        type: index_entry
        repeat: expr
        repeat-expr: num_entries
    instances:
      num_entries:
        pos: _io.size - 2
        type: u2
  directory_entry:
    seq:
      - id: len_name
        type: vlq_base128_be
      - id: name
        size: len_name.value
        type: str
        doc: |
          File name. Names starting with `::` are format-related files, names
          starting with `/` are user files; names ending with `/` denote
          directories.
      - id: section
        type: vlq_base128_be
        doc: Content section (0 = uncompressed, 1 = MSCompressed).
      - id: ofs_in_section
        type: vlq_base128_be
        doc: Offset within the (decompressed) content section.
      - id: len_body
        type: vlq_base128_be
        doc: Length of the file within the (decompressed) content section.
    instances:
      body:
        io: _root._io
        pos: _root.ofs_content_section0 + ofs_in_section.value
        size: len_body.value
        if: section.value == 0
  index_entry:
    seq:
      - id: len_name
        type: vlq_base128_be
      - id: name
        size: len_name.value
        type: str
      - id: chunk
        type: vlq_base128_be
        doc: Number of the chunk where the listing starting with this name is located.
