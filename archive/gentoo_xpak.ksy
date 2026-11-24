meta:
  id: gentoo_xpak
  title: Gentoo XPAK binary package metadata
  application: Portage
  file-extension:
    - xpak
    - tbz2
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  XPAK is the metadata container of Gentoo Portage binary packages
  (the original "tbz2" binpkg format, superseded by GPKG). It holds
  named entries recording how the package was built: CATEGORY, PF,
  USE, CFLAGS, the ebuild, the bzip2-compressed environment, etc.

  An XPAK block is "XPAKPACK", the index length, the data length, an
  index of `(name_len, name, data_offset, data_len)` records, the data
  block, and "XPAKSTOP". In a tbz2 binary package the XPAK block is
  appended to a bzip2-compressed tarball and followed by a big-endian
  u4 holding the size of the XPAK block and the string "STOP".

  This spec accepts both a standalone XPAK (as written by
  `portage.xpak.xpak_mem`) and a tbz2 binary package; for the latter
  the tarball is exposed as `tarball` but not parsed.
doc-ref:
  - https://www.mankier.com/5/xpak
  - https://github.com/gentoo/portage/blob/bdf046b03a28a74541c3c31c02244376f85d0790/lib/portage/xpak.py
instances:
  is_standalone:
    value: magic_head == "XPAKPACK"
  magic_head:
    pos: 0
    size: 8
    type: str
    encoding: ASCII
  tbz2_trailer:
    pos: _io.size - 8
    type: tbz2_trailer
    if: not is_standalone
  len_tarball:
    value: 'is_standalone ? 0 : _io.size - 8 - tbz2_trailer.len_xpak'
  xpak:
    pos: len_tarball
    type: xpak
  tarball:
    pos: 0
    size: len_tarball
    if: not is_standalone
    doc: bzip2-compressed tar archive with the package files.
types:
  tbz2_trailer:
    seq:
      - id: len_xpak
        -orig-id: xpak_offset
        type: u4
        doc: Size of the XPAK block, from "XPAKPACK" to "XPAKSTOP" inclusive.
      - id: magic
        contents: STOP
  xpak:
    seq:
      - id: magic_start
        contents: XPAKPACK
      - id: len_index
        -orig-id: index_len
        type: u4
      - id: len_data
        -orig-id: data_len
        type: u4
      - id: index
        size: len_index
        type: index
      - id: data
        size: len_data
        type: data_block
      - id: magic_end
        contents: XPAKSTOP
  index:
    seq:
      - id: entries
        type: index_entry
        repeat: eos
  index_entry:
    seq:
      - id: len_name
        -orig-id: name_len
        type: u4
      - id: name
        size: len_name
        type: str
        encoding: ASCII
      - id: ofs_value
        -orig-id: dataN_offset
        type: u4
        doc: Offset of the value from the start of the data block.
      - id: len_value
        -orig-id: dataN_len
        type: u4
    instances:
      value:
        io: _parent._parent.data._io
        pos: ofs_value
        size: len_value
        doc: |
          Contents of the entry; usually ASCII text with a trailing
          newline, but e.g. `environment.bz2` is bzip2-compressed.
  data_block:
    seq:
      - id: body
        size-eos: true
