meta:
  id: tcl_cookfs
  title: Tcl cookfs archive (format 2)
  application:
    - Tcl vfs::cookfs
    - CooKit
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  cookfs is a virtual file system for Tcl, written for the CooKit
  single-file executables: an archive usually appended to a Tcl
  executable or other file, read from its end.

  File contents are stored in "pages", each optionally compressed and
  each holding one or more files or parts of files. The archive ends
  with, in this order: the page data, the MD5 checksums of all pages, the
  stored size of every page, the file system index (itself stored like a
  page), and a 16-byte suffix with the index size, the number of pages,
  the default compression and the signature "CFS0002". The start of the
  archive within the file is computed from these sizes.

  Every stored page and the index start with a compression byte (0 =
  none, 1 = zlib, i.e. raw deflate without header, 2 = bzip2, 255 =
  custom Tcl command); the stored sizes include it. The index ("fsindex")
  is a tree of directories; files are described by lists of
  (page, offset, size) triplets, so that small files can share a page
  and large files can span several. An optional list of named metadata
  values follows the tree.

  This spec assumes the archive ends at the end of the file (cookfs
  itself looks for the last signature in the final 4 KiB, or uses an
  explicit end offset). The index is parsed only when it is stored
  uncompressed; otherwise decompress `index.data` (raw deflate for zlib)
  and parse it as the `fsindex` type. Page contents are not decompressed.
  The layout follows the original cookfs 1.3.2 sources; later versions
  of the maintained fork add compression methods and encryption.
doc-ref:
  - https://svn.code.sf.net/p/cookit/code/!svn/bc/221/cookfs/generic/pages.c
  - https://svn.code.sf.net/p/cookit/code/!svn/bc/221/cookfs/generic/pagesCompr.c
  - https://svn.code.sf.net/p/cookit/code/!svn/bc/221/cookfs/generic/fsindexIO.c
  - https://svn.code.sf.net/p/cookit/code/!svn/bc/221/cookfs/cookfswriter/cookfswriter.tcl
instances:
  suffix:
    pos: _io.size - 16
    type: suffix
  ofs_index:
    value: _io.size - 16 - suffix.len_index
  ofs_md5s:
    value: ofs_index - 20 * suffix.num_pages
  ofs_page_sizes:
    value: ofs_md5s + 16 * suffix.num_pages
  ofs_pages:
    value: 'ofs_md5s - (suffix.num_pages == 0 ? 0 : page_sizes[suffix.num_pages - 1].end)'
    doc: Start of the cookfs archive (and of its first page) in the file.
  index:
    pos: ofs_index
    size: suffix.len_index
    type: stored_index
  page_md5s:
    pos: ofs_md5s
    size: 16
    repeat: expr
    repeat-expr: suffix.num_pages
    doc: MD5 of the stored page data of each page.
  page_sizes:
    pos: ofs_page_sizes
    type: 'page_size(_index == 0 ? 0 : page_sizes[_index - 1].end)'
    repeat: expr
    repeat-expr: suffix.num_pages
  pages:
    pos: ofs_pages
    type: page(page_sizes[_index].len_page)
    repeat: expr
    repeat-expr: suffix.num_pages
types:
  suffix:
    seq:
      - id: len_index
        type: u4
        doc: Stored size of the index, including its compression byte.
      - id: num_pages
        type: u4
      - id: default_compression
        type: u1
        enum: compression
        doc: Compression used for new pages.
      - id: signature
        contents: CFS0002
  page_size:
    params:
      - id: start
        type: u8
        doc: Offset of this page relative to the first page.
    seq:
      - id: len_page
        type: u4
        doc: Stored size of the page, including its compression byte.
    instances:
      end:
        value: start + len_page
  page:
    params:
      - id: len_page
        type: u4
    seq:
      - id: compression
        type: u1
        enum: compression
        if: len_page > 0
      - id: data
        size: len_page - 1
        if: len_page > 0
        doc: Page contents, compressed as given by `compression`.
  stored_index:
    seq:
      - id: compression
        type: u1
        enum: compression
      - id: data
        size-eos: true
        type:
          switch-on: compression
          cases:
            'compression::none': fsindex
  fsindex:
    seq:
      - id: magic
        contents: CFS2.200
      - id: root
        type: directory
      - id: metadata
        type: metadata
        if: not _io.eof
  directory:
    seq:
      - id: num_entries
        type: u4
      - id: entries
        type: entry
        repeat: expr
        repeat-expr: num_entries
  entry:
    seq:
      - id: len_name
        type: u1
      - id: name
        size: len_name
        type: str
        encoding: UTF-8
      - id: name_terminator
        contents: [0]
      - id: mtime
        type: s8
        doc: Modification time, in seconds since the Unix epoch.
      - id: num_blocks
        type: s4
        doc: Number of block triplets, or -1 for a directory.
      - id: directory
        type: directory
        if: is_directory
      - id: blocks
        type: block
        repeat: expr
        repeat-expr: num_blocks
        if: not is_directory
    instances:
      is_directory:
        value: num_blocks == -1
  block:
    doc: A part of a file's contents.
    seq:
      - id: page
        type: s4
        doc: Index of the page holding this part.
      - id: offset
        type: s4
        doc: Offset in the uncompressed page.
      - id: size
        type: s4
  metadata:
    seq:
      - id: num_items
        type: u4
      - id: items
        type: metadata_item
        repeat: expr
        repeat-expr: num_items
  metadata_item:
    seq:
      - id: len_body
        type: u4
      - id: body
        size: len_body
        type: metadata_body
  metadata_body:
    seq:
      - id: name
        type: strz
        encoding: UTF-8
      - id: value
        size-eos: true
enums:
  compression:
    0: none
    1: zlib
    2: bzip2
    255: custom
