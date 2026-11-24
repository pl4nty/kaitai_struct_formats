meta:
  id: labview_vi
  title: NI LabVIEW resource file (VI, CTL, LLB, ...)
  application: NI LabVIEW
  file-extension:
    - vi
    - ctl
    - vit
    - ctt
    - llb
    - lvlib
    - lvclass
    - xctl
    - mnu
    - uir
    - rsc
  license: CC0-1.0
  ks-version: '0.11'
  encoding: ASCII
  endian: be
doc: |
  Resource container ("RSRC") format used by National Instruments LabVIEW for
  virtual instruments (.vi), controls (.ctl), libraries (.llb) and several
  other file types, which are told apart by `header.file_type`.

  The file starts with a 32-byte RSRC header pointing to the data part and the
  info part. The info part starts with a copy of the header, followed by a
  block info list header and the block info: a list of blocks (resources)
  identified by a FourCC (`LVSR`, `vers`, `BDPW`, `VCTP`, `FPHb`, `BDHb`, `icl8`,
  ...), each with one or more sections. Each section points into the data
  part, where its raw data is stored as a 32-bit size followed by the data
  (padded to 4 bytes). Many blocks (e.g. front panel and block diagram heaps)
  are zlib-compressed with a 32-bit uncompressed size prefix; block contents
  are not parsed here.

  Some sections have names, stored as Pascal strings after the list of section
  starts.
doc-ref:
  - https://github.com/mefistotelis/pylabview/blob/5f20e23de6a386021eb955c825cc43d221f09ff1/pylabview/LVrsrcontainer.py
  - https://github.com/mefistotelis/pylabview/blob/5f20e23de6a386021eb955c825cc43d221f09ff1/pylabview/LVblock.py
  - https://github.com/tomsoftware/VI-Explorer/blob/458e6fa1513400882b60d809fd7a8664a6c47f51/php/cllabview.php
seq:
  - id: header
    type: rsrc_header
instances:
  info:
    pos: header.ofs_info
    size: header.len_info
    type: info
  data:
    pos: header.ofs_data
    size: header.len_data
types:
  rsrc_header:
    seq:
      - id: magic
        size: 6
        valid:
          any-of:
            - '[0x52, 0x53, 0x52, 0x43, 0x0d, 0x0a]'
            - '[0x52, 0x53, 0x52, 0x43, 0x00, 0x00]'
        doc: '"RSRC\r\n"; "RSRC\0\0" in format versions <= 2.'
      - id: format_version
        type: u2
      - id: file_type
        size: 4
        type: str
        doc: |
          `LVIN` (VI), `LVCC` (control), `sVIN` (VI template), `sVCC` (control
          template), `LVAR` (LLB), `LIBR` (lvlib), `LIBP` (lvlibp), `CLIB`
          (lvclass), `LVPJ` (lvproj), `LVXC` (xctl), `LMNU` (menu/palette),
          `LVDL` (datalog), `iUWl` (uir), `LVSB` (subroutine), `LVRS`, `rsc `,
          `RSRC`.
      - id: creator
        size: 4
        type: str
        doc: '`LBVW`; `ResC` or `Doug` for old resource files.'
      - id: ofs_info
        type: u4
        doc: Offset of the info part (which starts with a copy of this header).
      - id: len_info
        type: u4
      - id: ofs_data
        type: u4
        doc: Offset of the data part.
      - id: len_data
        type: u4
  info:
    seq:
      - id: header_copy
        type: rsrc_header
      - id: block_info_list_header
        type: block_info_list_header
    instances:
      block_info:
        pos: block_info_list_header.ofs_block_info
        size: block_info_list_header.ofs_section_names - block_info_list_header.ofs_block_info
        type: block_info
  block_info_list_header:
    seq:
      - id: dataset_int1
        type: u4
      - id: dataset_int2
        type: u4
      - id: dataset_int3
        type: u4
        doc: Always 32 (the size of the RSRC header).
      - id: ofs_block_info
        type: u4
        doc: Offset of the block info, relative to the info part; normally 52.
      - id: ofs_section_names
        -orig-id: blockinfo_size
        type: u4
        doc: |
          End of the block info (block headers and section starts), i.e. the
          offset of the section names list, relative to the info part.
  block_info:
    seq:
      - id: num_blocks_minus_one
        type: u4
      - id: blocks
        type: block_header
        repeat: expr
        repeat-expr: num_blocks_minus_one + 1
  block_header:
    seq:
      - id: ident
        size: 4
        type: str
        doc: Block type (FourCC).
      - id: num_sections_minus_one
        type: u4
      - id: ofs_sections
        type: u4
        doc: Offset of the section starts, relative to the block info.
    instances:
      sections:
        pos: ofs_sections
        type: section_start
        repeat: expr
        repeat-expr: num_sections_minus_one + 1
  section_start:
    seq:
      - id: section_idx
        type: s4
      - id: ofs_name
        type: u4
        doc: Offset of the section name in the section names list, 0xFFFFFFFF if none.
      - id: int3
        type: u4
      - id: ofs_data
        type: u4
        doc: Offset of the section data, relative to the data part.
      - id: int5
        type: u4
    instances:
      has_name:
        value: ofs_name != 0xffff_ffff
      name:
        io: _root.info._io
        pos: _root.info.block_info_list_header.ofs_section_names + ofs_name
        type: pascal_string
        if: has_name
      data:
        io: _root._io
        pos: _root.header.ofs_data + ofs_data
        type: section_data
  section_data:
    seq:
      - id: len_data
        type: u4
      - id: data
        size: len_data
  pascal_string:
    seq:
      - id: len_value
        type: u1
      - id: value
        size: len_value
        type: str
