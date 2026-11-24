meta:
  id: amd_atombios
  title: AMD/ATI AtomBIOS video BIOS image
  application:
    - AMD Radeon video BIOS
    - Linux amdgpu/radeon drivers
  file-extension:
    - rom
    - bin
  tags:
    - firmware
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Video BIOS (VBIOS) image of AMD/ATI Radeon graphics cards using
  AtomBIOS (R500 and later). The image is a PCI option ROM (0x55AA
  signature) that, besides x86 code, contains the AtomBIOS ROM header
  pointing to two master tables:

  * the master command table: offsets of command tables, i.e. scripts of
    AtomBIOS bytecode (run by the driver's interpreter) for tasks such as
    ASIC initialisation or clock and display setup;
  * the master data table: offsets of data tables (firmware info, power
    play, VRAM info, display object info, ...).

  The index of each slot in the master tables identifies the table (for
  example command table 0 is ASIC_Init, data table 4 is FirmwareInfo);
  see ATOM_MASTER_LIST_OF_COMMAND_TABLES and ATOM_MASTER_LIST_OF_DATA_TABLES
  in atombios.h (or the atomfirmware.h variants for newer ASICs). Every
  table starts with a common header giving its size and revisions. This
  spec covers the ROM header and the two master tables; table contents are
  exposed as raw bytes (command tables split into their header and
  bytecode).
doc-ref:
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/drivers/gpu/drm/amd/include/atombios.h
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/drivers/gpu/drm/amd/amdgpu/atom.h
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/drivers/gpu/drm/amd/amdgpu/atom.c
seq:
  - id: magic
    contents: [0x55, 0xaa]
    doc: PCI option ROM signature (ATOM_BIOS_MAGIC).
  - id: image_size_blocks
    type: u1
    doc: Size of the option ROM image in 512-byte units.
instances:
  image_size:
    value: image_size_blocks * 512
  ati_magic:
    pos: 0x30
    size: 10
    type: str
    encoding: ASCII
    doc: '" 761295520" in ATI/AMD video BIOSes (ATOM_ATI_MAGIC).'
  ofs_rom_header:
    pos: 0x48
    type: u2
    doc: Offset of the AtomBIOS ROM header (ATOM_ROM_TABLE_PTR).
  rom_header:
    pos: ofs_rom_header
    type: rom_header
types:
  common_table_header:
    -orig-id: ATOM_COMMON_TABLE_HEADER
    seq:
      - id: structure_size
        type: u2
        doc: Size of the whole table in bytes, including this header.
      - id: table_format_revision
        type: u1
      - id: table_content_revision
        type: u1
  rom_header:
    -orig-id: ATOM_ROM_HEADER
    seq:
      - id: header
        type: common_table_header
      - id: firmware_signature
        contents: ATOM
      - id: bios_runtime_segment_address
        type: u2
      - id: ofs_protected_mode_info
        type: u2
      - id: ofs_config_filename
        type: u2
        doc: Offset of the configuration file name (ATOM_ROM_CFG_PTR).
      - id: ofs_crc_block
        type: u2
      - id: ofs_bios_bootup_message
        type: u2
        doc: Offset of the boot-up message (ATOM_ROM_MSG_PTR).
      - id: ofs_int10
        type: u2
      - id: pci_bus_dev_init_code
        type: u2
      - id: io_base_address
        type: u2
      - id: subsystem_vendor_id
        type: u2
      - id: subsystem_id
        type: u2
      - id: ofs_pci_info
        type: u2
      - id: ofs_master_command_table
        type: u2
      - id: ofs_master_data_table
        type: u2
      - id: extended_function_code
        type: u1
      - id: reserved
        type: u1
      - id: ofs_psp_dir_table
        type: u4
        if: header.structure_size >= 40
        doc: Offset of the PSP directory table (ATOM_ROM_HEADER_V2_1).
    instances:
      config_filename:
        io: _root._io
        pos: ofs_config_filename
        type: strz
        encoding: ASCII
        if: ofs_config_filename != 0
      bios_bootup_message:
        io: _root._io
        pos: ofs_bios_bootup_message
        type: strz
        encoding: ASCII
        if: ofs_bios_bootup_message != 0
      master_command_table:
        io: _root._io
        pos: ofs_master_command_table
        type: master_table(true)
      master_data_table:
        io: _root._io
        pos: ofs_master_data_table
        type: master_table(false)
  master_table:
    doc: ATOM_MASTER_COMMAND_TABLE or ATOM_MASTER_DATA_TABLE.
    params:
      - id: is_command
        type: bool
    seq:
      - id: header
        type: common_table_header
      - id: tables
        type: table_slot
        repeat: expr
        repeat-expr: (header.structure_size - 4) / 2
  table_slot:
    seq:
      - id: ofs_table
        type: u2
        doc: Offset of the table in the image; 0 if not present.
    instances:
      table:
        io: _root._io
        pos: ofs_table
        type: atom_table(_parent.is_command)
        if: ofs_table != 0
  atom_table:
    params:
      - id: is_command
        type: bool
    seq:
      - id: header
        type: common_table_header
      - id: work_space_size
        type: u1
        if: is_command
        doc: Size of the work space (ATOM_CT_WS_PTR), in 32-bit units.
      - id: parameter_space_size_raw
        type: u1
        if: is_command
        doc: Bits 0-6 are the size of the parameter space (ATOM_CT_PS_PTR), in bytes.
      - id: code
        size: header.structure_size - 6
        if: is_command
        doc: AtomBIOS bytecode.
      - id: data
        size: header.structure_size - 4
        if: not is_command
        doc: Table data; its layout depends on the slot and revisions.
    instances:
      parameter_space_size:
        value: parameter_space_size_raw & 0x7f
        if: is_command
