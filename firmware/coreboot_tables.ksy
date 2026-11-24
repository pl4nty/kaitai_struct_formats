meta:
  id: coreboot_tables
  title: coreboot tables (LBIO)
  application: coreboot
  license: CC0-1.0
  ks-version: '0.11'
  encoding: ASCII
  endian: le
doc: |
  The coreboot tables (also known as "LinuxBIOS tables", hence the `LBIO`
  signature) are the main interface by which coreboot firmware passes
  information about the machine (memory map, consoles, framebuffer, build
  strings, pointers to CBMEM areas etc.) to the payload or operating system.

  coreboot builds the table at run time in RAM (inside CBMEM, with a small
  forwarding table in low memory on x86). A dump of that memory region, starting
  at the `LBIO` signature, can be parsed with this spec. The CMOS option table
  (`cmos_layout.bin` in CBFS) uses the same record framing and is copied
  verbatim into the coreboot table as an `lb_tag::cmos_option_table` record.

  The table consists of a 24-byte header followed by `header.table_entries`
  records. Each record starts with a common `tag` + `size` pair, so unknown
  records can be skipped. Record sizes are always a multiple of 4. 64-bit fields
  are only 4-byte aligned (`lb_uint64_t`).

  The two checksums (`header_checksum`, over the 24-byte header with that field
  included so that the result is 0, and `table_checksum`, over all records) are
  the 16-bit one's complement Internet checksum (`ipchksum`, RFC 1071) and are
  not verified here.

  The fields are stored in the native byte order of the platform; all
  architectures that coreboot runs payloads on in practice are little-endian,
  which is what this spec assumes.

  An `lb_tag::forward` record holds the physical address of another coreboot
  table, which the payload should parse instead; this cannot be followed in a
  file dump.
doc-ref:
  - https://github.com/coreboot/coreboot/blob/main/src/commonlib/include/commonlib/coreboot_tables.h
  - https://github.com/coreboot/coreboot/blob/main/src/lib/coreboot_table.c
  - https://github.com/coreboot/coreboot/blob/main/payloads/libpayload/libc/coreboot.c
seq:
  - id: header
    type: header
  - id: header_extra
    size: header.header_bytes - 24
    doc: Reserved for future header fields; currently always empty.
  - id: records
    type: record
    repeat: expr
    repeat-expr: header.table_entries
types:
  header:
    -orig-id: lb_header
    seq:
      - id: signature
        contents: LBIO
      - id: header_bytes
        type: u4
        valid:
          min: 24
        doc: Size of this header, always 24 at present.
      - id: header_checksum
        type: u4
      - id: table_bytes
        type: u4
        doc: Total size of all records following the header.
      - id: table_checksum
        type: u4
      - id: table_entries
        type: u4
        doc: Number of records following the header.
  record:
    -orig-id: lb_record
    seq:
      - id: tag
        type: u4
        enum: lb_tag
      - id: size
        type: u4
        valid:
          min: 8
        doc: Size of the whole record, including `tag` and `size`.
      - id: body
        size: size - 8
        type:
          switch-on: tag
          cases:
            lb_tag::memory: lb_memory
            lb_tag::hwrpb: lb_u64_value
            lb_tag::mainboard: lb_mainboard
            lb_tag::version: lb_string
            lb_tag::extra_version: lb_string
            lb_tag::build: lb_string
            lb_tag::compile_time: lb_string
            lb_tag::compile_by: lb_string
            lb_tag::compile_host: lb_string
            lb_tag::compile_domain: lb_string
            lb_tag::compiler: lb_string
            lb_tag::linker: lb_string
            lb_tag::assembler: lb_string
            lb_tag::serialno: lb_string
            lb_tag::platform_blob_version: lb_string
            lb_tag::serial: lb_serial
            lb_tag::console: lb_console
            lb_tag::forward: lb_u64_value
            lb_tag::framebuffer: lb_framebuffer
            lb_tag::gpio: lb_gpios
            lb_tag::timestamps: lb_u64_value
            lb_tag::cbmem_console: lb_u64_value
            lb_tag::acpi_gnvs: lb_u64_value
            lb_tag::acpi_cnvs: lb_u64_value
            lb_tag::vpd: lb_u64_value
            lb_tag::wifi_calibration: lb_u64_value
            lb_tag::tpm_cb_log: lb_u64_value
            lb_tag::fmap: lb_u64_value
            lb_tag::vboot_workbuf: lb_u64_value
            lb_tag::type_c_info: lb_u64_value
            lb_tag::root_bridge_info: lb_u64_value
            lb_tag::pcie: lb_u64_value
            lb_tag::acpi_rsdp: lb_u64_value
            lb_tag::vbnv: lb_range
            lb_tag::ram_oops: lb_range
            lb_tag::mtc: lb_range
            lb_tag::version_timestamp: lb_u4_value
            lb_tag::x86_rom_mtrr: lb_u4_value
            lb_tag::tsc_info: lb_u4_value
            lb_tag::mmc_info: lb_mmc_info
            lb_tag::spi_flash: lb_spi_flash
            lb_tag::boot_media_params: lb_boot_media_params
            lb_tag::cbmem_entry: lb_cbmem_entry
            lb_tag::mac_addrs: lb_macs
            lb_tag::board_config: lb_board_config
            lb_tag::smmstorev2: lb_smmstorev2
            lb_tag::tpm_ppi_handoff: lb_tpm_physical_presence
            lb_tag::efi_fw_info: lb_efi_fw_info
            lb_tag::boot_mode: lb_boot_mode
            lb_tag::boot_reason: lb_boot_reason
            lb_tag::cmos_option_table: cmos_option_table
            lb_tag::option: cmos_entry
            lb_tag::option_enum: cmos_enum
            lb_tag::option_defaults: cmos_defaults
            lb_tag::option_checksum: cmos_checksum
  lb_u64_value:
    doc: |
      Body of records holding a single 64-bit value: a physical address
      (`lb_cbmem_ref`, `lb_forward`, `lb_acpi_rsdp`, `lb_pcie`) or
      the Alpha HWRPB pointer (`lb_hwrpb`).
    seq:
      - id: value
        type: u8
  lb_u4_value:
    doc: |
      Body of records holding a single 32-bit value: `lb_timestamp`
      (`timestamp`), `lb_x86_rom_mtrr` (variable MTRR `index` covering the ROM)
      or `lb_tsc_info` (`freq_khz`).
    seq:
      - id: value
        type: u4
  lb_memory:
    seq:
      - id: map
        type: lb_memory_range
        repeat: eos
  lb_memory_range:
    seq:
      - id: start
        type: u8
      - id: size
        type: u8
      - id: type
        type: u4
        enum: mem_type
  lb_mainboard:
    seq:
      - id: vendor_idx
        type: u1
      - id: part_number_idx
        type: u1
      - id: strings
        size-eos: true
    instances:
      vendor:
        pos: 2 + vendor_idx
        type: strz
      part_number:
        pos: 2 + part_number_idx
        type: strz
  lb_string:
    seq:
      - id: string
        type: strz
        doc: NUL-terminated, padded with zeros to a multiple of 4.
  lb_serial:
    seq:
      - id: type
        type: u4
        enum: serial_type
      - id: baseaddr_deprecated
        type: u4
        doc: 32-bit base address; zero when the address doesn't fit into 32 bits.
      - id: baud
        type: u4
      - id: regwidth
        type: u4
      - id: input_hertz
        type: u4
        doc: Input frequency of the chip containing the UART.
      - id: baseaddr
        type: u8
        if: not _io.eof
        doc: 64-bit base address; only present in newer tables.
  lb_console:
    seq:
      - id: type
        type: u2
        enum: console_type
      - id: pad
        size: 2
  lb_framebuffer:
    seq:
      - id: physical_address
        type: u8
      - id: x_resolution
        type: u4
      - id: y_resolution
        type: u4
      - id: bytes_per_line
        type: u4
      - id: bits_per_pixel
        type: u1
      - id: red_mask_pos
        type: u1
      - id: red_mask_size
        type: u1
      - id: green_mask_pos
        type: u1
      - id: green_mask_size
        type: u1
      - id: blue_mask_pos
        type: u1
      - id: blue_mask_size
        type: u1
      - id: reserved_mask_pos
        type: u1
      - id: reserved_mask_size
        type: u1
      - id: orientation
        type: u1
        enum: fb_orientation
        if: not _io.eof
      - id: flags
        type: u1
        if: not _io.eof
        doc: Bit 0 - has external display, bit 1 - has dual pipe.
  lb_gpios:
    seq:
      - id: num_gpios
        -orig-id: count
        type: u4
      - id: gpios
        type: lb_gpio
        repeat: expr
        repeat-expr: num_gpios
  lb_gpio:
    seq:
      - id: port
        type: u4
      - id: polarity
        type: u4
        doc: 0 - active low, 1 - active high.
      - id: value
        type: u4
      - id: name
        size: 16
        type: strz
  lb_range:
    doc: Used by the VBNV, RAM oops and MTC records.
    seq:
      - id: range_start
        type: u8
      - id: range_size
        type: u4
  lb_mmc_info:
    seq:
      - id: early_cmd1_status
        type: s4
        doc: 1 if the firmware successfully sent CMD0 and CMD1 to the card.
  lb_spi_flash:
    seq:
      - id: flash_size
        type: u4
      - id: sector_size
        type: u4
      - id: erase_cmd
        type: u1
      - id: flags
        type: u1
        doc: Bit 0 - flash is in 4-byte address mode.
      - id: reserved
        type: u2
      - id: num_mmap_windows
        -orig-id: mmap_count
        type: u4
        if: not _io.eof
      - id: mmap_windows
        -orig-id: mmap_table
        type: flash_mmap_window
        repeat: expr
        repeat-expr: num_mmap_windows
        if: not _io.eof
  flash_mmap_window:
    seq:
      - id: flash_base
        type: u4
      - id: host_base
        type: u4
      - id: size
        type: u4
  lb_boot_media_params:
    doc: Offsets are relative to the start of the boot media.
    seq:
      - id: fmap_offset
        type: u8
      - id: cbfs_offset
        type: u8
      - id: cbfs_size
        type: u8
      - id: boot_media_size
        type: u8
  lb_cbmem_entry:
    doc: There is one such record per CBMEM entry.
    seq:
      - id: address
        type: u8
      - id: entry_size
        type: u4
      - id: id
        type: u4
        doc: CBMEM ID (see `commonlib/bsd/cbmem_id.h`).
  lb_macs:
    seq:
      - id: num_mac_addrs
        -orig-id: count
        type: u4
      - id: mac_addrs
        type: mac_address
        repeat: expr
        repeat-expr: num_mac_addrs
  mac_address:
    seq:
      - id: mac_addr
        size: 6
      - id: pad
        size: 2
  lb_board_config:
    seq:
      - id: fw_config
        type: u8
      - id: board_id
        type: u4
      - id: ram_code
        type: u4
      - id: sku_id
        type: u4
      - id: fw_config_override_mask
        type: u8
        if: not _io.eof
  lb_smmstorev2:
    seq:
      - id: num_blocks
        type: u4
      - id: block_size
        type: u4
      - id: mmap_addr_deprecated
        type: u4
      - id: com_buffer
        type: u4
      - id: com_buffer_size
        type: u4
      - id: apm_cmd
        type: u1
      - id: unused
        size: 3
      - id: mmap_addr
        type: u8
        if: not _io.eof
  lb_tpm_physical_presence:
    seq:
      - id: ppi_address
        type: u4
      - id: tpm_version
        type: u1
        doc: 1 - TPM 1.2, 2 - TPM 2.0.
      - id: ppi_version
        type: u1
        doc: BCD-encoded PPI interface version.
      - id: pad
        size: 2
  lb_efi_fw_info:
    seq:
      - id: guid
        size: 16
        doc: Firmware class GUID.
      - id: version
        type: u4
      - id: lowest_supported_version
        type: u4
      - id: fw_size
        type: u4
  lb_boot_mode:
    seq:
      - id: boot_mode
        type: u4
        enum: boot_mode
  lb_boot_reason:
    seq:
      - id: boot_reason
        type: u4
        doc: 0 - unknown, 1 - watchdog.
  cmos_option_table:
    doc: |
      CMOS layout table. Its `size` covers the whole table including the nested
      `cmos_entry`, `cmos_enum` and `cmos_defaults` records that follow the
      header.
    seq:
      - id: header_length
        type: u4
        doc: Length of the header (`tag` + `size` + `header_length`), i.e. 12.
      - id: header_extra
        size: header_length - 12
      - id: records
        type: record
        repeat: eos
  cmos_entry:
    seq:
      - id: bit
        type: u4
        doc: Starting bit from the start of the CMOS image.
      - id: length
        type: u4
        doc: Length of the field in bits.
      - id: config
        type: u4
        doc: "`e` - enumeration, `h` - hex, `r` - reserved, `s` - string."
      - id: config_id
        type: u4
        doc: Links to the `cmos_enum` records with the same `config_id`.
      - id: name
        size-eos: true
        type: strz
  cmos_enum:
    seq:
      - id: config_id
        type: u4
      - id: value
        type: u4
      - id: text
        size-eos: true
        type: strz
  cmos_defaults:
    seq:
      - id: name_length
        type: u4
      - id: name
        size: 32
        type: strz
      - id: default_set
        size: 256
  cmos_checksum:
    doc: All positions are in bits but byte-aligned.
    seq:
      - id: range_start
        type: u4
      - id: range_end
        type: u4
      - id: location
        type: u4
      - id: type
        type: u4
        doc: 0 - none, 1 - PC BIOS (16-bit sum).
enums:
  lb_tag:
    0x00: unused
    0x01: memory
    0x02: hwrpb
    0x03: mainboard
    0x04: version
    0x05: extra_version
    0x06: build
    0x07: compile_time
    0x08: compile_by
    0x09: compile_host
    0x0a: compile_domain
    0x0b: compiler
    0x0c: linker
    0x0d: assembler
    0x0f: serial
    0x10: console
    0x11: forward
    0x12: framebuffer
    0x13: gpio
    0x16: timestamps
    0x17: cbmem_console
    0x18: mrc_cache
    0x19: vbnv
    0x20:
      id: vboot_handoff
      doc: Deprecated.
    0x21: x86_rom_mtrr
    0x22: dma
    0x23: ram_oops
    0x24: acpi_gnvs
    0x25:
      id: board_id
      doc: Deprecated.
    0x26: version_timestamp
    0x27: wifi_calibration
    0x28:
      id: ram_code
      doc: Deprecated.
    0x29: spi_flash
    0x2a: serialno
    0x2b: mtc
    0x2c: vpd
    0x2d:
      id: sku_id
      doc: Deprecated.
    0x30: boot_media_params
    0x31: cbmem_entry
    0x32: tsc_info
    0x33: mac_addrs
    0x34: vboot_workbuf
    0x35: mmc_info
    0x36: tpm_cb_log
    0x37: fmap
    0x38: platform_blob_version
    0x39: smmstorev2
    0x3a: tpm_ppi_handoff
    0x40: board_config
    0x41: acpi_cnvs
    0x42: type_c_info
    0x43: acpi_rsdp
    0x44: pcie
    0x45: efi_fw_info
    0x46: capsule
    0x47: cfr_root
    0x48: root_bridge_info
    0x49: panel_poweroff
    0x4a: sdhci_nonpci
    0x4b: boot_reason
    0xc8: cmos_option_table
    0xc9: option
    0xca: option_enum
    0xcb: option_defaults
    0xcc: option_checksum
    0xcd: boot_mode
  mem_type:
    1: ram
    2: reserved
    3: acpi
    4: nvs
    5: unusable
    6: vendor_rsvd
    16: table
    17:
      id: tag
      doc: Armv9 tag storage for MTE.
    0xefffffff:
      id: soft_reserved
      doc: Specific purpose memory.
  serial_type:
    1: io_mapped
    2: memory_mapped
  console_type:
    0: serial8250
    1: vga
    2: btext
    3: logbuf
    4: srom
    5: ehci
    6: serial8250mem
  fb_orientation:
    0: normal
    1: bottom_up
    2: left_up
    3: right_up
  boot_mode:
    0: normal
    1: low_battery
    2: low_battery_charging
    3: offmode_charging
    4: rtc_wake
    5: no_battery
    6: flash_update
