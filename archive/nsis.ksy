meta:
  id: nsis
  title: Nullsoft Scriptable Install System (NSIS) installer data
  application: Nullsoft Scriptable Install System
  file-extension: exe
  license: GPL-3.0-or-later
  ks-version: '0.11'
  endian: le
  bit-endian: le
doc: |
  The data that an NSIS installer stub reads from the end of its own
  executable: the "first header", the compressed installer header (the
  script, strings and UI data) and the compressed files.

  Parse from the start of the first header, not from the start of the
  executable. It is at a 512-byte aligned offset after the stub's PE image
  (Komac searches from the start of the overlay, for up to 1 MiB), with
  its 16-byte signature `EF BE AD DE "NullsoftInst"` at offset 4.

  The installer data is either solid (one compressed stream that holds a
  4-byte header length, the header and then every file) or non-solid (a
  sequence of blocks, each with a 4-byte length whose top bit says whether
  the block is compressed). The compressor (deflate, NSIS's variant of
  bzip2, or LZMA) is not recorded anywhere, so it is detected from the
  first bytes in the same way as the NSIS decompilers do. Only a
  non-solid header that is stored, or compressed with deflate, is
  decompressed and parsed here (with `kaitai.compress.deflate`): NSIS's
  bzip2 has no stream header and its LZMA streams have no length, so
  neither can be decoded by a stock decompressor. NSIS's deflate also
  omits the one's complement length of stored blocks, so a header with a
  stored deflate block fails to decompress.

  The layout of the decompressed header is that of NSIS 2.0 to 3.x, as
  read by Komac; NSIS 1.x headers, whose first header signatures are
  accepted here, have another layout and are not parsed. Forks that
  change the layout (NSISBI with 8-byte block lengths, the 64-bit NSIS
  builds and the "Park" Unicode fork) are not handled.
doc-ref:
  - https://github.com/devicie/Komac-anthelion/tree/f9b303df556625ef39215e9c66e08ca037829866/src/analysis/installers/nsis
  - https://github.com/NSIS-Dev/nsis/blob/v311/Source/exehead/fileform.h
  - https://github.com/ip7z/7zip/blob/main/CPP/7zip/Archive/Nsis/NsisIn.cpp
seq:
  - id: first_header
    type: first_header
  - id: body
    size: first_header.len_all_data - first_header._sizeof
    type: body
types:
  first_header:
    -orig-id: firstheader
    seq:
      - id: flags
        type: first_header_flags
      - id: signature
        size: 16
        valid:
          any-of:
            - '[0xef, 0xbe, 0xad, 0xde, 0x4e, 0x75, 0x6c, 0x6c, 0x73, 0x6f, 0x66, 0x74, 0x49, 0x6e, 0x73, 0x74]'
            - '[0xed, 0xbe, 0xad, 0xde, 0x4e, 0x75, 0x6c, 0x6c, 0x53, 0x6f, 0x66, 0x74, 0x49, 0x6e, 0x73, 0x74]'
            - '[0xef, 0xbe, 0xad, 0xde, 0x6e, 0x73, 0x69, 0x73, 0x69, 0x6e, 0x73, 0x74, 0x61, 0x6c, 0x6c, 0x00]'
        doc: |
          `FH_SIG` (0xDEADBEEF) followed by `FH_INT1`..`FH_INT3`:
          "NullsoftInst" since NSIS 1.30, "NullSoftInst" with 0xDEADBEED
          in NSIS 1.1e to 1.2x, "nsisinstall" in NSIS 1.0.
      - id: len_header
        -orig-id: length_of_header
        type: u4
        doc: Size of the installer header after decompression.
      - id: len_all_data
        -orig-id: length_of_all_following_data
        type: u4
        doc: |
          Size of all of the installer data, including this first header
          and the trailing CRC-32, if there is one.
  first_header_flags:
    seq:
      - id: uninstall
        type: b1
        doc: |
          `FH_FLAGS_UNINSTALL`: this data is an uninstaller. (The NSIS 1.x
          flags differ.)
      - id: silent
        type: b1
        doc: '`FH_FLAGS_SILENT`: the installer starts in silent mode.'
      - id: no_crc
        type: b1
        doc: '`FH_FLAGS_NO_CRC`: there is no CRC-32 at the end of the data.'
      - id: force_crc
        type: b1
        doc: '`FH_FLAGS_FORCE_CRC`: the CRC is checked even in silent mode.'
      - id: bi_long_offset
        type: b1
        doc: NSISBI fork, which uses 8-byte lengths.
      - id: bi_external_file_support
        type: b1
        doc: NSISBI fork.
      - id: bi_external_file
        type: b1
        doc: NSISBI fork.
      - id: bi_is_stub_installer
        type: b1
        doc: NSISBI fork.
      - id: reserved
        type: b24
  body:
    instances:
      prefix:
        pos: 0
        type: u4
      start:
        pos: 0
        type: compression_signature
      is_solid:
        value: |
          prefix != _root.first_header.len_header
          and (start.is_lzma or (prefix >> 24) != 0x80)
        doc: |
          Non-solid data starts with the header block, whose length either
          equals the header length (stored) or has its top bit set
          (compressed). As in 7-Zip, the checks are made in the order:
          stored length, solid LZMA, then a top byte of exactly 0x80 (a
          compressed header under 16 MiB), since solid bzip2 and deflate
          data can also start with a byte that has its top bit set.
      solid_compression:
        value: |
          start.is_lzma ? compression::lzma
          : start.is_bzip2 ? compression::bzip2
          : compression::deflate
        enum: compression
        if: is_solid
      header_block:
        pos: 0
        type: block
        if: not is_solid
        doc: The installer header, as the first block of non-solid data.
      solid_data:
        pos: 0
        size-eos: true
        if: is_solid
        doc: |
          One compressed stream of the 4-byte header length, the header and
          every file, each file preceded by its 4-byte length. LZMA streams
          start with the 5-byte properties and dictionary size.
  block:
    seq:
      - id: len_and_flag
        type: u4
      - id: stored
        size: len_data
        type: header
        if: not is_compressed
      - id: deflate
        size: len_data
        type: header
        process: kaitai.compress.deflate
        if: is_compressed and compression == compression::deflate
      - id: compressed
        size: len_data
        if: is_compressed and compression != compression::deflate
    instances:
      is_compressed:
        value: (len_and_flag & 0x8000_0000) != 0
      len_data:
        value: len_and_flag & 0x7fff_ffff
      start:
        pos: 4
        type: compression_signature
        if: is_compressed
      compression:
        value: |
          start.is_lzma ? compression::lzma
          : start.is_bzip2 ? compression::bzip2
          : compression::deflate
        enum: compression
        if: is_compressed
      header:
        value: 'is_compressed ? deflate : stored'
        if: not is_compressed or compression == compression::deflate
  compression_signature:
    doc: |
      The first bytes of compressed data, from which the compressor is
      guessed as 7-Zip does (`IsLZMA` and `IsBZip2` in NsisIn.cpp).
    seq:
      - id: bytes
        size: 8
    instances:
      is_lzma_at_0:
        value: |
          bytes[0] == 0x5d and bytes[1] == 0 and bytes[2] == 0
          and bytes[5] == 0 and (bytes[6] & 0x80) == 0
        doc: |
          LZMA properties 0x5D (lc=3, lp=0, pb=2) and a dictionary size
          below 16 MiB, then a range coder that starts with a zero byte.
      is_lzma_at_1:
        value: |
          bytes[0] <= 1 and bytes[1] == 0x5d and bytes[2] == 0 and bytes[3] == 0
          and bytes[6] == 0 and (bytes[7] & 0x80) == 0
        doc: The same after a filter flag (1 for the BCJ x86 filter).
      is_lzma:
        value: is_lzma_at_0 or is_lzma_at_1
      has_filter_flag:
        value: not is_lzma_at_0 and is_lzma_at_1
      is_bzip2:
        value: bytes[0] == 0x31 and bytes[1] < 14
        doc: NSIS's bzip2 block header, which lacks the "BZh" stream header.
  header:
    -orig-id: header
    doc: The decompressed installer header (`header` in fileform.h).
    seq:
      - id: flags
        type: header_flags
      - id: blocks
        type: block_header
        repeat: expr
        repeat-expr: 'len_header_struct >= 284 ? 8 : 7'
        doc: |
          Pages, sections, entries, strings, language tables, control
          colors, background font (not in NSIS 2.0) and data.
      - id: install_reg_rootkey
        type: s4
        enum: registry_root
        doc: Root key of the `InstallDirRegKey` value.
      - id: ofs_install_reg_key
        -orig-id: install_reg_key_ptr
        type: s4
      - id: ofs_install_reg_value
        -orig-id: install_reg_value_ptr
        type: s4
      - id: bg_color1
        type: s4
      - id: bg_color2
        type: s4
      - id: bg_textcolor
        type: s4
      - id: lb_bg
        type: s4
        doc: Background color of the installation log window.
      - id: lb_fg
        type: s4
        doc: Text color of the installation log window.
      - id: len_language_tables
        -orig-id: langtable_size
        type: s4
        doc: Size of each language table, in bytes.
      - id: license_bg
        type: s4
      - id: code_on_init
        -orig-id: code_onInit
        type: s4
        doc: Entry index of the `.onInit` callback function, or -1.
      - id: code_on_inst_success
        -orig-id: code_onInstSuccess
        type: s4
      - id: code_on_inst_failed
        -orig-id: code_onInstFailed
        type: s4
      - id: code_on_user_abort
        -orig-id: code_onUserAbort
        type: s4
      - id: code_on_gui_init
        -orig-id: code_onGUIInit
        type: s4
      - id: code_on_gui_end
        -orig-id: code_onGUIEnd
        type: s4
      - id: code_on_verify_inst_dir_v200
        -orig-id: code_onVerifyInstDir
        type: s4
        if: len_header_struct < 288
        doc: NSIS 2.0 and 2.01 put this before `code_onMouseOverSection`.
      - id: code_on_mouse_over_section
        -orig-id: code_onMouseOverSection
        type: s4
      - id: code_on_verify_inst_dir_v202
        -orig-id: code_onVerifyInstDir
        type: s4
        if: len_header_struct >= 288
      - id: code_on_sel_change
        -orig-id: code_onSelChange
        type: s4
      - id: code_on_reboot_failed
        -orig-id: code_onRebootFailed
        type: s4
        if: len_header_struct >= 288
        doc: Since NSIS 2.02.
      - id: install_types
        type: s4
        repeat: expr
        repeat-expr: 33
        doc: |
          String offsets of the names of the installation types
          (`NSIS_MAX_INST_TYPES` + 1, the last one being "Custom").
      - id: ofs_install_directory
        -orig-id: install_directory_ptr
        type: s4
        doc: String offset of the default installation directory.
      - id: ofs_install_directory_auto_append
        -orig-id: install_directory_auto_append
        type: s4
      - id: ofs_str_uninstchild
        -orig-id: str_uninstchild
        type: s4
        if: len_header_struct >= 300
      - id: ofs_str_uninstcmd
        -orig-id: str_uninstcmd
        type: s4
        if: len_header_struct >= 300
      - id: ofs_str_wininit
        -orig-id: str_wininit
        type: s4
        if: len_header_struct >= 300
    instances:
      ofs_pages:
        pos: 4
        type: u4
      len_header_struct:
        value: ofs_pages
        doc: |
          Size of this structure, which the pages block follows, and so
          its layout: 276 in NSIS 2.0 (7 blocks), 284 in NSIS 2.01 (with
          the background font block), 288 in NSIS 2.02 to 2.2x (with
          `code_onRebootFailed`) and 300 since NSIS 2.25 (with the
          uninstaller strings), as in the fileform.h of each release.
      code_on_verify_inst_dir:
        value: 'len_header_struct < 288 ? code_on_verify_inst_dir_v200 : code_on_verify_inst_dir_v202'
      len_pages:
        value: '(blocks[1].ofs - blocks[0].ofs) / blocks[0].num'
        if: blocks[0].num > 0
      pages:
        pos: blocks[0].ofs
        size: len_pages
        type: page
        repeat: expr
        repeat-expr: blocks[0].num
        if: blocks[0].num > 0
      len_sections:
        value: '(blocks[2].ofs - blocks[1].ofs) / blocks[1].num'
        if: blocks[1].num > 0
      sections:
        pos: blocks[1].ofs
        size: len_sections
        type: section
        repeat: expr
        repeat-expr: blocks[1].num
        if: blocks[1].num > 0
      entries:
        pos: blocks[2].ofs
        type: entry
        repeat: expr
        repeat-expr: blocks[2].num
        doc: The installer's instructions, 28 bytes each.
      strings:
        pos: blocks[3].ofs
        size: blocks[4].ofs - blocks[3].ofs
        doc: |
          The string table. Header and entry fields that are string
          offsets index into it (in characters, for Unicode installers);
          negative offsets refer to language strings instead. Strings are
          null-terminated, with special codes for variables, shell
          folders and language strings: 252 to 255 in NSIS 2 (ANSI), and
          1 to 4 in NSIS 3 (both ANSI and UTF-16LE).
      language_tables:
        pos: blocks[4].ofs
        size: len_language_tables
        type: language_table
        repeat: expr
        repeat-expr: blocks[4].num
        if: len_language_tables > 0
      control_colors:
        pos: blocks[5].ofs
        type: control_colors
        repeat: expr
        repeat-expr: blocks[5].num
  header_flags:
    -orig-id: CH_FLAGS_*
    seq:
      - id: details_show_details
        type: b1
      - id: details_never_show
        type: b1
      - id: progress_colored
        type: b1
      - id: silent
        type: b1
      - id: silent_log
        type: b1
      - id: auto_close
        type: b1
      - id: dir_no_show
        type: b1
      - id: no_root_dir
        type: b1
      - id: comp_only_on_custom
        type: b1
      - id: no_custom
        type: b1
      - id: reserved
        type: b22
  block_header:
    seq:
      - id: ofs
        -orig-id: offset
        type: u4
        doc: Offset of the block from the start of the header.
      - id: num
        type: u4
        doc: Number of items in the block.
  page:
    doc: |
      An installer page. Only the fixed fields are parsed; the rest of the
      structure depends on the NSIS version.
    seq:
      - id: dlg_id
        type: s4
        doc: Resource ID of the dialog of a built-in page.
      - id: wnd_proc_id
        -orig-id: wndproc_id
        type: s4
        enum: page_proc
      - id: pre_func
        -orig-id: prefunc
        type: s4
        doc: Entry index of the page's pre function, or -1.
      - id: show_func
        -orig-id: showfunc
        type: s4
      - id: leave_func
        -orig-id: leavefunc
        type: s4
    enums:
      page_proc:
        0: license
        1: select_components
        2: directory
        3: install_files
        4: uninstall
        5: completed
        6: custom
  section:
    doc: |
      A section. The fixed fields are followed by a buffer for the
      section name (`NSIS_MAX_STRLEN` characters).
    seq:
      - id: ofs_name
        -orig-id: name_ptr
        type: s4
        doc: String offset of the section name.
      - id: install_types
        type: s4
        doc: Bit mask of the installation types the section is in.
      - id: flags
        type: s4
        doc: '`SF_*` flags: 1 selected, 2 section group, 4 group end, 8 bold, 16 read-only.'
      - id: code
        type: s4
        doc: Index of the section's first entry.
      - id: code_size
        type: s4
        doc: Number of the section's entries.
      - id: size_kb
        type: s4
      - id: name
        size-eos: true
  entry:
    -orig-id: entry
    seq:
      - id: opcode
        -orig-id: which
        type: u4
        enum: opcode
        doc: |
          `EW_*` opcode, numbered as in a default NSIS 3 build. Builds with
          `NSIS_CONFIG_LOG` insert `EW_LOG` at 63, and NSIS 2 and builds
          that leave out optional features shift the later opcodes too.
      - id: offsets
        type: s4
        repeat: expr
        repeat-expr: 6
        doc: |
          The instruction's operands: string offsets, entry indexes,
          variable numbers or plain values, depending on the opcode.
  language_table:
    seq:
      - id: lang_id
        type: u2
        doc: Windows language ID.
      - id: ofs_dlg
        -orig-id: dlg_offset
        type: s4
      - id: right_to_left
        -orig-id: rtl
        type: s4
      - id: string_offsets
        size-eos: true
        doc: String offsets of the language strings, 4 bytes each.
  control_colors:
    -orig-id: ctlcolors
    seq:
      - id: text
        type: u4
      - id: bk_color
        -orig-id: bkc
        type: u4
      - id: lb_style
        -orig-id: lbStyle
        type: u4
      - id: bk_brush
        -orig-id: bkb
        type: s4
      - id: bk_mode
        -orig-id: bkmode
        type: s4
      - id: flags
        type: s4
enums:
  compression:
    0: deflate
    1: bzip2
    2: lzma
  registry_root:
    0: shell_context
    -2147483648: hkey_classes_root
    -2147483647: hkey_current_user
    -2147483646: hkey_local_machine
    -2147483645: hkey_users
    -2147483644: hkey_performance_data
    -2147483643: hkey_current_config
    -2147483642: hkey_dyn_data
  opcode:
    0: invalid
    1: ret
    2: nop
    3: abort
    4: quit
    5: call
    6: update_text
    7: sleep
    8: bring_to_front
    9: ch_details_view
    10: set_file_attributes
    11: create_dir
    12: if_file_exists
    13: set_flag
    14: if_flag
    15: get_flag
    16: rename
    17: get_full_pathname
    18: search_path
    19: get_temp_filename
    20: extract_file
    21: delete_file
    22: message_box
    23: remove_dir
    24: str_len
    25: assign_var
    26: str_cmp
    27: read_env
    28: int_cmp
    29: int_op
    30: int_fmt
    31: push_pop
    32: find_window
    33: send_message
    34: is_window
    35: get_dialog_item
    36: set_ctl_colors
    37: set_branding_image
    38: create_font
    39: show_window
    40: shell_exec
    41: execute
    42: get_file_time
    43: get_dll_version
    44: register_dll
    45: create_shortcut
    46: copy_files
    47: reboot
    48: write_ini
    49: read_ini
    50: delete_reg
    51: write_reg
    52: read_reg
    53: reg_enum_key
    54: file_close
    55: file_open
    56: file_write
    57: file_read
    58: file_seek
    59: find_close
    60: find_next
    61: find_first
    62: write_uninstaller
    63: section_set
    64: install_type_set
    65: get_os_info
    66: reserved_opcode
    67: lock_window
    68: file_write_utf16le
    69: file_read_utf16le
