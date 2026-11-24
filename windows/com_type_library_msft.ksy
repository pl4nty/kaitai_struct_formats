meta:
  id: com_type_library_msft
  title: COM type library (MSFT format)
  application:
    - Microsoft MIDL
    - OLE Automation (oleaut32)
  file-extension:
    - tlb
    - olb
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Binary COM / OLE Automation type library in the "MSFT" format, as
  written by MIDL and `ICreateTypeLib2` (stand-alone `.tlb` / `.olb` files,
  or the `TYPELIB` resource of a DLL or EXE). The older "SLTG" format is not
  covered.

  The file starts with an 0x54-byte header, optionally followed by the
  string table offset of the help string DLL, then one offset per type
  info (relative to the start of the type info table) and the segment
  directory of 15 segments. Each segment has an absolute offset (-1 if
  absent) and a length.

  This spec decodes the header, the segment directory, the type info
  table, the imported type info and imported library tables, the GUID
  table, the name table and the string table. Other segments (hash
  tables, reference table, type descriptors, array descriptors, custom
  data) and the per-type-info function / variable records referenced by
  `ofs_members` are exposed as raw bytes or offsets only.

  There is no official specification; the layout follows the Wine
  implementation of oleaut32.
doc-ref:
  - https://github.com/wine-mirror/wine/blob/ff2631c6ed3d1721cd050d951671c307ade32b90/dlls/oleaut32/typelib.h
  - https://github.com/wine-mirror/wine/blob/ff2631c6ed3d1721cd050d951671c307ade32b90/dlls/oleaut32/typelib.c
seq:
  - id: header
    type: header
  - id: ofs_help_string_dll
    type: s4
    if: header.has_help_dll
    doc: Offset in the string table of the help string DLL name.
  - id: ofs_type_infos
    type: s4
    repeat: expr
    repeat-expr: header.num_type_infos
    doc: Offset of each type info's data, relative to the start of the type info table.
  - id: segment_directory
    type: segment_directory
types:
  header:
    seq:
      - id: magic
        contents: MSFT
      - id: format_version
        type: u4
        doc: Normally 0x00010002.
      - id: ofs_guid
        type: s4
        doc: Offset of the library's GUID (LIBID) in the GUID table, or -1.
      - id: lcid
        type: u4
        doc: Locale ID of the library.
      - id: lcid2
        type: u4
      - id: var_flags
        type: u4
        doc: Bits 0-3 are the SYSKIND; bit 8 is set if a help string DLL is defined.
      - id: version_major
        type: u2
      - id: version_minor
        type: u2
      - id: lib_flags
        type: u4
        doc: LIBFLAGS (restricted, control, hidden, ...).
      - id: num_type_infos
        type: s4
      - id: ofs_help_string
        type: s4
        doc: Offset of the doc string in the string table, or -1.
      - id: help_string_context
        type: u4
      - id: help_context
        type: u4
      - id: num_names
        type: s4
        doc: Number of names in the name table.
      - id: num_name_chars
        type: s4
        doc: Number of characters in the name table.
      - id: ofs_name
        type: s4
        doc: Offset of the library name in the name table.
      - id: ofs_help_file
        type: s4
        doc: Offset of the help file name in the string table, or -1.
      - id: ofs_custom_data
        type: s4
        doc: Offset in the custom data GUID table, or -1 if there is no custom data.
      - id: reserved1
        type: u4
        doc: Normally 0x20 (GUID hash size?).
      - id: reserved2
        type: u4
        doc: Normally 0x80 (name hash size?).
      - id: dispatch_href
        type: s4
        doc: HREFTYPE of IDispatch, or -1 if there is no IDispatch.
      - id: num_imp_infos
        type: s4
        doc: Number of entries in the imported type info table.
    instances:
      syskind:
        value: var_flags & 0xf
        enum: syskind
      has_help_dll:
        value: var_flags & 0x100 != 0
  segment_directory:
    seq:
      - id: type_info_table
        type: segment(0)
        doc: One 0x64-byte entry per type info.
      - id: imp_info_table
        type: segment(1)
        doc: Information on imported type infos.
      - id: imp_files_table
        type: segment(2)
        doc: Imported type libraries.
      - id: ref_table
        type: segment(3)
        doc: Reference records (implemented interfaces).
      - id: guid_hash_table
        type: segment(4)
      - id: guid_table
        type: segment(5)
      - id: name_hash_table
        type: segment(6)
      - id: name_table
        type: segment(7)
      - id: string_table
        type: segment(8)
      - id: type_desc_table
        type: segment(9)
      - id: array_desc_table
        type: segment(10)
      - id: custom_data
        type: segment(11)
        doc: Custom data and default parameter values.
      - id: custom_data_guids
        type: segment(12)
        doc: GUIDs and offsets into the custom data table.
      - id: reserved_segment1
        type: segment(13)
      - id: reserved_segment2
        type: segment(14)
  segment:
    params:
      - id: index
        type: u1
    seq:
      - id: ofs_body
        type: s4
        doc: Absolute file offset of the segment, or -1 if absent.
      - id: len_body
        type: s4
      - id: reserved1
        type: s4
        doc: Normally -1.
      - id: reserved2
        type: s4
        doc: 0x0f in the segment directory (checked by readers for the first two entries).
    instances:
      is_present:
        value: ofs_body >= 0
      body:
        io: _root._io
        pos: ofs_body
        size: len_body
        type:
          switch-on: index
          cases:
            0: type_info_table
            1: imp_info_table
            2: imp_files_table
            5: guid_table
            7: name_table
            8: string_table
        if: is_present and len_body > 0
  type_info_table:
    seq:
      - id: entries
        type: type_info
        repeat: eos
  type_info:
    seq:
      - id: type_kind_raw
        type: u4
        doc: TYPEKIND in bits 0-3, alignment information in higher bits.
      - id: ofs_members
        type: s4
        doc: |
          Offset of this type info's function and variable records, relative
          to the type info table (points past the file if there are none).
      - id: reserved1
        type: s4
      - id: reserved2
        type: s4
      - id: reserved3
        type: s4
      - id: reserved4
        type: s4
      - id: num_funcs
        type: u2
      - id: num_vars
        type: u2
      - id: reserved5
        type: s4
      - id: reserved6
        type: s4
      - id: reserved7
        type: s4
      - id: reserved8
        type: s4
      - id: ofs_guid
        type: s4
        doc: Offset of the type's GUID in the GUID table, or -1.
      - id: type_flags
        type: u4
        doc: TYPEFLAGS.
      - id: ofs_name
        type: s4
        doc: Offset of the type name in the name table.
      - id: version
        type: u4
      - id: ofs_doc_string
        type: s4
        doc: Offset of the doc string in the string table, or -1.
      - id: help_string_context
        type: u4
      - id: help_context
        type: u4
      - id: ofs_custom_data
        type: s4
      - id: num_impl_types
        type: s2
        doc: Number of implemented interfaces.
      - id: len_vtable
        type: s2
        doc: Virtual function table size, including inherited functions.
      - id: len_instance
        type: s4
        doc: Size of an instance of the type.
      - id: data_type1
        type: s4
        doc: |
          For an alias, the type descriptor; for a dispinterface or coclass,
          a reference; for an interface, the reference to the base interface.
      - id: data_type2
        type: s4
        doc: |
          For interfaces, number of inherited functions (high word) and interfaces (low
          word).
      - id: reserved9
        type: s4
      - id: reserved10
        type: s4
    instances:
      type_kind:
        value: type_kind_raw & 0xf
        enum: type_kind
  imp_info_table:
    seq:
      - id: entries
        type: imp_info
        repeat: eos
  imp_info:
    seq:
      - id: flags
        type: u4
        doc: |
          Bits 0-15: count; bit 16: `ofs_guid_or_index` is a GUID table
          offset (otherwise a type info index in the imported library);
          bits 24-31: TYPEKIND of the reference.
      - id: ofs_imp_file
        type: s4
        doc: Offset in the imported libraries table.
      - id: ofs_guid_or_index
        type: s4
    instances:
      is_guid_offset:
        value: flags & 0x10000 != 0
  imp_files_table:
    seq:
      - id: entries
        type: imp_file
        repeat: eos
  imp_file:
    seq:
      - id: ofs_guid
        type: s4
        doc: Offset of the imported library's GUID in the GUID table.
      - id: lcid
        type: u4
      - id: version_major
        type: u2
      - id: version_minor
        type: u2
      - id: len_name_shifted
        type: u2
        doc: Length of the name, shifted left by 2.
      - id: name
        size: len_name_shifted >> 2
        type: str
        encoding: windows-1252
        doc: File name of the imported library (in the system code page).
      - id: padding
        size: (-(14 + (len_name_shifted >> 2))) % 4
  guid_table:
    seq:
      - id: entries
        type: guid_entry
        repeat: eos
  guid_entry:
    seq:
      - id: guid
        size: 16
        doc: GUID in the usual mixed-endian Windows layout.
      - id: href_type
        type: s4
        doc: |
          -2 for the library GUID, otherwise a type info offset; the low two
          bits are 01 for an imported type info and 10 for an imported library.
      - id: ofs_next_hash
        type: s4
        doc: Offset of the next GUID in the same hash bucket, or -1.
  name_table:
    seq:
      - id: entries
        type: name_entry
        repeat: eos
  name_entry:
    seq:
      - id: href_type
        type: s4
        doc: |
          -1 for library and parameter names; otherwise the offset of the
          first type info this name refers to.
      - id: ofs_next_hash
        type: s4
        doc: Offset of the next name in the same hash bucket, or -1.
      - id: len_name
        type: u1
      - id: name_flags
        type: u1
        doc: |
          0x10: used once as a variable name, 0x20: enumeration member,
          0x38: type info name.
      - id: name_hash
        type: u2
        doc: Hash of the name (as computed by LHashValOfNameSys).
      - id: name
        size: len_name
        type: str
        encoding: windows-1252
        doc: Name in the system code page.
      - id: padding
        size: (-len_name) % 4
  string_table:
    seq:
      - id: entries
        type: string_entry
        repeat: eos
  string_entry:
    seq:
      - id: len_value
        type: u2
      - id: value
        size: len_value
        type: str
        encoding: windows-1252
        doc: String in the system code page.
      - id: padding
        size: 'len_value < 6 ? 6 - len_value : (-(2 + len_value)) % 4'
        doc: Entries are padded to a multiple of 4 bytes, and are at least 8 bytes long.
enums:
  syskind:
    0: win16
    1: win32
    2: mac
    3: win64
  type_kind:
    0: enum
    1: record
    2: module
    3: interface
    4: dispatch
    5: coclass
    6: alias
    7: union
