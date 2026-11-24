# Imported from https://gist.githubusercontent.com/jabb3rd/5e4294798c3acd52fe931bdc0af189a9/raw/4b7f01268edfa455fb61e2e634b6063791abb082/npk-format.ksy
meta:
  id: mikrotik_npk
  file-extension: npk
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    type: u4
    enum: npk_types
  - id: npk_size
    type: u4
  - id: sections
    type: section
    repeat: eos
types:
  # A section header
  section:
    seq:
      - id: section_type
        type: u2
        enum: section_types
      - id: size
        type: u4
      - id: body
        type:
          # The section contents depends on section type number
          switch-on: section_type
          cases:
            'section_types::info': info
            'section_types::description': description
            'section_types::dependencies': dependencies
            'section_types::architecture': architecture
            'section_types::channel': channel
            'section_types::digest': digest
            # Treat anything else as a raw data
            _: raw_data
  # Information block (a short name and maybe some binary flags)
  info:
    seq:
      - id: name
        size: 16
      - id: unknown_1
        size: 4
      - id: timestamp
        type: u4
      - id: unknown_2
        size: (_parent.size - 24)
  # A text description of the package
  description:
    seq:
      - id: description
        size: _parent.size
        type: str
        encoding: ASCII
  # Which packages are required (binary)
  dependencies:
    seq:
      - id: data
        size: _parent.size
  architecture:
    seq:
      - id: architecture
        size: _parent.size
        type: str
        encoding: ASCII
  # An update channel (current/bugfix/etc.)
  channel:
    seq:
      - id: channel
        size: _parent.size
        type: str
        encoding: ASCII
  # A SHA-1 hash
  digest:
    seq:
      - id: digest
        size: _parent.size
        type: str
        encoding: ASCII
  # Anything else is a raw data
  raw_data:
    seq:
      - id: data
        size: _parent.size
enums:
  # Section types inside a NPK container
  section_types:
    0x01: info
    0x02: description
    0x03: dependencies
    0x04: file_container
    0x05: libinstall_install_script
    0x06: libinstall_uninstall_script
    0x07: bash_install_script
    0x08: bash_uninstall_script
    0x09: signature
    0x0a: unused_1
    0x0b: unused_2
    0x0c: unused_3
    0x0d: unused_4
    0x0e: unused_5
    0x0f: unused_6
    0x10: architecture
    0x11: package_conflicts
    0x12: package_info
    0x13: section_features
    0x14: package_features
    0x15: squashfs_block
    0x16: zero_padding
    0x17: digest
    0x18: channel
  
  # Different magic header values
  npk_types:
    0xBAD0F11E: restriction_package
    0xA1100FFB: normal_package
  
