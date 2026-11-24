meta:
  id: windows_vs_version_info
  title: Windows version resource (VS_VERSIONINFO)
  application: Microsoft Windows
  license: GPL-3.0-or-later
  ks-version: '0.11'
  encoding: UTF-16LE
  endian: le
  bit-endian: le
doc: |
  The version information resource (`RT_VERSION`, resource type 16) of a
  Windows executable: the language-independent `VS_FIXEDFILEINFO` and the
  `StringFileInfo` and `VarFileInfo` blocks that hold the version strings
  (such as "CompanyName" and "ProductVersion") and the translations.

  The resource is a tree of blocks. Each block has a length, a value
  length, a type, a null-terminated UTF-16LE key, padding to a 4-byte
  boundary, a value, more padding and then its children. This spec parses
  the 32-bit (UTF-16) form written by resource compilers since Windows NT,
  not the 16-bit ANSI form.

  The value length of a string is meant to count UTF-16 code units
  including the terminator, but compilers disagree on whether to count
  the terminator, or even write bytes, so a string's value is read as the
  rest of its block, up to the first null code unit, as Windows and Komac
  do.
doc-ref:
  - https://github.com/devicie/Komac-anthelion/tree/f9b303df556625ef39215e9c66e08ca037829866/src/analysis/installers/pe/vs_version_info
  - https://learn.microsoft.com/en-us/windows/win32/menurc/vs-versioninfo
  - https://learn.microsoft.com/en-us/windows/win32/api/verrsrc/ns-verrsrc-vs_fixedfileinfo
seq:
  - id: root
    type: block(0)
    doc: The `VS_VERSION_INFO` block.
types:
  block:
    params:
      - id: kind
        type: u1
        doc: |
          What the parent says this block is: 0 the root, 1 a child of the
          root, 2 a string table, 3 a string, 4 a `Var`, 5 an unknown block.
    seq:
      - id: len_block
        -orig-id: wLength
        type: u2
        doc: Size of the block, including its children but not its trailing padding.
      - id: body
        size: len_block - 2
        type: block_body(kind)
      - id: padding
        size: '_io.size - _io.pos < len_padding ? _io.size - _io.pos : len_padding'
    instances:
      len_padding:
        value: (4 - len_block % 4) % 4
  block_body:
    params:
      - id: kind
        type: u1
        doc: The kind of the block, as for `block`.
    seq:
      - id: len_value
        -orig-id: wValueLength
        type: u2
        doc: |
          Size of the value: in bytes for binary values, in UTF-16 code
          units (unreliably) for text values.
      - id: type
        -orig-id: wType
        type: u2
        enum: value_type
      - id: key
        -orig-id: szKey
        type: strz
        doc: |
          "VS_VERSION_INFO", "StringFileInfo", "VarFileInfo", a string
          table's language and code page as 8 hexadecimal digits (such as
          "040904B0"), a string's name, or "Translation".
      - id: key_padding
        size: '_io.size - _io.pos < len_key_padding ? _io.size - _io.pos : len_key_padding'
        doc: |
          Padding to a 4-byte boundary (relative to the block), which a
          block with an empty value can omit.
      - id: fixed_file_info
        size: len_value
        type: fixed_file_info
        if: kind == 0 and len_value > 0
      - id: string_value
        type: strz
        eos-error: false
        if: kind == 3
        doc: The string; any bytes after its terminator are left unread.
      - id: translations
        type: translation
        repeat: expr
        repeat-expr: len_value / 4
        if: kind == 4
        doc: Language and code page pairs, for the `Translation` value.
      - id: value_padding
        size: '_io.size - _io.pos < len_value_padding ? _io.size - _io.pos : len_value_padding'
        if: kind == 0 and len_value > 0
      - id: children
        type: block(child_kind)
        repeat: eos
        if: kind <= 2
      - id: unknown
        size-eos: true
        if: kind == 5
        doc: The value and children of a block with an unknown key.
    instances:
      len_key_padding:
        value: (4 - (_io.pos + 2) % 4) % 4
        doc: Only valid while `key_padding` is read, right after the key.
      len_value_padding:
        value: (4 - len_value % 4) % 4
      child_kind:
        value: |
          kind == 0 ? 1
          : kind == 2 ? 3
          : key == "StringFileInfo" ? 2
          : key == "VarFileInfo" ? 4
          : 5
        doc: |
          The children of the root are `StringFileInfo` (whose children
          are string tables, whose children are strings) and `VarFileInfo`
          (whose children are `Var` blocks). Unknown blocks get kind 5.
    enums:
      value_type:
        0: binary
        1: text
  translation:
    seq:
      - id: language_id
        type: u2
        doc: Windows language ID, such as 0x0409 for en-US.
      - id: code_page
        type: u2
        doc: Code page, such as 1200 for Unicode.
  fixed_file_info:
    -orig-id: VS_FIXEDFILEINFO
    seq:
      - id: signature
        -orig-id: dwSignature
        contents: [0xbd, 0x04, 0xef, 0xfe]
      - id: struc_version_minor
        type: u2
      - id: struc_version_major
        -orig-id: dwStrucVersion
        type: u2
      - id: file_version_minor
        type: u2
      - id: file_version_major
        -orig-id: dwFileVersionMS
        type: u2
      - id: file_version_revision
        type: u2
      - id: file_version_build
        -orig-id: dwFileVersionLS
        type: u2
      - id: product_version_minor
        type: u2
      - id: product_version_major
        -orig-id: dwProductVersionMS
        type: u2
      - id: product_version_revision
        type: u2
      - id: product_version_build
        -orig-id: dwProductVersionLS
        type: u2
      - id: file_flags_mask
        -orig-id: dwFileFlagsMask
        type: u4
      - id: file_flags
        -orig-id: dwFileFlags
        type: file_flags
      - id: file_os
        -orig-id: dwFileOS
        type: u4
        enum: file_os
      - id: file_type
        -orig-id: dwFileType
        type: u4
        enum: file_type
      - id: file_subtype
        -orig-id: dwFileSubtype
        type: u4
        doc: The kind of driver or font, for those file types.
      - id: file_date_ms
        -orig-id: dwFileDateMS
        type: u4
      - id: file_date_ls
        -orig-id: dwFileDateLS
        type: u4
    instances:
      file_date:
        value: file_date_ms << 32 | file_date_ls
        doc: Creation time as a FILETIME, usually 0.
    enums:
      file_os:
        0x0: unknown
        0x1: windows16
        0x2: pm16
        0x3: pm32
        0x4: windows32
        0x10000: dos
        0x10001: dos_windows16
        0x10004: dos_windows32
        0x20000: os2_16
        0x20002: os2_16_pm16
        0x30000: os2_32
        0x30003: os2_32_pm32
        0x40000: nt
        0x40004: nt_windows32
        0x50000: wince
      file_type:
        0: unknown
        1: app
        2: dll
        3: drv
        4: font
        5: vxd
        7: static_lib
  file_flags:
    seq:
      - id: debug
        type: b1
      - id: prerelease
        type: b1
      - id: patched
        type: b1
      - id: private_build
        type: b1
      - id: info_inferred
        type: b1
      - id: special_build
        type: b1
      - id: reserved
        type: b26
