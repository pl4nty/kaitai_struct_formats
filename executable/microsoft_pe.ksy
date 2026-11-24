meta:
  id: microsoft_pe
  title: Microsoft PE (Portable Executable) file format
  application: Microsoft Windows
  file-extension:
    - exe
    - dll
    - sys
  xref:
    justsolve: Portable_Executable
    pronom: x-fmt/411
    wikidata: Q1076355
  tags:
    - executable
    - windows
  license: CC0-1.0
  ks-version: 0.9
  endian: le
  bit-endian: le
doc-ref: https://learn.microsoft.com/en-us/windows/win32/debug/pe-format
seq:
  - id: mz
    type: mz_placeholder
instances:
  pe:
    pos: mz.ofs_pe
    type: pe_header
enums:
  pe_format:
    0x107: rom_image
    0x10b: pe32
    0x20b: pe32_plus
types:
  mz_placeholder:
    seq:
      - id: magic
        contents: "MZ"
      - id: data1
        size: 0x3a
      - id: ofs_pe
        type: u4
        doc: In PE file, an offset to PE header
  pe_header:
    seq:
      - id: pe_signature
        contents: ["PE", 0, 0]
      - id: coff_hdr
        type: coff_header
      - id: optional_hdr
        size: coff_hdr.size_of_optional_header
        type: optional_header
      - id: sections
        type: section
        repeat: expr
        repeat-expr: coff_hdr.number_of_sections
    instances:
      certificate_table:
        pos: optional_hdr.data_dirs.certificate_table.virtual_address
        size: optional_hdr.data_dirs.certificate_table.size
        type: certificate_table
        if: optional_hdr.data_dirs.certificate_table.virtual_address != 0
      debug_table:
        pos: optional_hdr.data_dirs.debug.virtual_address - (sections[1].virtual_address - sections[1].pointer_to_raw_data)
        size: optional_hdr.data_dirs.debug.size
        type: debug_table_entries
        if: optional_hdr.data_dirs.debug.virtual_address != 0
      resources_table:
        pos: optional_hdr.data_dirs.resource_table.pointer_to_raw_data
        size: optional_hdr.data_dirs.resource_table.size
        type: resource_directory_table(0, optional_hdr.data_dirs.resource_table.pointer_to_raw_data, optional_hdr.data_dirs.resource_table.virtual_address)
        if: optional_hdr.data_dirs.resource_table.size > 0
      dotnet_header:
        pos: optional_hdr.data_dirs.clr_runtime_header.pointer_to_raw_data
        size: optional_hdr.data_dirs.clr_runtime_header.size
        type: dotnet_header
        if: optional_hdr.data_dirs.clr_runtime_header.virtual_address != 0
      dotnet_metadata_header:
        pos: dotnet_header.meta_data.pointer_to_raw_data
        size: dotnet_header.meta_data.size
        type: dotnet_metadata_header
        if: optional_hdr.data_dirs.clr_runtime_header.virtual_address != 0 and dotnet_header.meta_data.size != 0
  coff_header:
    doc-ref: 3.3. COFF File Header (Object and Image)
    seq:
      - id: machine
        type: u2
        enum: machine_type
      - id: number_of_sections
        type: u2
      - id: time_date_stamp
        type: u4
      - id: pointer_to_symbol_table
        type: u4
      - id: number_of_symbols
        type: u4
      - id: size_of_optional_header
        type: u2
      - id: characteristics
        type: u2
    instances:
      symbol_table_size:
        value: number_of_symbols * 18
      symbol_name_table_offset:
        value: pointer_to_symbol_table + symbol_table_size
      symbol_name_table_size:
        pos: symbol_name_table_offset
        type: u4
      symbol_table:
        pos: pointer_to_symbol_table
        type: coff_symbol
        repeat: until
        repeat-until: _io.pos >= symbol_name_table_offset
        if: number_of_symbols > 0
        doc: |
          COFF symbol records. `number_of_symbols` counts the 18-byte
          auxiliary records too, which are read as part of the symbol they
          follow (see `coff_symbol.aux_symbols`).
    enums:
      # Don't forget to update the `machine_type` enum in `executable/uefi_te.ksy` when
      # you modify this one.
      #
      # https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#machine-types
      machine_type:
        0x0:
          id: unknown
          doc: The content of this field is assumed to be applicable to any machine type
        0x184:
          id: alpha
          doc: Alpha AXP, 32-bit address space
        0x284:
          id: alpha64_or_axp64
          -orig-id:
            - IMAGE_FILE_MACHINE_ALPHA64
            - IMAGE_FILE_MACHINE_AXP64
          doc: |
            > Alpha 64, 64-bit address space
            or
            > AXP 64 (Same as Alpha 64)
        0x1d3:
          id: am33
          doc: Matsushita AM33
        0x8664:
          id: amd64
          doc: x64
        0x1c0:
          id: arm
          doc: ARM little endian
        0xaa64:
          id: arm64
          doc: ARM64 little endian
        0x1c4:
          id: arm_nt
          -orig-id: IMAGE_FILE_MACHINE_ARMNT
          doc: ARM Thumb-2 little endian
        0xebc:
          id: ebc
          doc: EFI byte code
        0x14c:
          id: i386
          doc: Intel 386 or later processors and compatible processors
        0x200:
          id: ia64
          doc: Intel Itanium processor family
        0x6232:
          id: loongarch32
          doc: LoongArch 32-bit processor family
        0x6264:
          id: loongarch64
          doc: LoongArch 64-bit processor family
        0x9041:
          id: m32r
          doc: Mitsubishi M32R little endian
        0x266:
          id: mips16
          doc: MIPS16
        0x366:
          id: mips_fpu
          -orig-id: IMAGE_FILE_MACHINE_MIPSFPU
          doc: MIPS with FPU
        0x466:
          id: mips16_fpu
          -orig-id: IMAGE_FILE_MACHINE_MIPSFPU16
          doc: MIPS16 with FPU
        0x1f0:
          id: powerpc
          doc: Power PC little endian
        0x1f1:
          id: powerpc_fp
          -orig-id: IMAGE_FILE_MACHINE_POWERPCFP
          doc: Power PC with floating point support
        0x166:
          id: r4000
          doc: MIPS little endian
        0x5032:
          id: riscv32
          doc: RISC-V 32-bit address space
        0x5064:
          id: riscv64
          doc: RISC-V 64-bit address space
        0x5128:
          id: riscv128
          doc: RISC-V 128-bit address space
        0x1a2:
          id: sh3
          doc: Hitachi SH3
        0x1a3:
          id: sh3_dsp
          -orig-id: IMAGE_FILE_MACHINE_SH3DSP
          doc: Hitachi SH3 DSP
        0x1a6:
          id: sh4
          doc: Hitachi SH4
        0x1a8:
          id: sh5
          doc: Hitachi SH5
        0x1c2:
          id: thumb
          doc: Thumb
        0x169:
          id: wce_mips_v2
          -orig-id: IMAGE_FILE_MACHINE_WCEMIPSV2
          doc: MIPS little-endian WCE v2
  coff_symbol:
    seq:
      - id: name_annoying
        size: 8
        type: annoyingstring
      #- id: name_zeroes
      #  type: u4
      #- id: name_offset
      #  type: u4
      - id: value
        type: u4
      - id: section_number
        type: u2
      - id: type
        type: u2
      - id: storage_class
        type: u1
      - id: number_of_aux_symbols
        type: u1
      - id: aux_symbols
        size: 18
        repeat: expr
        repeat-expr: number_of_aux_symbols
        doc: Auxiliary symbol records; their layout depends on `storage_class`.
    instances:
      #effective_name:
      #  value: name_zeroes == 0 ? name_from_offset : '"fixme"'
      #name_from_offset:
      #  io: _root._io
      #  pos: name_zeroes == 0 ? _parent.symbol_name_table_offset + name_offset : 0
      #  type: str
      #  terminator: 0
      #  encoding: ascii
      section:
        value: _root.pe.sections[section_number - 1]
        if: has_section
        doc: |
          Section the symbol is defined in. Absent for the special section
          numbers 0 (IMAGE_SYM_UNDEFINED), 0xffff (IMAGE_SYM_ABSOLUTE) and
          0xfffe (IMAGE_SYM_DEBUG), and for out-of-range numbers.
      has_section:
        value: section_number > 0 and section_number <= _root.pe.coff_hdr.number_of_sections
      data:
        pos: section.pointer_to_raw_data + value
        size: 1
        if: has_section
  annoyingstring:
    -webide-representation: '{name}'
    instances:
      name_zeroes:
        pos: 0
        type: u4
      name_offset:
        pos: 4
        type: u4
      name_from_offset:
        io: _root._io
        pos: 'name_zeroes == 0 ? _parent._parent.symbol_name_table_offset + name_offset : 0'
        type: str
        terminator: 0
        eos-error: false
        encoding: ASCII
        if: name_zeroes == 0
      name_from_short:
        pos: 0
        type: str
        terminator: 0
        eos-error: false
        encoding: ASCII
        if: name_zeroes != 0
      name:
        value: 'name_zeroes == 0 ? name_from_offset : name_from_short'
  optional_header:
    seq:
      - id: std
        type: optional_header_std
      - id: windows
        type: optional_header_windows
      - id: data_dirs
        type: optional_header_data_dirs
  optional_header_std:
    seq:
      - id: format
        type: u2
        enum: pe_format
      - id: major_linker_version
        type: u1
      - id: minor_linker_version
        type: u1
      - id: size_of_code
        type: u4
      - id: size_of_initialized_data
        type: u4
      - id: size_of_uninitialized_data
        type: u4
      - id: address_of_entry_point
        type: u4
      - id: base_of_code
        type: u4
      - id: base_of_data
        type: u4
        if: format == pe_format::pe32
  optional_header_windows:
    seq:
      - id: image_base_32
        type: u4
        if: _parent.std.format == pe_format::pe32
      - id: image_base_64
        type: u8
        if: _parent.std.format == pe_format::pe32_plus
      - id: section_alignment
        type: u4
      - id: file_alignment
        type: u4
      - id: major_operating_system_version
        type: u2
      - id: minor_operating_system_version
        type: u2
      - id: major_image_version
        type: u2
      - id: minor_image_version
        type: u2
      - id: major_subsystem_version
        type: u2
      - id: minor_subsystem_version
        type: u2
      - id: win32_version_value
        type: u4
      - id: size_of_image
        type: u4
      - id: size_of_headers
        type: u4
      - id: check_sum
        type: u4
      - id: subsystem
        type: u2
        enum: subsystem_enum
      - id: dll_characteristics
        type: u2
      - id: size_of_stack_reserve_32
        type: u4
        if: _parent.std.format == pe_format::pe32
      - id: size_of_stack_reserve_64
        type: u8
        if: _parent.std.format == pe_format::pe32_plus
      - id: size_of_stack_commit_32
        type: u4
        if: _parent.std.format == pe_format::pe32
      - id: size_of_stack_commit_64
        type: u8
        if: _parent.std.format == pe_format::pe32_plus
      - id: size_of_heap_reserve_32
        type: u4
        if: _parent.std.format == pe_format::pe32
      - id: size_of_heap_reserve_64
        type: u8
        if: _parent.std.format == pe_format::pe32_plus
      - id: size_of_heap_commit_32
        type: u4
        if: _parent.std.format == pe_format::pe32
      - id: size_of_heap_commit_64
        type: u8
        if: _parent.std.format == pe_format::pe32_plus
      - id: loader_flags
        type: u4
      - id: number_of_rva_and_sizes
        type: u4
    enums:
      subsystem_enum:
        0: unknown
        1: native
        2: windows_gui
        3: windows_cui
        7: posix_cui
        9: windows_ce_gui
        10: efi_application
        11: efi_boot_service_driver
        12: efi_runtime_driver
        13: efi_rom
        14: xbox
        16: windows_boot_application
  optional_header_data_dirs:
    seq:
      - id: export_table
        type: data_dir
      - id: import_table
        type: data_dir
      - id: resource_table
        type: data_dir
      - id: exception_table
        type: data_dir
      - id: certificate_table
        type: data_dir
      - id: base_relocation_table
        type: data_dir
      - id: debug
        type: data_dir
      - id: architecture
        type: data_dir
      - id: global_ptr
        type: data_dir
      - id: tls_table
        type: data_dir
      - id: load_config_table
        type: data_dir
      - id: bound_import
        type: data_dir
      - id: iat
        type: data_dir
      - id: delay_import_descriptor
        type: data_dir
      - id: clr_runtime_header
        type: data_dir
  data_dir:
    to-string: |
      'Data Directory <VirtualAddr: ' + virtual_address.to_s + ', Size: ' + size.to_s + ', PointerToRawData: ' + pointer_to_raw_data.to_s + '>'
    seq:
      - id: virtual_address
        type: u4
      - id: size
        type: u4
    instances:
      sections_lookup:
        type: sections_lookup(virtual_address)
      pointer_to_raw_data:
        value: >
          (sections_lookup.has_section ?
          (sections_lookup.section.pointer_to_raw_data + (virtual_address - sections_lookup.section.virtual_address)) :
          0)
  section:
    -webide-representation: "{name}"
    to-string: |
      'Section <Name: ' + name + ', VirtualSize: ' + virtual_size.to_s + ', VirtualAddr: ' + virtual_address.to_s + ', PointerToRawData: ' + pointer_to_raw_data.to_s + '>'
    seq:
      - id: name
        size: 8
        type: str
        pad-right: 0
        encoding: UTF-8
      - id: virtual_size
        type: u4
      - id: virtual_address
        type: u4
      - id: size_of_raw_data
        type: u4
      - id: pointer_to_raw_data
        type: u4
      - id: pointer_to_relocations
        type: u4
      - id: pointer_to_linenumbers
        type: u4
      - id: number_of_relocations
        type: u2
      - id: number_of_linenumbers
        type: u2
      - id: characteristics
        type: u4
        doc: Bit flags; see the `section_flags` enum for the individual flag values.
    instances:
      body:
        pos: pointer_to_raw_data
        size: size_of_raw_data
    enums:
      section_flags:
        0x00000000:
          id: reserved1
          -orig-id: Reserved1
          doc: Reserved for future use.
        0x00000001:
          id: reserved2
          -orig-id: Reserved2
          doc: Reserved for future use.
        0x00000002:
          id: reserved3
          -orig-id: Reserved3
          doc: Reserved for future use.
        0x00000004:
          id: reserved4
          -orig-id: Reserved4
          doc: Reserved for future use.
        0x00000008:
          id: image_scn_type_no_pad
          -orig-id: IMAGE_SCN_TYPE_NO_PAD
          doc: |
            The section should not be padded to the next boundary. This flag
            is obsolete and is replaced by IMAGE_SCN_ALIGN_1BYTES. This is
            valid only for object files.
        0x00000010:
          id: reserved5
          -orig-id: Reserved5
          doc: Reserved for future use.
        0x00000020:
          id: image_scn_cnt_code
          -orig-id: IMAGE_SCN_CNT_CODE
          doc: The section contains executable code.
        0x00000040:
          id: image_scn_cnt_initialized_data
          -orig-id: IMAGE_SCN_CNT_INITIALIZED_DATA
          doc: The section contains initialized data.
        0x00000080:
          id: image_scn_cnt_uninitialized_data
          -orig-id: IMAGE_SCN_CNT_UNINITIALIZED_DATA
          doc: The section contains uninitialized data.
        0x00000100:
          id: image_scn_lnk_other
          -orig-id: IMAGE_SCN_LNK_OTHER
          doc: Reserved for future use.
        0x00000200:
          id: image_scn_lnk_info
          -orig-id: IMAGE_SCN_LNK_INFO
          doc: |
            The section contains comments or other information. The .drectve
            section has this type. This is valid for object files only.
        0x00000400:
          id: reserved6
          -orig-id: Reserved6
          doc: Reserved for future use.
        0x00000800:
          id: image_scn_lnk_remove
          -orig-id: IMAGE_SCN_LNK_REMOVE
          doc: |
            The section will not become part of the image. This is valid only
            for object files.
        0x00001000:
          id: image_scn_lnk_comdat
          -orig-id: IMAGE_SCN_LNK_COMDAT
          doc: |
            The section contains COMDAT data. For more information see COMDAT
            Sections (Object Only). This is valid only for object files.
        0x00008000:
          id: image_scn_gprel
          -orig-id: IMAGE_SCN_GPREL
          doc: |
            The section contains data referenced through the global pointer
            (GP).
        0x00020000:
          id: image_scn_mem_purgeable
          -orig-id: IMAGE_SCN_MEM_PURGEABLE
          doc: Reserved for future use. Also defined as IMAGE_SCN_MEM_16BIT.
        0x00040000:
          id: image_scn_mem_locked
          -orig-id: IMAGE_SCN_MEM_LOCKED
          doc: Reserved for future use.
        0x00080000:
          id: image_scn_mem_preload
          -orig-id: IMAGE_SCN_MEM_PRELOAD
          doc: Reserved for future use.
        0x00100000:
          id: image_scn_align_1bytes
          -orig-id: IMAGE_SCN_ALIGN_1BYTES
          doc: Align data on a 1-byte boundary. Valid only for object files.
        0x00200000:
          id: image_scn_align_2bytes
          -orig-id: IMAGE_SCN_ALIGN_2BYTES
          doc: Align data on a 2-byte boundary. Valid only for object files.
        0x00300000:
          id: image_scn_align_4bytes
          -orig-id: IMAGE_SCN_ALIGN_4BYTES
          doc: Align data on a 4-byte boundary. Valid only for object files.
        0x00400000:
          id: image_scn_align_8bytes
          -orig-id: IMAGE_SCN_ALIGN_8BYTES
          doc: Align data on an 8-byte boundary. Valid only for object files.
        0x00500000:
          id: image_scn_align_16bytes
          -orig-id: IMAGE_SCN_ALIGN_16BYTES
          doc: Align data on a 16-byte boundary. Valid only for object files.
        0x00600000:
          id: image_scn_align_32bytes
          -orig-id: IMAGE_SCN_ALIGN_32BYTES
          doc: Align data on a 32-byte boundary. Valid only for object files.
        0x00700000:
          id: image_scn_align_64bytes
          -orig-id: IMAGE_SCN_ALIGN_64BYTES
          doc: Align data on a 64-byte boundary. Valid only for object files.
        0x00800000:
          id: image_scn_align_128bytes
          -orig-id: IMAGE_SCN_ALIGN_128BYTES
          doc: Align data on a 128-byte boundary. Valid only for object files.
        0x00900000:
          id: image_scn_align_256bytes
          -orig-id: IMAGE_SCN_ALIGN_256BYTES
          doc: Align data on a 256-byte boundary. Valid only for object files.
        0x00A00000:
          id: image_scn_align_512bytes
          -orig-id: IMAGE_SCN_ALIGN_512BYTES
          doc: Align data on a 512-byte boundary. Valid only for object files.
        0x00B00000:
          id: image_scn_align_1024bytes
          -orig-id: IMAGE_SCN_ALIGN_1024BYTES
          doc: Align data on a 1024-byte boundary. Valid only for object files.
        0x00C00000:
          id: image_scn_align_2048bytes
          -orig-id: IMAGE_SCN_ALIGN_2048BYTES
          doc: Align data on a 2048-byte boundary. Valid only for object files.
        0x00D00000:
          id: image_scn_align_4096bytes
          -orig-id: IMAGE_SCN_ALIGN_4096BYTES
          doc: Align data on a 4096-byte boundary. Valid only for object files.
        0x00E00000:
          id: image_scn_align_8192bytes
          -orig-id: IMAGE_SCN_ALIGN_8192BYTES
          doc: Align data on an 8192-byte boundary. Valid only for object files.
        0x01000000:
          id: image_scn_lnk_nreloc_ovfl
          -orig-id: IMAGE_SCN_LNK_NRELOC_OVFL
          doc: The section contains extended relocations.
        0x02000000:
          id: image_scn_mem_discardable
          -orig-id: IMAGE_SCN_MEM_DISCARDABLE
          doc: The section can be discarded as needed.
        0x04000000:
          id: image_scn_mem_not_cached
          -orig-id: IMAGE_SCN_MEM_NOT_CACHED
          doc: The section cannot be cached.
        0x08000000:
          id: image_scn_mem_not_paged
          -orig-id: IMAGE_SCN_MEM_NOT_PAGED
          doc: The section is not pageable.
        0x10000000:
          id: image_scn_mem_shared
          -orig-id: IMAGE_SCN_MEM_SHARED
          doc: The section can be shared in memory.
        0x20000000:
          id: image_scn_mem_execute
          -orig-id: IMAGE_SCN_MEM_EXECUTE
          doc: The section can be executed as code.
        0x40000000:
          id: image_scn_mem_read
          -orig-id: IMAGE_SCN_MEM_READ
          doc: The section can be read.
        0x80000000:
          id: image_scn_mem_write
          -orig-id: IMAGE_SCN_MEM_WRITE
          doc: The section can be written to.

  # Recursive lookup inside of sections to return pointer_to_raw data of dat_dir
  lookup_iteration:
    params:
      - id: idx
        type: u4
      - id: virtual_address
        type: u4
    instances:
      section:
        value: _root.pe.sections[idx]
      found:
        value: "virtual_address >= section.virtual_address and virtual_address <= section.virtual_address + section.size_of_raw_data"
      next_idx:
        value: "idx + (idx + 1 < _root.pe.coff_hdr.number_of_sections ? 1 : 0)"
      has_next:
        value: next_idx > idx
  sections_lookup:
    to-string: |
      'Session lockup <VirtualAddr: ' + virtual_address.to_s + ', Sections: ' + tmp_sections.size.to_s + '>'
    params:
      - id: virtual_address
        type: u4
    seq:
      - id: tmp_sections
        type: "lookup_iteration(_index, virtual_address)"
        repeat: until
        repeat-until: _.found or not _.has_next
    instances:
      section:
        value: tmp_sections.last.section
        if: tmp_sections.size > 0
      has_section:
        value: tmp_sections.size > 0 and tmp_sections.last.found

  certificate_table:
    seq:
      - id: items
        type: certificate_entry
        repeat: eos
  certificate_entry:
    doc-ref: 'https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#the-attribute-certificate-table-image-only'
    seq:
      - id: length
        -orig-id: dwLength
        type: u4
        doc: Specifies the length of the attribute certificate entry.
      - id: revision
        -orig-id: wRevision
        type: u2
        enum: certificate_revision
        doc: Contains the certificate version number.
      - id: certificate_type
        -orig-id: wCertificateType
        type: u2
        enum: certificate_type_enum
        doc: Specifies the type of content in bCertificate
      - id: certificate_bytes
        -orig-id: bCertificate
        size: length - 8
        doc: Contains a certificate, such as an Authenticode signature.
    enums:
      certificate_revision:
        0x0100:
          id: revision_1_0
          doc: |
            Version 1, legacy version of the Win_Certificate structure.
            It is supported only for purposes of verifying legacy Authenticode signatures
        0x0200:
          id: revision_2_0
          doc: Version 2 is the current version of the Win_Certificate structure.
      certificate_type_enum:
        0x0001:
          id: x509
          doc: |
            bCertificate contains an X.509 Certificate
            Not Supported
        0x0002:
          id: pkcs_signed_data
          doc: bCertificate contains a PKCS#7 SignedData structure
        0x0003:
          id: reserved_1
          doc: Reserved
        0x0004:
          id: ts_stack_signed
          doc: |
            Terminal Server Protocol Stack Certificate signing
            Not Supported
  debug_table_entries:
    seq:
      - id: entry
        type: debug_table_entry
        repeat: eos
  debug_table_entry:
    doc-ref: 'https://www.debuginfo.com/articles/debuginfomatch.html'
    seq:
      - id: characteristics
        -orig-id: Characteristics
        type: u4
      - id: time_date_stamp
        -orig-id: TimeDateStamp
        type: u4
      - id: major_version
        -orig-id: MajorVersion
        type: u2
      - id: minor_version
        -orig-id: MinorVersion
        type: u2
      - id: type
        -orig-id: Type
        type: u4
        enum: debug_entry_type
      - id: size_of_data
        -orig-id: SizeOfData
        type: u4
      - id: address_of_raw_data
        -orig-id: AddressOfRawData
        type: u4
      - id: pointer_to_raw_data
        -orig-id: PointerToRawData
        type: u4
    instances:
      codeview_debug:
        io: _root._io
        pos: pointer_to_raw_data
        size: size_of_data
        type: codeview_debug_info
        if: type == debug_entry_type::codeview
    enums:
      debug_entry_type:
        0: unknown
        1: coff
        2: codeview
        3: fpo
        4: misc
        5: exception
        6: fixup
        9: borland
      cv_signature:
        0x53445352: rsds
    types:
      codeview_debug_info:
        seq:
          - id: header
            type: cv_header
          - id: body
            type:
              switch-on: header.signature
              cases:
                'cv_signature::rsds': cv_info_pdb70
      cv_header:
        seq:
          - id: signature
            type: u4
            enum: cv_signature
      cv_info_pdb70:
        seq:
          - id: signature
            size: 16
          - id: age
            type: u4
          - id: pdb_file_name
            size-eos: true
            type: strz
            encoding: UTF-8

  dotnet_header:
    to-string: |
      '.NET Header'
    seq:
      - id: cb
        type: u4
      - id: major_runtime_version
        type: u2
      - id: minor_runtime_version
        type: u2
      - id: meta_data
        type: data_dir
      - id: flags
        type: u4
        enum: flag_enum
      - id: entry_point_token
        type: u4
      - id: entry_point_virtual_address
        type: u4
      - id: resources
        type: data_dir
      - id: strong_name_signature
        type: data_dir
      - id: code_manager_table
        type: data_dir
      - id: export_address_table_jumps
        type: data_dir
      - id: managed_native_header
        type: data_dir
    enums:
      flag_enum:
        0: unknown
        0x00000001: il_only
        0x00000002: required_32bit
        0x00000004: il_library
        0x00000008: strongnamesigned
        0x00000010: native_entrypoint
        0x00010000: trackdebugdata

  dotnet_metadata_header:
    doc-ref: https://www.ntcore.com/files/dotnetformat.htm
    to-string: |
      'Metadata Header <.NET Version ' + version_string + ', NumberOfStreams: ' + number_of_streams.to_s + '>'
    seq:
      - id: signature
        type: u4
      - id: major_version
        type: u2
      - id: minor_version
        type: u2
      - id: reserved
        type: u4
      - id: version_length
        type: u4
      - id: version_string
        size: version_length
        type: str
        pad-right: 0
        encoding: UTF-8
      - id: flags
        type: u2
      - id: number_of_streams
        type: u2
      - id: streams
        type: dotnet_stream
        repeat: expr
        repeat-expr: number_of_streams
  dotnet_stream:
    -webide-representation: '{name}'
    to-string: |
      'Stream <Name: ' + name + ', Offset: ' + offset.to_s + ', Size: ' + size.to_s + ', PointerToRawData: ' + pointer_to_raw_data.to_s + '>'
    seq:
      - id: offset
        type: u4
      - id: size
        type: u4
      - id: name
        type: strz
        terminator: 0
        eos-error: false
        encoding: ASCII
      - id: padding
        size: (4 - _io.pos) % 4
    instances:
      pointer_to_raw_data:
        value: _root.pe.dotnet_header.meta_data.pointer_to_raw_data + offset

  resource_directory_table:
    doc-ref: 'https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#resource-directory-table'
    params:
      - id: depth
        type: u4
      - id: section_file_offset
        type: u4
      - id: section_virtual_address
        type: u4
    seq:
      - id: reserved
        -orig-id: characteristics
        type: u4
        doc: Reserved for future use, should be set to zero
      - id: timestamp
        -orig-id: TimeDateStamp
        type: u4
      - id: version
        type: version_u2
      - id: num_named_entries
        -orig-id: NumberOfNamedEntries
        type: u2
      - id: num_id_entries
        -orig-id: NumberOfIdEntries
        type: u2
      - id: named_entries
        type: resource_directory_entry(depth)
        repeat: expr
        repeat-expr: num_named_entries
      - id: id_entries
        type: resource_directory_entry(depth)
        repeat: expr
        repeat-expr: num_id_entries

  resource_directory_entry:
    doc-ref: 'https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#resource-directory-entries'
    params:
      - id: depth
        type: u4
    seq:
      - id: resource_type
        type: u4
        enum: enum_resource_type
        if: depth == 0
      - id: ofs_name
        type: b31
        if: depth != 0
      - id: is_name
        type: b1
        if: depth != 0
        doc: Whether ofs_name is an id or points to a directory-string
      - id: ofs_data_entry
        type: b31
      - id: is_subdirectory
        type: b1
        doc: |
          Whether ofs_data_entry points to a child (directory entry) or a
          leaf (data entry).
    instances:
      subdirectory:
        io: _root._io
        pos: ofs_data_entry + _parent.section_file_offset
        type: resource_directory_table(depth + 1, _parent.section_file_offset, _parent.section_virtual_address)
        if: is_subdirectory
        parent: _parent
      data_entry:
        io: _root._io
        pos: ofs_data_entry + _parent.section_file_offset
        type: resource_data_entry
        if: not is_subdirectory
        parent: _parent
      name:
        io: _root._io
        pos: ofs_name + _parent.section_file_offset
        type: resource_directory_string
        if: is_name
        parent: _parent
    enums:
      enum_resource_type:
        1: cursor
        2: bitmap
        3: icon
        4: menu
        5: dialog
        6: string
        7: fontdir
        8: font
        9: accelerator
        10: rcdata
        11: messagetable
        12: group_cursor
        14: group_icon
        16: version
        17: dlginclude
        19: plugplay
        20: vxd
        21: anicursor
        22: aniicon
        23: html
        24: manifest

  resource_data_entry:
    doc-ref: 'https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#resource-data-entry'
    seq:
      - id: data_rva
        -orig-id: OffsetToData
        type: u4
        doc: Relative virtual address of the resource data entry
      - id: len_resource_data_entry
        -orig-id: Size
        type: u4
      - id: codepage
        type: u4
      - id: reserved
        type: u4
    instances:
      body:
        io: _root._io
        pos: (data_rva - _parent.section_virtual_address) + _parent.section_file_offset
        size: len_resource_data_entry

  resource_directory_string:
    doc-ref: 'https://learn.microsoft.com/en-us/windows/win32/debug/pe-format#resource-directory-string'
    seq:
      - id: len_name
        -orig-id: Length
        type: u2
        doc: Number of UTF-16LE encoded characters
      - id: name
        -orig-id: NameString
        size: len_name * 2
        type: str
        encoding: UTF-16LE

  version_u2:
    seq:
      - id: major
        type: u2
      - id: minor
        type: u2
