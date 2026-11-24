# Imported from https://gist.github.com/arbruijn/725931b526f605e5582580360db8d110
# Licence and copyright: see _community/README.md
meta:
  id: lx_le_exe
  title: LX_executable
  file-extension:
    - exe
    - vxd
  license: CC0-1.0
  endian: le
doc: |
  The LX/LE executable file format is used by OS/2, the DOS/4G DOS extender and
  Windows VxD drivers.
seq:
  - id: mz1
    type: mz_placeholder
  - id: mz2
    size: mz1.header_size - 0x40
  - id: lx_signature
    contents: ["LE", 0, 0]
  - id: lx_hdr
    type: lx_header
instances:
  object_table:
    pos: mz1.header_size + lx_hdr.object_table_offset
    type: object_table_entry
    repeat: expr
    repeat-expr: lx_hdr.object_table_count
  page_table:
    pos: mz1.header_size + lx_hdr.page_table_offset
    type: page_table_entry
    repeat: expr
    repeat-expr: lx_hdr.module_num_pages
  res_name_table:
    pos: mz1.header_size + lx_hdr.resident_name_tbl_offset
    type: res_name_entry
    repeat: expr
    repeat-expr: 1
  entry_table:
    pos: mz1.header_size + lx_hdr.entry_tbl_offset
    type: entry_table_entry
    repeat: expr
    repeat-expr: 1
  fixup_page_table:
    pos: mz1.header_size + lx_hdr.fixup_page_table_offset
    type: fixup_page_table_entry
    repeat: expr
    repeat-expr: lx_hdr.module_num_pages + 1
  fixup_record_table:
    pos: mz1.header_size + lx_hdr.fixup_record_table_offset
    type: fixup_record_table_entry
    repeat: expr
    repeat-expr: 100
types:
  fixup_record_table_entry:
    seq:
      - id: src_type
        type: u1
      - id: flags
        type: u1
      - id: srcofs
        type: u2
      - id: obj
        type: u1
      - id: dst16
        type: u2
        if: flags & 0x10 == 0
      - id: dst32
        type: u4
        if: flags & 0x10 != 0
  entry_table_entry:
    seq:
      - id: cnt
        type: u1
      - id: type
        type: u1
        if: cnt != 0
  fixup_page_table_entry:
    seq:
      - id: offset
        type: u4
  res_name_entry:
    seq:
      - id: len
        type: u1
      - id: ident
        size: len
        type: str
        encoding: UTF-8
      - id: ordinal
        type: u2
  object_table_entry:
    seq:
      - id: virtual_size
        type: u4
      - id: reloc_base_addr
        type: u4
      - id: flags
        type: u4
      - id: page_table_index
        type: u4
      - id: page_table_count
        type: u4
      - id: reserved
        type: u4
  page_table_entry_lx:
    seq:
      - id: offset
        type: u4
      - id: size
        type: u2
      - id: flags
        type: u2
  page_table_entry:
    seq:
      - id: flags
        type: u2
      - id: offset
        type: u2
  mz_placeholder:
    seq:
      - id: magic
        contents: "MZ"
      - id: data1
        size: 0x3a
      - id: header_size
        type: u4
  lx_pre_header:
    seq:
      - id: magic
        size: 2
      - id: byte_order
        type: u1
      - id: word_order
        type: u1
  lx_header:
    seq:
      - id: format_level
        type: u4
      - id: cpu_type
        type: u2
      - id: os_type
        type: u2
      - id: module_version
        type: u4
      - id: module_flags
        type: u4
      - id: module_num_pages
        type: u4
      - id: eip_object_num 
        type: u4
      - id: eip
        type: u4
      - id: esp_object_num
        type: u4
      - id: esp
        type: u4
      - id: page_size
        type: u4
      - id: last_page_size
        type: u4
      - id: fixup_section_size
        type: u4
      - id: fixup_section_checksum
        type: u4
      - id: loader_section_size
        type: u4
      - id: loader_section_checksum
        type: u4
      - id: object_table_offset
        type: u4
      - id: object_table_count
        type: u4
      - id: page_table_offset
        type: u4
      - id: object_iter_pages_offset
        type: u4
      - id: resource_table_offset
        type: u4
      - id: resource_table_count
        type: u4
      - id: resident_name_tbl_offset
        type: u4
      - id: entry_tbl_offset
        type: u4
      - id: module_directives_offset
        type: u4
      - id: module_directives_count
        type: u4
      - id: fixup_page_table_offset
        type: u4
      - id: fixup_record_table_offset
        type: u4
      - id: import_module_tbl_offset
        type: u4
      - id: import_module_tbl_count
        type: u4
      - id: import_proc_tbl_offset
        type: u4
      - id: per_page_checksum_offset
        type: u4
      - id: data_pages_offset
        type: u4
      - id: preload_pages_count
        type: u4
      - id: non_res_name_tbl_offset
        type: u4
      - id: non_res_name_tbl_length
        type: u4
      - id: non_res_name_tbl_checksum
        type: u4
      - id: auto_ds_object_num
        type: u4
      - id: debug_info_offset
        type: u4
      - id: debug_info_length
        type: u4
      - id: num_instance_preload 
        type: u4
      - id: num_instance_demand
        type: u4
      - id: heapsize
        type: u4
