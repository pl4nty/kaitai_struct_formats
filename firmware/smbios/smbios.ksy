meta:
  id: smbios
  title: SMBIOS structure table
  license: CC0-1.0
  ks-version: '0.11'
  encoding: UTF-8
  endian: le
  bit-endian: le
doc: |
  SMBIOS (System Management BIOS) is the standard way for the firmware of a
  computer to tell the operating system what hardware it runs on: vendor,
  model and serial numbers, processors, caches, memory modules, slots, ports,
  sensors, power supplies and so on. The data that `dmidecode` prints comes
  from this table.

  This spec describes the structure table itself, as DSP0134 3.10.0 defines
  it: a packed sequence of structures that normally ends with one of type
  127 (end of table). Linux exposes it as `/sys/firmware/dmi/tables/DMI`.
  The entry point (`_SM_`, `_SM3_` or `_DMI_` anchor) that tells where the
  table is in memory is described by `smbios_entry_point`; a file written by
  `dmidecode --dump-bin` starts with a copy of the entry point and has the
  table at offset 0x20.

  Every structure consists of a 4-byte header, a formatted area whose length
  depends on the version of the standard the firmware follows, and a set of
  strings that fields of the formatted area refer to by number. Fields that
  later versions of the standard added at the end of a formatted area are
  only present if the formatted area is long enough, and are null otherwise;
  bytes that a newer version adds after the last field known here are left
  unparsed. Structure types 128 to 255 are OEM-specific and are not parsed.

  Bit numbers in the docs are counted from the least significant bit.
doc-ref:
  - https://www.dmtf.org/standards/smbios
  - https://www.dmtf.org/sites/default/files/standards/documents/DSP0134_3.10.0.pdf
seq:
  - id: structures
    type: structure
    repeat: until
    repeat-until: _.type == structure_type::end_of_table or _.len_formatted_area < 4 or _io.eof
    doc: |
      Ends at the end-of-table structure, at the end of the input, or at a
      structure shorter than its header (e.g. zero padding after the table).
types:
  structure:
    seq:
      - id: type
        type: u1
        enum: structure_type
      - id: len_formatted_area
        type: u1
        doc: |
          Length of the formatted area in bytes, counted from the start of
          the structure, i.e. including `type`, this field and `handle`.
      - id: handle
        type: u2
        doc: |
          Number that other structures use to refer to this one. 0xffff in
          a handle field elsewhere means "no structure".
      - id: formatted_area
        size: len_formatted_area - 4
        type:
          switch-on: type
          cases:
            'structure_type::platform_firmware_information': platform_firmware_information
            'structure_type::system_information': system_information
            'structure_type::baseboard_information': baseboard_information
            'structure_type::system_enclosure': system_enclosure
            'structure_type::processor_information': processor_information
            'structure_type::memory_controller_information': memory_controller_information
            'structure_type::memory_module_information': memory_module_information
            'structure_type::cache_information': cache_information
            'structure_type::port_connector_information': port_connector_information
            'structure_type::system_slots': system_slots
            'structure_type::on_board_devices_information': on_board_devices_information
            'structure_type::oem_strings': string_count
            'structure_type::system_configuration_options': string_count
            'structure_type::firmware_language_information': firmware_language_information
            'structure_type::group_associations': group_associations
            'structure_type::system_event_log': system_event_log
            'structure_type::physical_memory_array': physical_memory_array
            'structure_type::memory_device': memory_device
            'structure_type::memory_error_information_32': memory_error_information_32
            'structure_type::memory_array_mapped_address': memory_array_mapped_address
            'structure_type::memory_device_mapped_address': memory_device_mapped_address
            'structure_type::built_in_pointing_device': built_in_pointing_device
            'structure_type::portable_battery': portable_battery
            'structure_type::system_reset': system_reset
            'structure_type::hardware_security': hardware_security
            'structure_type::system_power_controls': system_power_controls
            'structure_type::voltage_probe': voltage_probe
            'structure_type::cooling_device': cooling_device
            'structure_type::temperature_probe': temperature_probe
            'structure_type::electrical_current_probe': electrical_current_probe
            'structure_type::out_of_band_remote_access': out_of_band_remote_access
            'structure_type::system_boot_information': system_boot_information
            'structure_type::memory_error_information_64': memory_error_information_64
            'structure_type::management_device': management_device
            'structure_type::management_device_component': management_device_component
            'structure_type::management_device_threshold_data': management_device_threshold_data
            'structure_type::memory_channel': memory_channel
            'structure_type::ipmi_device_information': ipmi_device_information
            'structure_type::system_power_supply': system_power_supply
            'structure_type::additional_information': additional_information
            'structure_type::onboard_devices_extended_information': onboard_devices_extended_information
            'structure_type::management_controller_host_interface': management_controller_host_interface
            'structure_type::tpm_device': tpm_device
            'structure_type::processor_additional_information': processor_additional_information
            'structure_type::firmware_inventory_information': firmware_inventory_information
            'structure_type::string_property': string_property
        if: len_formatted_area >= 4
      - id: strings
        type: strz
        repeat: until
        repeat-until: _ == ""
        if: len_formatted_area >= 4
        doc: |
          Strings of the structure, followed by an empty one that ends the
          list. A string field of the formatted area holds the number of
          its string, starting at 1, or 0 if it has none.
      - id: terminator
        contents: [0]
        if: len_formatted_area >= 4 and strings.size == 1
        doc: |
          A structure without strings still ends in two zero bytes; this is
          the second one.
  string_ref:
    doc: Number of a string of the structure, 0 if the field has none.
    params:
      - id: owner
        type: structure
        doc: The structure whose strings the number refers to.
    seq:
      - id: index
        type: u1
    instances:
      value:
        value: owner.strings[index - 1]
        if: index != 0 and index < owner.strings.size
  pci_address:
    doc: |
      PCI segment group, bus, device and function. Devices that are not on
      a PCI-like bus have 0xffff, 0xff and 0xff here.
    seq:
      - id: segment_group_number
        type: u2
      - id: bus_number
        type: u1
      - id: function_number
        type: b3
      - id: device_number
        type: b5
  platform_firmware_information:
    doc: Type 0, called BIOS information before version 3.8.
    seq:
      - id: vendor
        type: string_ref(_parent)
      - id: firmware_version
        type: string_ref(_parent)
      - id: starting_address_segment
        type: u2
        doc: |
          Segment of the BIOS starting address, e.g. 0xe800; the runtime
          image takes `(0x10000 - starting_address_segment) * 16` bytes.
          0 if it does not apply, e.g. on UEFI systems.
      - id: release_date
        type: string_ref(_parent)
        doc: In mm/dd/yyyy format (mm/dd/yy before version 2.3).
      - id: rom_size
        type: u1
        doc: |
          Size of the ROM is `(rom_size + 1) * 64` KiB; 0xff means that it is
          16 MiB or more and given in `extended_rom_size`.
      - id: characteristics
        type: firmware_characteristics
      - id: characteristics_ext1
        type: firmware_characteristics_ext1
        if: not _io.eof
      - id: characteristics_ext2
        type: firmware_characteristics_ext2
        if: not _io.eof
      - id: platform_firmware_major_release
        type: u1
        if: not _io.eof
        doc: 0xff, as is the minor release, if not supported.
      - id: platform_firmware_minor_release
        type: u1
        if: not _io.eof
      - id: embedded_controller_firmware_major_release
        type: u1
        if: not _io.eof
        doc: 0xff if the embedded controller firmware cannot be upgraded.
      - id: embedded_controller_firmware_minor_release
        type: u1
        if: not _io.eof
      - id: extended_rom_size
        type: extended_rom_size
        if: not _io.eof
  firmware_characteristics:
    seq:
      - id: reserved0
        type: b2
      - id: unknown
        type: b1
      - id: not_supported
        type: b1
      - id: isa
        type: b1
      - id: mca
        type: b1
      - id: eisa
        type: b1
      - id: pci
        type: b1
      - id: pcmcia
        type: b1
      - id: plug_and_play
        type: b1
      - id: apm
        type: b1
      - id: upgradeable
        type: b1
        doc: Firmware is in flash and can be upgraded.
      - id: shadowing_allowed
        type: b1
      - id: vl_vesa
        type: b1
      - id: escd
        type: b1
      - id: boot_from_cd
        type: b1
      - id: selectable_boot
        type: b1
      - id: rom_socketed
        type: b1
      - id: boot_from_pcmcia
        type: b1
      - id: edd
        type: b1
        doc: Enhanced Disk Drive specification is supported.
      - id: int13_nec_9800_floppy
        type: b1
        doc: Japanese floppy for NEC 9800 1.2 MB (3.5", 1K bytes/sector).
      - id: int13_toshiba_floppy
        type: b1
        doc: Japanese floppy for Toshiba 1.2 MB (3.5", 360 RPM).
      - id: int13_floppy_525_360k
        type: b1
      - id: int13_floppy_525_1200k
        type: b1
      - id: int13_floppy_35_720k
        type: b1
      - id: int13_floppy_35_2880k
        type: b1
      - id: int5_print_screen
        type: b1
      - id: int9_8042_keyboard
        type: b1
      - id: int14_serial
        type: b1
      - id: int17_printer
        type: b1
      - id: int10_cga_mono_video
        type: b1
      - id: nec_pc_98
        type: b1
      - id: firmware_vendor_reserved
        type: b16
      - id: system_vendor_reserved
        type: b16
  firmware_characteristics_ext1:
    seq:
      - id: acpi
        type: b1
      - id: usb_legacy
        type: b1
      - id: agp
        type: b1
      - id: i2o_boot
        type: b1
      - id: ls120_boot
        type: b1
      - id: atapi_zip_boot
        type: b1
      - id: ieee1394_boot
        type: b1
      - id: smart_battery
        type: b1
  firmware_characteristics_ext2:
    seq:
      - id: bios_boot_specification
        type: b1
      - id: function_key_network_boot
        type: b1
      - id: targeted_content_distribution
        type: b1
      - id: uefi
        type: b1
      - id: virtual_machine
        type: b1
        doc: |
          The table describes a virtual machine; if clear, nothing can be
          inferred.
      - id: manufacturing_mode_supported
        type: b1
      - id: manufacturing_mode_enabled
        type: b1
      - id: reserved
        type: b1
  extended_rom_size:
    seq:
      - id: size
        type: b14
      - id: unit
        type: b2
        enum: extended_rom_size_unit
  system_information:
    doc: Type 1.
    seq:
      - id: manufacturer
        type: string_ref(_parent)
      - id: product_name
        type: string_ref(_parent)
      - id: version
        type: string_ref(_parent)
      - id: serial_number
        type: string_ref(_parent)
      - id: uuid
        type: system_uuid
        if: not _io.eof
      - id: wake_up_type
        type: u1
        enum: wake_up_type
        if: not _io.eof
      - id: sku_number
        type: string_ref(_parent)
        if: not _io.eof
      - id: family
        type: string_ref(_parent)
        if: not _io.eof
  system_uuid:
    doc: |
      UUID of the system. The first three fields are little-endian, unlike
      RFC 4122, so {00112233-4455-6677-8899-AABBCCDDEEFF} is stored as
      33 22 11 00 55 44 77 66 88 99 AA BB CC DD EE FF. All 0xff bytes mean
      that the UUID is not set but can be; all zero bytes mean that there is
      none.
    seq:
      - id: time_low
        type: u4
      - id: time_mid
        type: u2
      - id: time_hi_and_version
        type: u2
      - id: clock_seq_hi_and_reserved
        type: u1
      - id: clock_seq_low
        type: u1
      - id: node
        size: 6
  baseboard_information:
    doc: Type 2.
    seq:
      - id: manufacturer
        type: string_ref(_parent)
      - id: product
        type: string_ref(_parent)
      - id: version
        type: string_ref(_parent)
      - id: serial_number
        type: string_ref(_parent)
      - id: asset_tag
        type: string_ref(_parent)
        if: not _io.eof
      - id: feature_flags
        type: baseboard_feature_flags
        if: not _io.eof
      - id: location_in_chassis
        type: string_ref(_parent)
        if: not _io.eof
      - id: chassis_handle
        type: u2
        if: not _io.eof
      - id: board_type
        type: u1
        enum: board_type
        if: not _io.eof
      - id: num_contained_object_handles
        type: u1
        if: not _io.eof
      - id: contained_object_handles
        type: u2
        repeat: expr
        repeat-expr: num_contained_object_handles
        if: not _io.eof
        doc: |
          Handles of structures (processors, slots, memory devices and so
          on) on this board.
  baseboard_feature_flags:
    seq:
      - id: hosting_board
        type: b1
        doc: Set if the board is a hosting board, e.g. a motherboard.
      - id: requires_daughter_board
        type: b1
      - id: removable
        type: b1
      - id: replaceable
        type: b1
      - id: hot_swappable
        type: b1
      - id: reserved
        type: b3
  system_enclosure:
    doc: Type 3, system enclosure or chassis.
    seq:
      - id: manufacturer
        type: string_ref(_parent)
      - id: enclosure_type
        type: b7
        enum: chassis_type
      - id: lock_present
        type: b1
      - id: version
        type: string_ref(_parent)
      - id: serial_number
        type: string_ref(_parent)
      - id: asset_tag_number
        type: string_ref(_parent)
      - id: boot_up_state
        type: u1
        enum: chassis_state
        if: not _io.eof
      - id: power_supply_state
        type: u1
        enum: chassis_state
        if: not _io.eof
      - id: thermal_state
        type: u1
        enum: chassis_state
        if: not _io.eof
      - id: security_status
        type: u1
        enum: chassis_security_status
        if: not _io.eof
      - id: oem_defined
        type: u4
        if: not _io.eof
      - id: height
        type: u1
        if: not _io.eof
        doc: |
          Height in rack units (1.75 in); 0 if unspecified, 0xff if given in
          `rack_height`.
      - id: num_power_cords
        type: u1
        if: not _io.eof
        doc: 0 if unspecified.
      - id: num_contained_elements
        type: u1
        if: not _io.eof
      - id: len_contained_element
        type: u1
        if: not _io.eof
      - id: contained_elements
        size: len_contained_element.as<u4>
        type: contained_element
        repeat: expr
        repeat-expr: num_contained_elements
        if: not _io.eof
      - id: sku_number
        type: string_ref(_parent)
        if: not _io.eof
      - id: rack_type
        type: u1
        enum: rack_type
        if: not _io.eof
      - id: rack_height
        type: u1
        if: not _io.eof
        doc: Height of the enclosure in the units of `rack_type`.
  contained_element:
    seq:
      - id: element_type
        type: b7
        doc: |
          A `board_type` if `is_structure_type` is clear, a
          `structure_type` if it is set.
      - id: is_structure_type
        type: b1
      - id: minimum
        type: u1
        doc: Number of such elements the chassis needs to operate.
      - id: maximum
        type: u1
        doc: Number of such elements the chassis can hold.
    instances:
      board_type:
        value: element_type
        enum: board_type
        if: not is_structure_type
      structure_type:
        value: element_type
        enum: structure_type
        if: is_structure_type
  processor_information:
    doc: Type 4.
    seq:
      - id: socket_designation
        type: string_ref(_parent)
      - id: processor_type
        type: u1
        enum: processor_type
      - id: processor_family
        type: u1
        enum: processor_family
        doc: |
          `indicator_family_2` means that the family is in
          `processor_family_2`.
      - id: processor_manufacturer
        type: string_ref(_parent)
      - id: processor_id
        size: 8
        doc: |
          Processor-specific identification data. On x86 the EAX and EDX
          values that CPUID returns for leaf 1, on 32-bit Arm the MIDR, on
          64-bit Arm the MIDR_EL1 or (if `arm64_soc_id` is set in the
          characteristics) the SoC ID, JEP-106 code and SoC revision, on
          RISC-V the mvendorid CSR and on LoongArch the CPUCFG word 0.
      - id: processor_version
        type: string_ref(_parent)
      - id: voltage
        type: u1
        doc: |
          Deprecated since version 3.8, 0 if unused. If bit 7 is set, the
          other bits hold the current voltage in tenths of a volt.
          Otherwise bits 0, 1 and 2 are set if the socket accepts 5 V,
          3.3 V and 2.9 V.
      - id: external_clock
        type: u2
        doc: In MHz, 0 if unknown.
      - id: max_speed
        type: u2
        doc: In MHz, 0 if unknown. Capability of the socket, not the processor.
      - id: current_speed
        type: u2
        doc: In MHz, 0 if unknown.
      - id: cpu_status
        type: b3
        enum: cpu_status
      - id: reserved1
        type: b3
      - id: socket_populated
        type: b1
      - id: reserved2
        type: b1
      - id: processor_upgrade
        type: u1
        enum: processor_upgrade
      - id: l1_cache_handle
        type: u2
        if: not _io.eof
        doc: Handle of a cache information structure, 0xffff if there is none.
      - id: l2_cache_handle
        type: u2
        if: not _io.eof
        doc: Handle of a cache information structure, 0xffff if there is none.
      - id: l3_cache_handle
        type: u2
        if: not _io.eof
        doc: Handle of a cache information structure, 0xffff if there is none.
      - id: serial_number
        type: string_ref(_parent)
        if: not _io.eof
      - id: asset_tag
        type: string_ref(_parent)
        if: not _io.eof
      - id: part_number
        type: string_ref(_parent)
        if: not _io.eof
      - id: core_count
        type: u1
        if: not _io.eof
        doc: 0 if unknown, 0xff if the number is in `core_count_2`.
      - id: core_enabled
        type: u1
        if: not _io.eof
        doc: 0 if unknown, 0xff if the number is in `core_enabled_2`.
      - id: thread_count
        type: u1
        if: not _io.eof
        doc: 0 if unknown, 0xff if the number is in `thread_count_2`.
      - id: processor_characteristics
        type: processor_characteristics
        if: not _io.eof
      - id: processor_family_2
        type: u2
        enum: processor_family
        if: not _io.eof
      - id: core_count_2
        type: u2
        if: not _io.eof
        doc: 0 if unknown.
      - id: core_enabled_2
        type: u2
        if: not _io.eof
        doc: 0 if unknown.
      - id: thread_count_2
        type: u2
        if: not _io.eof
        doc: 0 if unknown.
      - id: thread_enabled
        type: u2
        if: not _io.eof
        doc: 0 if unknown.
      - id: socket_type
        type: string_ref(_parent)
        if: not _io.eof
        doc: E.g. "Socket LGA4710"; set if `processor_upgrade` is `other_socket`.
  processor_characteristics:
    seq:
      - id: reserved0
        type: b1
      - id: unknown
        type: b1
      - id: capable_64_bit
        type: b1
      - id: multi_core
        type: b1
      - id: hardware_thread
        type: b1
      - id: execute_protection
        type: b1
      - id: enhanced_virtualization
        type: b1
      - id: power_performance_control
        type: b1
      - id: capable_128_bit
        type: b1
      - id: arm64_soc_id
        type: b1
      - id: reserved1
        type: b6
  memory_controller_information:
    doc: Type 5, obsolete since version 2.1.
    seq:
      - id: error_detecting_method
        type: u1
        enum: error_detecting_method
      - id: error_correcting_capability
        type: error_correcting_capability
      - id: supported_interleave
        type: u1
        enum: interleave_support
      - id: current_interleave
        type: u1
        enum: interleave_support
      - id: max_memory_module_size
        type: u1
        doc: Largest module supported per slot is `2 ** max_memory_module_size` MiB.
      - id: supported_speeds
        type: memory_speeds
      - id: supported_memory_types
        type: memory_module_types
      - id: memory_module_voltage
        type: memory_module_voltage
      - id: num_memory_module_handles
        type: u1
      - id: memory_module_handles
        type: u2
        repeat: expr
        repeat-expr: num_memory_module_handles
      - id: enabled_error_correcting_capabilities
        type: error_correcting_capability
        if: not _io.eof
  error_correcting_capability:
    seq:
      - id: other
        type: b1
      - id: unknown
        type: b1
      - id: none
        type: b1
      - id: single_bit_error_correcting
        type: b1
      - id: double_bit_error_correcting
        type: b1
      - id: error_scrubbing
        type: b1
      - id: reserved
        type: b2
  memory_speeds:
    seq:
      - id: other
        type: b1
      - id: unknown
        type: b1
      - id: speed_70ns
        type: b1
      - id: speed_60ns
        type: b1
      - id: speed_50ns
        type: b1
      - id: reserved
        type: b11
  memory_module_types:
    seq:
      - id: other
        type: b1
      - id: unknown
        type: b1
      - id: standard
        type: b1
      - id: fast_page_mode
        type: b1
      - id: edo
        type: b1
      - id: parity
        type: b1
      - id: ecc
        type: b1
      - id: simm
        type: b1
      - id: dimm
        type: b1
      - id: burst_edo
        type: b1
      - id: sdram
        type: b1
      - id: reserved
        type: b5
  memory_module_voltage:
    seq:
      - id: voltage_5v
        type: b1
      - id: voltage_3v3
        type: b1
      - id: voltage_2v9
        type: b1
      - id: reserved
        type: b5
  memory_module_information:
    doc: Type 6, obsolete since version 2.1.
    seq:
      - id: socket_designation
        type: string_ref(_parent)
      - id: bank_connections
        type: u1
        doc: |
          Each nibble is a bank (RAS#) the socket is connected to, 0xf for
          none; e.g. 0x13 for banks 1 and 3.
      - id: current_speed
        type: u1
        doc: In ns, 0 if unknown.
      - id: current_memory_type
        type: memory_module_types
      - id: installed_size
        type: memory_module_size
      - id: enabled_size
        type: memory_module_size
      - id: uncorrectable_errors
        type: b1
      - id: correctable_errors
        type: b1
      - id: error_status_in_event_log
        type: b1
      - id: reserved
        type: b5
  memory_module_size:
    seq:
      - id: size
        type: b7
        doc: |
          `2 ** size` MiB; 0x7d if not determinable, 0x7e if installed but
          not enabled, 0x7f if not installed.
      - id: double_bank
        type: b1
  cache_information:
    doc: Type 7.
    seq:
      - id: socket_designation
        type: string_ref(_parent)
      - id: level
        type: b3
        doc: Cache level minus 1, i.e. 0 for an L1 cache.
      - id: socketed
        type: b1
      - id: reserved1
        type: b1
      - id: location
        type: b2
        enum: cache_location
      - id: enabled
        type: b1
      - id: operational_mode
        type: b2
        enum: cache_operational_mode
      - id: reserved2
        type: b6
      - id: maximum_cache_size
        type: cache_size
        doc: 0xffff if the size is in `maximum_cache_size_2`.
      - id: installed_size
        type: cache_size
        doc: 0 if no cache is installed.
      - id: supported_sram_type
        type: sram_types
      - id: current_sram_type
        type: sram_types
      - id: cache_speed
        type: u1
        if: not _io.eof
        doc: In ns, 0 if unknown.
      - id: error_correction_type
        type: u1
        enum: cache_error_correction_type
        if: not _io.eof
      - id: system_cache_type
        type: u1
        enum: system_cache_type
        if: not _io.eof
      - id: associativity
        type: u1
        enum: cache_associativity
        if: not _io.eof
      - id: maximum_cache_size_2
        type: cache_size_2
        if: not _io.eof
      - id: installed_cache_size_2
        type: cache_size_2
        if: not _io.eof
  cache_size:
    seq:
      - id: size
        type: b15
      - id: granularity_64k
        type: b1
        doc: Set if `size` is in 64 KiB units, clear if in KiB.
    instances:
      size_kib:
        value: 'granularity_64k ? size * 64 : size'
  cache_size_2:
    seq:
      - id: size
        type: b31
      - id: granularity_64k
        type: b1
        doc: Set if `size` is in 64 KiB units, clear if in KiB.
    instances:
      size_kib:
        value: 'granularity_64k ? size * 64 : size'
  sram_types:
    seq:
      - id: other
        type: b1
      - id: unknown
        type: b1
      - id: non_burst
        type: b1
      - id: burst
        type: b1
      - id: pipeline_burst
        type: b1
      - id: synchronous
        type: b1
      - id: asynchronous
        type: b1
      - id: reserved
        type: b9
  port_connector_information:
    doc: Type 8.
    seq:
      - id: internal_reference_designator
        type: string_ref(_parent)
      - id: internal_connector_type
        type: u1
        enum: connector_type
      - id: external_reference_designator
        type: string_ref(_parent)
      - id: external_connector_type
        type: u1
        enum: connector_type
      - id: port_type
        type: u1
        enum: port_type
  system_slots:
    doc: Type 9.
    seq:
      - id: slot_designation
        type: string_ref(_parent)
      - id: slot_type
        type: u1
        enum: slot_type
      - id: slot_data_bus_width
        type: u1
        enum: slot_width
        doc: Electrical width; the physical width is in `slot_type` or `slot_physical_width`.
      - id: current_usage
        type: u1
        enum: slot_current_usage
      - id: slot_length
        type: u1
        enum: slot_length
      - id: slot_id
        type: u2
        doc: |
          Meaning depends on `slot_type`: the logical slot number for MCA
          and EISA, the ACPI _SUN value or $PIRQ slot number for PCI-like
          slots, and the adapter (low byte) and socket (high byte) numbers
          for PCMCIA.
      - id: slot_characteristics_1
        type: slot_characteristics_1
      - id: slot_characteristics_2
        type: slot_characteristics_2
        if: not _io.eof
      - id: base_address
        type: pci_address
        if: not _io.eof
        doc: Lowest PCI address of the device in the slot.
      - id: base_data_bus_width
        type: u1
        if: not _io.eof
      - id: num_peer_groups
        type: u1
        if: not _io.eof
      - id: peer_groups
        type: slot_peer_group
        repeat: expr
        repeat-expr: num_peer_groups
        if: not _io.eof
      - id: slot_information
        type: u1
        if: not _io.eof
        doc: |
          The PCI Express generation (e.g. 6) for `pci_express_gen6_and_beyond`
          slots, may be set for other PCI Express slots, otherwise 0.
      - id: slot_physical_width
        type: u1
        enum: slot_width
        if: not _io.eof
      - id: slot_pitch
        type: u2
        if: not _io.eof
        doc: In 1/100 mm, 0 if unknown.
      - id: slot_height
        type: u1
        enum: slot_height
        if: not _io.eof
  slot_characteristics_1:
    seq:
      - id: unknown
        type: b1
      - id: provides_5v
        type: b1
      - id: provides_3v3
        type: b1
      - id: shared_opening
        type: b1
      - id: pc_card_16
        type: b1
      - id: cardbus
        type: b1
      - id: zoom_video
        type: b1
      - id: modem_ring_resume
        type: b1
  slot_characteristics_2:
    seq:
      - id: pme
        type: b1
      - id: hot_plug
        type: b1
      - id: smbus
        type: b1
      - id: bifurcation
        type: b1
      - id: async_surprise_removal
        type: b1
      - id: cxl_1_0
        type: b1
      - id: cxl_2_0
        type: b1
      - id: cxl_3_0
        type: b1
  slot_peer_group:
    seq:
      - id: address
        type: pci_address
      - id: data_bus_width
        type: u1
  on_board_devices_information:
    doc: Type 10, obsolete since version 2.6.
    seq:
      - id: devices
        type: on_board_device
        repeat: eos
  on_board_device:
    seq:
      - id: device_type
        type: b7
        enum: onboard_device_type
      - id: enabled
        type: b1
      - id: description
        type: string_ref(_parent._parent)
  string_count:
    doc: |
      Types 11 (OEM strings) and 12 (system configuration options): the
      strings of the structure are its content.
    seq:
      - id: num_strings
        type: u1
  firmware_language_information:
    doc: Type 13.
    seq:
      - id: num_installable_languages
        type: u1
        doc: Number of strings, one per language.
      - id: abbreviated_format
        type: b1
        doc: |
          Set if the strings look like "enUS", clear if like
          "en|US|iso8859-1". Absent (zero) before version 2.1.
      - id: reserved1
        type: b7
      - id: reserved2
        size: 15
      - id: current_language
        type: string_ref(_parent)
  group_associations:
    doc: Type 14.
    seq:
      - id: group_name
        type: string_ref(_parent)
      - id: items
        type: group_item
        repeat: eos
  group_item:
    seq:
      - id: item_type
        type: u1
        enum: structure_type
      - id: item_handle
        type: u2
  system_event_log:
    doc: Type 15.
    seq:
      - id: len_log_area
        type: u2
      - id: ofs_log_header
        type: u2
      - id: ofs_log_data
        type: u2
      - id: access_method
        type: u1
        enum: event_log_access_method
      - id: log_area_valid
        type: b1
      - id: log_area_full
        type: b1
      - id: reserved
        type: b6
      - id: log_change_token
        type: u4
        doc: Changes whenever the log does; 0 if not implemented.
      - id: access_method_address
        type: u4
        doc: |
          For the indexed I/O methods, the index port in the low word and
          the data port in the high word; for `memory_mapped_32` the
          physical address; for `gpnv` the GPNV handle in the low word.
      - id: log_header_format
        type: u1
        enum: event_log_header_format
        if: not _io.eof
      - id: num_supported_log_type_descriptors
        type: u1
        if: not _io.eof
      - id: len_log_type_descriptor
        type: u1
        if: not _io.eof
      - id: supported_log_type_descriptors
        size: len_log_type_descriptor.as<u4>
        type: event_log_type_descriptor
        repeat: expr
        repeat-expr: num_supported_log_type_descriptors
        if: not _io.eof
  event_log_type_descriptor:
    seq:
      - id: log_type
        type: u1
        enum: event_log_type
      - id: variable_data_format_type
        type: u1
        enum: event_log_variable_data_format
  physical_memory_array:
    doc: Type 16.
    seq:
      - id: location
        type: u1
        enum: memory_array_location
      - id: use
        type: u1
        enum: memory_array_use
      - id: memory_error_correction
        type: u1
        enum: memory_array_error_correction
      - id: maximum_capacity
        type: u4
        doc: In KiB; 0x80000000 if given in `extended_maximum_capacity`.
      - id: memory_error_information_handle
        type: u2
        doc: |
          Handle of a memory error information structure; 0xfffe if the
          system does not provide one, 0xffff if there was no error.
      - id: num_memory_devices
        type: u2
      - id: extended_maximum_capacity
        type: u8
        if: not _io.eof
        doc: In bytes.
  memory_device:
    doc: Type 17.
    seq:
      - id: physical_memory_array_handle
        type: u2
      - id: memory_error_information_handle
        type: u2
        doc: |
          Handle of a memory error information structure; 0xfffe if the
          system does not provide one, 0xffff if there was no error.
      - id: total_width
        type: u2
        doc: In bits, including error-correction bits; 0xffff if unknown.
      - id: data_width
        type: u2
        doc: In bits; 0xffff if unknown.
      - id: size
        type: u2
        doc: |
          In MiB, or in KiB if bit 15 is set; 0 if no device is installed,
          0xffff if unknown, 0x7fff if given in `extended_size`.
      - id: form_factor
        type: u1
        enum: memory_form_factor
      - id: device_set
        type: u1
        doc: 0 if not part of a set, 0xff if unknown.
      - id: device_locator
        type: string_ref(_parent)
        doc: E.g. "DIMM 3".
      - id: bank_locator
        type: string_ref(_parent)
      - id: memory_type
        type: u1
        enum: memory_device_type
      - id: type_detail
        type: memory_type_detail
      - id: speed
        type: u2
        if: not _io.eof
        doc: Maximum speed in MT/s; 0 if unknown, 0xffff if given in `extended_speed`.
      - id: manufacturer
        type: string_ref(_parent)
        if: not _io.eof
      - id: serial_number
        type: string_ref(_parent)
        if: not _io.eof
      - id: asset_tag
        type: string_ref(_parent)
        if: not _io.eof
      - id: part_number
        type: string_ref(_parent)
        if: not _io.eof
      - id: rank
        type: b5
        if: not _io.eof
        doc: 0 if unknown.
      - id: disabled_by_error
        type: b1
        if: not _io.eof
      - id: unmapped
        type: b1
        if: not _io.eof
      - id: reserved
        type: b1
        if: not _io.eof
      - id: extended_size
        type: u4
        if: not _io.eof
        doc: In MiB, for devices of 32 GiB - 1 MiB or more; bit 31 is reserved.
      - id: configured_memory_speed
        type: u2
        if: not _io.eof
        doc: |
          In MT/s; 0 if unknown, 0xffff if given in
          `extended_configured_memory_speed`.
      - id: minimum_voltage
        type: u2
        if: not _io.eof
        doc: In mV, 0 if unknown.
      - id: maximum_voltage
        type: u2
        if: not _io.eof
        doc: In mV, 0 if unknown.
      - id: configured_voltage
        type: u2
        if: not _io.eof
        doc: In mV, 0 if unknown.
      - id: memory_technology
        type: u1
        enum: memory_technology
        if: not _io.eof
      - id: memory_operating_mode_capability
        type: memory_operating_mode_capability
        if: not _io.eof
      - id: firmware_version
        type: string_ref(_parent)
        if: not _io.eof
      - id: module_manufacturer_id
        type: u2
        if: not _io.eof
        doc: |
          JEP-106 code from the SPD: the bank (continuation count) in the
          low byte, the code in the high byte; 0 if unknown.
      - id: module_product_id
        type: u2
        if: not _io.eof
        doc: 0 if unknown.
      - id: memory_subsystem_controller_manufacturer_id
        type: u2
        if: not _io.eof
        doc: JEP-106 code from the SPD, as `module_manufacturer_id`.
      - id: memory_subsystem_controller_product_id
        type: u2
        if: not _io.eof
      - id: non_volatile_size
        type: u8
        if: not _io.eof
        doc: In bytes; all bits set if unknown.
      - id: volatile_size
        type: u8
        if: not _io.eof
        doc: In bytes; all bits set if unknown.
      - id: cache_size
        type: u8
        if: not _io.eof
        doc: In bytes; all bits set if unknown.
      - id: logical_size
        type: u8
        if: not _io.eof
        doc: In bytes; all bits set if unknown.
      - id: extended_speed
        type: u4
        if: not _io.eof
        doc: In MT/s; bit 31 is reserved.
      - id: extended_configured_memory_speed
        type: u4
        if: not _io.eof
        doc: In MT/s; bit 31 is reserved.
      - id: pmic0_manufacturer_id
        type: u2
        if: not _io.eof
        doc: JEP-106 code from the SPD, as `module_manufacturer_id`.
      - id: pmic0_revision_number
        type: u2
        if: not _io.eof
        doc: 0xff00 if unknown.
      - id: rcd_manufacturer_id
        type: u2
        if: not _io.eof
        doc: JEP-106 code from the SPD, as `module_manufacturer_id`.
      - id: rcd_revision_number
        type: u2
        if: not _io.eof
        doc: 0xff00 if unknown.
  memory_type_detail:
    seq:
      - id: reserved
        type: b1
      - id: other
        type: b1
      - id: unknown
        type: b1
      - id: fast_paged
        type: b1
      - id: static_column
        type: b1
      - id: pseudo_static
        type: b1
      - id: rambus
        type: b1
      - id: synchronous
        type: b1
      - id: cmos
        type: b1
      - id: edo
        type: b1
      - id: window_dram
        type: b1
      - id: cache_dram
        type: b1
      - id: non_volatile
        type: b1
      - id: registered
        type: b1
      - id: unbuffered
        type: b1
      - id: lrdimm
        type: b1
  memory_operating_mode_capability:
    seq:
      - id: reserved1
        type: b1
      - id: other
        type: b1
      - id: unknown
        type: b1
      - id: volatile_memory
        type: b1
      - id: byte_accessible_persistent_memory
        type: b1
      - id: block_accessible_persistent_memory
        type: b1
      - id: reserved2
        type: b10
  memory_error_information_32:
    doc: Type 18.
    seq:
      - id: error_type
        type: u1
        enum: memory_error_type
      - id: error_granularity
        type: u1
        enum: memory_error_granularity
      - id: error_operation
        type: u1
        enum: memory_error_operation
      - id: vendor_syndrome
        type: u4
        doc: 0 if unknown.
      - id: memory_array_error_address
        type: u4
        doc: 0x80000000 if unknown.
      - id: device_error_address
        type: u4
        doc: 0x80000000 if unknown.
      - id: error_resolution
        type: u4
        doc: In bytes; 0x80000000 if unknown.
  memory_error_information_64:
    doc: Type 33.
    seq:
      - id: error_type
        type: u1
        enum: memory_error_type
      - id: error_granularity
        type: u1
        enum: memory_error_granularity
      - id: error_operation
        type: u1
        enum: memory_error_operation
      - id: vendor_syndrome
        type: u4
        doc: 0 if unknown.
      - id: memory_array_error_address
        type: u8
        doc: 0x8000000000000000 if unknown.
      - id: device_error_address
        type: u8
        doc: 0x8000000000000000 if unknown.
      - id: error_resolution
        type: u4
        doc: In bytes; 0x80000000 if unknown.
  memory_array_mapped_address:
    doc: Type 19.
    seq:
      - id: starting_address
        type: u4
        doc: In KiB; 0xffffffff if given in `extended_starting_address`.
      - id: ending_address
        type: u4
        doc: |
          Address of the last KiB of the range; 0xffffffff if given in
          `extended_ending_address`.
      - id: memory_array_handle
        type: u2
      - id: partition_width
        type: u1
        doc: Number of memory devices that form a row.
      - id: extended_starting_address
        type: u8
        if: not _io.eof
        doc: In bytes.
      - id: extended_ending_address
        type: u8
        if: not _io.eof
        doc: Address of the last byte of the range.
  memory_device_mapped_address:
    doc: Type 20.
    seq:
      - id: starting_address
        type: u4
        doc: In KiB; 0xffffffff if given in `extended_starting_address`.
      - id: ending_address
        type: u4
        doc: |
          Address of the last KiB of the range; 0xffffffff if given in
          `extended_ending_address`.
      - id: memory_device_handle
        type: u2
      - id: memory_array_mapped_address_handle
        type: u2
      - id: partition_row_position
        type: u1
        doc: Position of the device in a row, starting at 1; 0xff if unknown.
      - id: interleave_position
        type: u1
        doc: 0 if not interleaved, 0xff if unknown.
      - id: interleaved_data_depth
        type: u1
        doc: 0 if not interleaved, 0xff if unknown.
      - id: extended_starting_address
        type: u8
        if: not _io.eof
        doc: In bytes.
      - id: extended_ending_address
        type: u8
        if: not _io.eof
        doc: Address of the last byte of the range.
  built_in_pointing_device:
    doc: Type 21.
    seq:
      - id: pointing_device_type
        type: u1
        enum: pointing_device_type
      - id: interface
        type: u1
        enum: pointing_device_interface
      - id: num_buttons
        type: u1
  portable_battery:
    doc: Type 22.
    seq:
      - id: location
        type: string_ref(_parent)
      - id: manufacturer
        type: string_ref(_parent)
      - id: manufacture_date
        type: string_ref(_parent)
        doc: None if given in `sbds_manufacture_date`.
      - id: serial_number
        type: string_ref(_parent)
        doc: None if given in `sbds_serial_number`.
      - id: device_name
        type: string_ref(_parent)
      - id: device_chemistry
        type: u1
        enum: battery_chemistry
        doc: '`unknown` if given in `sbds_device_chemistry`.'
      - id: design_capacity
        type: u2
        doc: In mWh, times `design_capacity_multiplier`; 0 if unknown.
      - id: design_voltage
        type: u2
        doc: In mV, 0 if unknown.
      - id: sbds_version_number
        type: string_ref(_parent)
        doc: Smart Battery Data Specification version.
      - id: maximum_error_in_battery_data
        type: u1
        doc: In percent, 0xff if unknown.
      - id: sbds_serial_number
        type: u2
        if: not _io.eof
      - id: sbds_manufacture_date
        type: sbds_date
        if: not _io.eof
      - id: sbds_device_chemistry
        type: string_ref(_parent)
        if: not _io.eof
        doc: E.g. "PbAc".
      - id: design_capacity_multiplier
        type: u1
        if: not _io.eof
      - id: oem_specific
        type: u4
        if: not _io.eof
  sbds_date:
    seq:
      - id: day
        type: b5
      - id: month
        type: b4
      - id: year_since_1980
        type: b7
  system_reset:
    doc: Type 23, automatic system reset by a watchdog timer.
    seq:
      - id: enabled
        type: b1
        doc: Set if the user enabled the system reset.
      - id: boot_option
        type: b2
        enum: system_reset_boot_option
        doc: What to do after a watchdog reset.
      - id: boot_option_on_limit
        type: b2
        enum: system_reset_boot_option
        doc: What to do when `reset_limit` is reached.
      - id: has_watchdog_timer
        type: b1
      - id: reserved
        type: b2
      - id: reset_count
        type: u2
        doc: Automatic resets since the last intentional one; 0xffff if unknown.
      - id: reset_limit
        type: u2
        doc: 0xffff if unknown.
      - id: timer_interval
        type: u2
        doc: Watchdog timer interval in minutes; 0xffff if unknown.
      - id: timeout
        type: u2
        doc: Minutes before the reboot is initiated; 0xffff if unknown.
  hardware_security:
    doc: Type 24.
    seq:
      - id: front_panel_reset_status
        type: b2
        enum: hardware_security_status
      - id: administrator_password_status
        type: b2
        enum: hardware_security_status
      - id: keyboard_password_status
        type: b2
        enum: hardware_security_status
      - id: power_on_password_status
        type: b2
        enum: hardware_security_status
  system_power_controls:
    doc: |
      Type 25, time of the next scheduled power-on. All fields are BCD; a
      field outside its range (e.g. 0xff) is ignored.
    seq:
      - id: next_scheduled_power_on_month
        type: u1
      - id: next_scheduled_power_on_day_of_month
        type: u1
      - id: next_scheduled_power_on_hour
        type: u1
      - id: next_scheduled_power_on_minute
        type: u1
      - id: next_scheduled_power_on_second
        type: u1
  voltage_probe:
    doc: Type 26. A value of 0x8000 means unknown.
    seq:
      - id: description
        type: string_ref(_parent)
      - id: location
        type: b5
        enum: probe_location
      - id: status
        type: b3
        enum: probe_status
      - id: maximum_value
        type: s2
        doc: In mV.
      - id: minimum_value
        type: s2
        doc: In mV.
      - id: resolution
        type: u2
        doc: In 1/10 mV.
      - id: tolerance
        type: s2
        doc: Plus or minus, in mV.
      - id: accuracy
        type: u2
        doc: Plus or minus, in 1/100 %.
      - id: oem_defined
        type: u4
      - id: nominal_value
        type: s2
        if: not _io.eof
        doc: In mV.
  cooling_device:
    doc: Type 27.
    seq:
      - id: temperature_probe_handle
        type: u2
      - id: device_type
        type: b5
        enum: cooling_device_type
      - id: status
        type: b3
        enum: probe_status
      - id: cooling_unit_group
        type: u1
        doc: |
          Devices with the same non-zero group are redundant; 0 if not part
          of a redundant unit.
      - id: oem_defined
        type: u4
      - id: nominal_speed
        type: u2
        if: not _io.eof
        doc: In rpm; 0x8000 if unknown or not rotating.
      - id: description
        type: string_ref(_parent)
        if: not _io.eof
  temperature_probe:
    doc: Type 28. A value of 0x8000 means unknown.
    seq:
      - id: description
        type: string_ref(_parent)
      - id: location
        type: b5
        enum: probe_location
      - id: status
        type: b3
        enum: probe_status
      - id: maximum_value
        type: s2
        doc: In 1/10 °C.
      - id: minimum_value
        type: s2
        doc: In 1/10 °C.
      - id: resolution
        type: u2
        doc: In 1/1000 °C.
      - id: tolerance
        type: s2
        doc: Plus or minus, in 1/10 °C.
      - id: accuracy
        type: u2
        doc: Plus or minus, in 1/100 %.
      - id: oem_defined
        type: u4
      - id: nominal_value
        type: s2
        if: not _io.eof
        doc: In 1/10 °C.
  electrical_current_probe:
    doc: Type 29. A value of 0x8000 means unknown.
    seq:
      - id: description
        type: string_ref(_parent)
      - id: location
        type: b5
        enum: probe_location
      - id: status
        type: b3
        enum: probe_status
      - id: maximum_value
        type: s2
        doc: In mA.
      - id: minimum_value
        type: s2
        doc: In mA.
      - id: resolution
        type: u2
        doc: In 1/10 mA.
      - id: tolerance
        type: s2
        doc: Plus or minus, in mA.
      - id: accuracy
        type: u2
        doc: Plus or minus, in 1/100 %.
      - id: oem_defined
        type: u4
      - id: nominal_value
        type: s2
        if: not _io.eof
        doc: In mA.
  out_of_band_remote_access:
    doc: Type 30.
    seq:
      - id: manufacturer_name
        type: string_ref(_parent)
      - id: inbound_connection_enabled
        type: b1
      - id: outbound_connection_enabled
        type: b1
      - id: reserved
        type: b6
  system_boot_information:
    doc: Type 32.
    seq:
      - id: reserved
        size: 6
      - id: boot_status
        type: u1
        enum: boot_status
        if: not _io.eof
        doc: |
          128 to 191 are vendor-specific (the vendor is the system
          manufacturer), 192 to 255 product-specific.
      - id: boot_status_data
        size-eos: true
        doc: Additional data, e.g. for `previously_requested_image`.
  management_device:
    doc: Type 34.
    seq:
      - id: description
        type: string_ref(_parent)
      - id: device_type
        type: u1
        enum: management_device_type
      - id: address
        type: u4
      - id: address_type
        type: u1
        enum: management_device_address_type
  management_device_component:
    doc: Type 35.
    seq:
      - id: description
        type: string_ref(_parent)
      - id: management_device_handle
        type: u2
      - id: component_handle
        type: u2
        doc: Handle of the probe or cooling device.
      - id: threshold_handle
        type: u2
        if: not _io.eof
        doc: Handle of a management device threshold data structure.
  management_device_threshold_data:
    doc: |
      Type 36. The unit is that of the component (mV, mA, 1/10 °C or rpm);
      -32768 (0x8000) means unavailable.
    seq:
      - id: lower_threshold_non_critical
        type: s2
      - id: upper_threshold_non_critical
        type: s2
      - id: lower_threshold_critical
        type: s2
      - id: upper_threshold_critical
        type: s2
      - id: lower_threshold_non_recoverable
        type: s2
      - id: upper_threshold_non_recoverable
        type: s2
  memory_channel:
    doc: Type 37.
    seq:
      - id: channel_type
        type: u1
        enum: memory_channel_type
      - id: maximum_channel_load
        type: u1
      - id: num_memory_devices
        type: u1
      - id: memory_devices
        type: memory_channel_device
        repeat: expr
        repeat-expr: num_memory_devices
  memory_channel_device:
    seq:
      - id: load
        type: u1
      - id: handle
        type: u2
  ipmi_device_information:
    doc: Type 38.
    seq:
      - id: interface_type
        type: u1
        enum: ipmi_interface_type
      - id: ipmi_specification_revision_minor
        type: b4
      - id: ipmi_specification_revision_major
        type: b4
      - id: i2c_target_address
        type: u1
        doc: |
          8-bit form of the address (bit 0 is 0); dmidecode shows the 7-bit
          form, e.g. 0x10 for 0x20.
      - id: nv_storage_device_address
        type: u1
        doc: 0xff if there is no storage device.
      - id: base_address
        type: u8
        doc: |
          Memory-mapped or, if bit 0 is set, I/O address of the BMC. The
          real bit 0 is `address_lsb`.
      - id: interrupt_trigger_level
        type: b1
        if: not _io.eof
        doc: Set if level-triggered, clear if edge-triggered.
      - id: interrupt_active_high
        type: b1
        if: not _io.eof
      - id: reserved1
        type: b1
        if: not _io.eof
      - id: interrupt_info_specified
        type: b1
        if: not _io.eof
      - id: address_lsb
        type: b1
        if: not _io.eof
      - id: reserved2
        type: b1
        if: not _io.eof
      - id: register_spacing
        type: b2
        enum: ipmi_register_spacing
        if: not _io.eof
      - id: interrupt_number
        type: u1
        if: not _io.eof
        doc: 0 if unspecified.
  system_power_supply:
    doc: Type 39.
    seq:
      - id: power_unit_group
        type: u1
        doc: |
          Supplies with the same non-zero group are redundant; 0 if not part
          of a redundant unit.
      - id: location
        type: string_ref(_parent)
      - id: device_name
        type: string_ref(_parent)
      - id: manufacturer
        type: string_ref(_parent)
      - id: serial_number
        type: string_ref(_parent)
      - id: asset_tag_number
        type: string_ref(_parent)
      - id: model_part_number
        type: string_ref(_parent)
      - id: revision_level
        type: string_ref(_parent)
      - id: max_power_capacity
        type: u2
        doc: In W, 0x8000 if unknown.
      - id: hot_replaceable
        type: b1
      - id: present
        type: b1
      - id: unplugged
        type: b1
      - id: input_voltage_range_switching
        type: b4
        enum: power_supply_range_switching
      - id: status
        type: b3
        enum: probe_status
      - id: power_supply_type
        type: b4
        enum: power_supply_type
      - id: reserved
        type: b2
      - id: input_voltage_probe_handle
        type: u2
        if: not _io.eof
      - id: cooling_device_handle
        type: u2
        if: not _io.eof
      - id: input_current_probe_handle
        type: u2
        if: not _io.eof
  additional_information:
    doc: |
      Type 40, values that the specification does not define yet for fields
      of other structures.
    seq:
      - id: num_entries
        type: u1
      - id: entries
        type: additional_information_entry
        repeat: expr
        repeat-expr: num_entries
  additional_information_entry:
    seq:
      - id: len_entry
        type: u1
      - id: referenced_handle
        type: u2
      - id: referenced_offset
        type: u1
        doc: |
          Offset of the field in the referenced structure, counted from the
          start of its header, i.e. 4 more than its position in `formatted_area`.
      - id: string
        type: string_ref(_parent._parent)
      - id: value
        size: len_entry - 5
        doc: Value of the same type and size as the referenced field.
  onboard_devices_extended_information:
    doc: Type 41.
    seq:
      - id: reference_designation
        type: string_ref(_parent)
      - id: device_type
        type: b7
        enum: onboard_device_type
      - id: enabled
        type: b1
      - id: device_type_instance
        type: u1
        doc: Number of the device among those of its type, starting at 1.
      - id: address
        type: pci_address
  management_controller_host_interface:
    doc: Type 42.
    seq:
      - id: interface_type
        type: u1
        enum: host_interface_type
        doc: 0 to 0x3f are MCTP host interface types defined by DSP0239.
      - id: len_interface_type_specific_data
        type: u1
        if: is_length_prefixed
        doc: |
          Absent before version 3.2, when the data of an OEM interface
          started with the IANA enterprise number right here.
      - id: interface_type_specific_data
        size: len_interface_type_specific_data.as<u4>
        if: is_length_prefixed
        doc: |
          For an OEM interface, starts with the IANA enterprise number
          (big-endian); the network host interface data is defined by
          DSP0270.
      - id: num_protocol_records
        type: u1
        if: is_length_prefixed
      - id: protocol_records
        type: host_interface_protocol_record
        repeat: expr
        repeat-expr: num_protocol_records
        if: is_length_prefixed
      - id: pre_3_2_data
        size-eos: true
        if: not is_length_prefixed
        doc: |
          Everything after `interface_type` in a structure too short for the
          3.2 layout; for an OEM interface, starts with the IANA enterprise
          number.
    instances:
      is_length_prefixed:
        value: '_io.size >= 3 and _io.size >= 3 + byte_at_05h'
        doc: |
          True if the structure is long enough for the 3.2 layout (a length,
          that many bytes and a record count). A pre-3.2 structure can pass
          this test by chance.
      byte_at_05h:
        pos: 1
        type: u1
        if: _io.size >= 2
  host_interface_protocol_record:
    seq:
      - id: protocol_type
        type: u1
        enum: host_interface_protocol_type
      - id: len_protocol_type_specific_data
        type: u1
      - id: protocol_type_specific_data
        size: len_protocol_type_specific_data
        doc: The data of Redfish over IP is defined by DSP0270.
  tpm_device:
    doc: Type 43.
    seq:
      - id: vendor_id
        size: 4
        type: strz
        encoding: ASCII
        doc: TCG vendor ID, e.g. "IFX".
      - id: major_spec_version
        type: u1
        doc: 1 for TPM 1.2, 2 for TPM 2.0.
      - id: minor_spec_version
        type: u1
      - id: firmware_version_1
        type: u4
        doc: |
          For TPM 1.2 the TPM_VERSION structure, for TPM 2.0 the
          TPM_PT_FIRMWARE_VERSION_1 property.
      - id: firmware_version_2
        type: u4
        doc: For TPM 2.0 the TPM_PT_FIRMWARE_VERSION_2 property, else 0.
      - id: description
        type: string_ref(_parent)
      - id: characteristics
        type: tpm_characteristics
      - id: oem_defined
        type: u4
        if: not _io.eof
  tpm_characteristics:
    seq:
      - id: reserved1
        type: b2
      - id: not_supported
        type: b1
      - id: family_configurable_via_firmware_update
        type: b1
      - id: family_configurable_via_platform_software
        type: b1
      - id: family_configurable_via_oem_mechanism
        type: b1
      - id: reserved2
        type: b58
  processor_additional_information:
    doc: Type 44.
    seq:
      - id: referenced_handle
        type: u2
        doc: Handle of the processor information structure this one adds to.
      - id: len_processor_specific_data
        type: u1
      - id: processor_type
        type: u1
        enum: processor_architecture_type
      - id: processor_specific_data
        size: len_processor_specific_data
        type:
          switch-on: processor_type
          cases:
            'processor_architecture_type::aarch64': aarch64_processor_specific_data
        doc: |
          Defined in separate documents: the RISC-V BRS, the LoongArch SMBIOS
          and the Intel SMBIOS specifications; 64-bit Arm data is part of
          DSP0134.
  aarch64_processor_specific_data:
    seq:
      - id: revision_minor
        type: u1
      - id: revision_major
        type: u1
      - id: len_data
        type: u1
      - id: reserved1
        type: u1
      - id: vendor_jep106_code
        type: u1
        doc: JEP-106 identification code of the silicon provider, with parity bit.
      - id: vendor_jep106_bank
        type: b7
        doc: JEP-106 bank index (continuation count) of the silicon provider.
      - id: reserved2
        type: b1
      - id: sub_type
        type: u1
        enum: aarch64_data_sub_type
      - id: reserved3
        type: u1
      - id: sub_type_data
        size-eos: true
        type:
          switch-on: sub_type
          cases:
            'aarch64_data_sub_type::architecture': aarch64_architecture_data
        doc: Vendor-specific data is defined by the silicon provider.
  aarch64_architecture_data:
    doc: |
      Values of the AArch64 ID registers, see the Arm A-profile architecture
      reference for their fields.
    seq:
      - id: version
        type: u2
      - id: len_data
        type: u1
      - id: reserved1
        type: u1
      - id: reserved2
        type: u4
      - id: id_aa64afr0_el1
        type: u8
      - id: id_aa64afr1_el1
        type: u8
      - id: id_aa64dfr0_el1
        type: u8
      - id: id_aa64dfr1_el1
        type: u8
      - id: id_aa64dfr2_el1
        type: u8
      - id: id_aa64fpfr0_el1
        type: u8
      - id: id_aa64isar0_el1
        type: u8
      - id: id_aa64isar1_el1
        type: u8
      - id: id_aa64isar2_el1
        type: u8
      - id: id_aa64isar3_el1
        type: u8
      - id: id_aa64mmfr0_el1
        type: u8
        doc: The smallest PARange of all CPUs of the system.
      - id: id_aa64mmfr1_el1
        type: u8
      - id: id_aa64mmfr2_el1
        type: u8
      - id: id_aa64mmfr3_el1
        type: u8
      - id: id_aa64mmfr4_el1
        type: u8
      - id: id_aa64pfr0_el1
        type: u8
      - id: id_aa64pfr1_el1
        type: u8
      - id: id_aa64pfr2_el1
        type: u8
      - id: id_aa64smfr0_el1
        type: u8
      - id: id_aa64zfr0_el1
        type: u8
  firmware_inventory_information:
    doc: Type 45, one firmware component of the system.
    seq:
      - id: firmware_component_name
        type: string_ref(_parent)
        doc: E.g. "BMC Firmware".
      - id: firmware_version
        type: string_ref(_parent)
      - id: version_format
        type: u1
        enum: firmware_version_format
      - id: firmware_id
        type: string_ref(_parent)
      - id: firmware_id_format
        type: u1
        enum: firmware_id_format
      - id: release_date
        type: string_ref(_parent)
        doc: In DSP0266 date-time format, e.g. "2021-05-15T04:14:33+06:00".
      - id: manufacturer
        type: string_ref(_parent)
      - id: lowest_supported_firmware_version
        type: string_ref(_parent)
      - id: image_size
        type: u8
        doc: In bytes; all bits set if unknown.
      - id: updatable
        type: b1
      - id: write_protected
        type: b1
      - id: reserved
        type: b14
      - id: state
        type: u1
        enum: firmware_state
      - id: num_associated_component_handles
        type: u1
      - id: associated_component_handles
        type: u2
        repeat: expr
        repeat-expr: num_associated_component_handles
  string_property:
    doc: Type 46, a string property of another structure.
    seq:
      - id: string_property_id
        type: u2
        enum: string_property_id
        doc: 0x8000 to 0xbfff are firmware vendor IDs, 0xc000 and above OEM IDs.
      - id: string_property_value
        type: string_ref(_parent)
      - id: parent_handle
        type: u2
enums:
  structure_type:
    0: platform_firmware_information
    1: system_information
    2: baseboard_information
    3: system_enclosure
    4: processor_information
    5: memory_controller_information
    6: memory_module_information
    7: cache_information
    8: port_connector_information
    9: system_slots
    10: on_board_devices_information
    11: oem_strings
    12: system_configuration_options
    13: firmware_language_information
    14: group_associations
    15: system_event_log
    16: physical_memory_array
    17: memory_device
    18: memory_error_information_32
    19: memory_array_mapped_address
    20: memory_device_mapped_address
    21: built_in_pointing_device
    22: portable_battery
    23: system_reset
    24: hardware_security
    25: system_power_controls
    26: voltage_probe
    27: cooling_device
    28: temperature_probe
    29: electrical_current_probe
    30: out_of_band_remote_access
    31: boot_integrity_services
    32: system_boot_information
    33: memory_error_information_64
    34: management_device
    35: management_device_component
    36: management_device_threshold_data
    37: memory_channel
    38: ipmi_device_information
    39: system_power_supply
    40: additional_information
    41: onboard_devices_extended_information
    42: management_controller_host_interface
    43: tpm_device
    44: processor_additional_information
    45: firmware_inventory_information
    46: string_property
    126: inactive
    127: end_of_table
  extended_rom_size_unit:
    0: mib
    1: gib
  wake_up_type:
    0: reserved
    1: other
    2: unknown
    3: apm_timer
    4: modem_ring
    5: lan_remote
    6: power_switch
    7: pci_pme
    8: ac_power_restored
  board_type:
    1: unknown
    2: other
    3: server_blade
    4: connectivity_switch
    5: system_management_module
    6: processor_module
    7: io_module
    8: memory_module
    9: daughter_board
    10: motherboard
    11: processor_memory_module
    12: processor_io_module
    13: interconnect_board
  chassis_type:
    1: other
    2: unknown
    3: desktop
    4: low_profile_desktop
    5: pizza_box
    6: mini_tower
    7: tower
    8: portable
    9: laptop
    10: notebook
    11: hand_held
    12: docking_station
    13: all_in_one
    14: sub_notebook
    15: space_saving
    16: lunch_box
    17: main_server_chassis
    18: expansion_chassis
    19: sub_chassis
    20: bus_expansion_chassis
    21: peripheral_chassis
    22: raid_chassis
    23: rack_mount_chassis
    24: sealed_case_pc
    25: multi_system_chassis
    26: compact_pci
    27: advanced_tca
    28: blade
    29: blade_enclosure
    30: tablet
    31: convertible
    32: detachable
    33: iot_gateway
    34: embedded_pc
    35: mini_pc
    36: stick_pc
  chassis_state:
    1: other
    2: unknown
    3: safe
    4: warning
    5: critical
    6: non_recoverable
  chassis_security_status:
    1: other
    2: unknown
    3: none
    4: external_interface_locked_out
    5: external_interface_enabled
  rack_type:
    0: unspecified
    1:
      id: ou
      doc: Open Compute Project OpenU (48 mm).
  processor_type:
    1: other
    2: unknown
    3: central_processor
    4: math_processor
    5: dsp_processor
    6: video_processor
  processor_family:
    0x01: other
    0x02: unknown
    0x03: i8086
    0x04: i80286
    0x05: intel386
    0x06: intel486
    0x07: i8087
    0x08: i80287
    0x09: i80387
    0x0a: i80487
    0x0b: intel_pentium
    0x0c: pentium_pro
    0x0d: pentium_ii
    0x0e: pentium_mmx
    0x0f: intel_celeron
    0x10: pentium_ii_xeon
    0x11: pentium_iii
    0x12: m1
    0x13: m2
    0x14: intel_celeron_m
    0x15: intel_pentium_4_ht
    0x16: intel_processor
    0x18: amd_duron
    0x19: k5
    0x1a: k6
    0x1b: k6_2
    0x1c: k6_3
    0x1d: amd_athlon
    0x1e: amd29000
    0x1f: k6_2_plus
    0x20: power_pc
    0x21: power_pc_601
    0x22: power_pc_603
    0x23: power_pc_603_plus
    0x24: power_pc_604
    0x25: power_pc_620
    0x26: power_pc_x704
    0x27: power_pc_750
    0x28: intel_core_duo
    0x29: intel_core_duo_mobile
    0x2a: intel_core_solo_mobile
    0x2b: intel_atom
    0x2c: intel_core_m
    0x2d: intel_core_m3
    0x2e: intel_core_m5
    0x2f: intel_core_m7
    0x30: alpha
    0x31: alpha_21064
    0x32: alpha_21066
    0x33: alpha_21164
    0x34: alpha_21164pc
    0x35: alpha_21164a
    0x36: alpha_21264
    0x37: alpha_21364
    0x38: amd_turion_ii_ultra_dual_core_mobile_m
    0x39: amd_turion_ii_dual_core_mobile_m
    0x3a: amd_athlon_ii_dual_core_m
    0x3b: amd_opteron_6100
    0x3c: amd_opteron_4100
    0x3d: amd_opteron_6200
    0x3e: amd_opteron_4200
    0x3f: amd_fx
    0x40: mips
    0x41: mips_r4000
    0x42: mips_r4200
    0x43: mips_r4400
    0x44: mips_r4600
    0x45: mips_r10000
    0x46: amd_c_series
    0x47: amd_e_series
    0x48: amd_a_series
    0x49: amd_g_series
    0x4a: amd_z_series
    0x4b: amd_r_series
    0x4c: amd_opteron_4300
    0x4d: amd_opteron_6300
    0x4e: amd_opteron_3300
    0x4f: amd_firepro
    0x50: sparc
    0x51: supersparc
    0x52: microsparc_ii
    0x53: microsparc_iiep
    0x54: ultrasparc
    0x55: ultrasparc_ii
    0x56:
      id: ultrasparc_ii_i
      doc: UltraSPARC IIi, written "UltraSPARC Iii" in DSP0134.
    0x57: ultrasparc_iii
    0x58: ultrasparc_iii_i
    0x60: m68040
    0x61: m68xxx
    0x62: m68000
    0x63: m68010
    0x64: m68020
    0x65: m68030
    0x66: amd_athlon_x4_quad_core
    0x67: amd_opteron_x1000
    0x68: amd_opteron_x2000_apu
    0x69: amd_opteron_a_series
    0x6a: amd_opteron_x3000_apu
    0x6b: amd_zen
    0x70: hobbit
    0x78: crusoe_tm5000
    0x79: crusoe_tm3000
    0x7a: efficeon_tm8000
    0x80: weitek
    0x82: itanium
    0x83: amd_athlon_64
    0x84: amd_opteron
    0x85: amd_sempron
    0x86: amd_turion_64_mobile
    0x87: dual_core_amd_opteron
    0x88: amd_athlon_64_x2_dual_core
    0x89: amd_turion_64_x2_mobile
    0x8a: quad_core_amd_opteron
    0x8b: third_generation_amd_opteron
    0x8c: amd_phenom_fx_quad_core
    0x8d: amd_phenom_x4_quad_core
    0x8e: amd_phenom_x2_dual_core
    0x8f: amd_athlon_x2_dual_core
    0x90: pa_risc
    0x91: pa_risc_8500
    0x92: pa_risc_8000
    0x93: pa_risc_7300lc
    0x94: pa_risc_7200
    0x95: pa_risc_7100lc
    0x96: pa_risc_7100
    0xa0: v30
    0xa1: quad_core_intel_xeon_3200
    0xa2: dual_core_intel_xeon_3000
    0xa3: quad_core_intel_xeon_5300
    0xa4: dual_core_intel_xeon_5100
    0xa5: dual_core_intel_xeon_5000
    0xa6: dual_core_intel_xeon_lv
    0xa7: dual_core_intel_xeon_ulv
    0xa8: dual_core_intel_xeon_7100
    0xa9: quad_core_intel_xeon_5400
    0xaa: quad_core_intel_xeon
    0xab: dual_core_intel_xeon_5200
    0xac: dual_core_intel_xeon_7200
    0xad: quad_core_intel_xeon_7300
    0xae: quad_core_intel_xeon_7400
    0xaf: multi_core_intel_xeon_7400
    0xb0: pentium_iii_xeon
    0xb1: pentium_iii_speedstep
    0xb2: pentium_4
    0xb3: intel_xeon
    0xb4: as400
    0xb5: intel_xeon_mp
    0xb6: amd_athlon_xp
    0xb7: amd_athlon_mp
    0xb8: intel_itanium_2
    0xb9: intel_pentium_m
    0xba: intel_celeron_d
    0xbb: intel_pentium_d
    0xbc: intel_pentium_extreme_edition
    0xbd: intel_core_solo
    0xbe:
      id: reserved_core_2_or_k7
      doc: |
        Used by some implementations for Intel Core 2 and by others for
        AMD K7 processors.
    0xbf: intel_core_2_duo
    0xc0: intel_core_2_solo
    0xc1: intel_core_2_extreme
    0xc2: intel_core_2_quad
    0xc3: intel_core_2_extreme_mobile
    0xc4: intel_core_2_duo_mobile
    0xc5: intel_core_2_solo_mobile
    0xc6: intel_core_i7
    0xc7: dual_core_intel_celeron
    0xc8: ibm390
    0xc9: g4
    0xca: g5
    0xcb: esa_390_g6
    0xcc: z_architecture_base
    0xcd: intel_core_i5
    0xce: intel_core_i3
    0xcf: intel_core_i9
    0xd0: intel_xeon_d
    0xd2: via_c7_m
    0xd3: via_c7_d
    0xd4: via_c7
    0xd5: via_eden
    0xd6: multi_core_intel_xeon
    0xd7: dual_core_intel_xeon_3xxx
    0xd8: quad_core_intel_xeon_3xxx
    0xd9: via_nano
    0xda: dual_core_intel_xeon_5xxx
    0xdb: quad_core_intel_xeon_5xxx
    0xdd: dual_core_intel_xeon_7xxx
    0xde: quad_core_intel_xeon_7xxx
    0xdf: multi_core_intel_xeon_7xxx
    0xe0: multi_core_intel_xeon_3400
    0xe4: amd_opteron_3000
    0xe5: amd_sempron_ii
    0xe6: embedded_amd_opteron_quad_core
    0xe7: amd_phenom_triple_core
    0xe8: amd_turion_ultra_dual_core_mobile
    0xe9: amd_turion_dual_core_mobile
    0xea: amd_athlon_dual_core
    0xeb: amd_sempron_si
    0xec: amd_phenom_ii
    0xed: amd_athlon_ii
    0xee: six_core_amd_opteron
    0xef: amd_sempron_m
    0xfa: i860
    0xfb: i960
    0xfe:
      id: indicator_family_2
      doc: The family is in `processor_family_2`.
    0x100: armv7
    0x101: armv8
    0x102: armv9
    0x104: sh_3
    0x105: sh_4
    0x118: arm
    0x119: strongarm
    0x12c: cyrix_6x86
    0x12d: mediagx
    0x12e: mii
    0x140: winchip
    0x15e: dsp
    0x1f4: video_processor
    0x200: riscv_rv32
    0x201: riscv_rv64
    0x202: riscv_rv128
    0x258: loongarch
    0x259: loongson_1
    0x25a: loongson_2
    0x25b: loongson_3
    0x25c: loongson_2k
    0x25d: loongson_3a
    0x25e: loongson_3b
    0x25f: loongson_3c
    0x260: loongson_3d
    0x261: loongson_3e
    0x262: dual_core_loongson_2k_2xxx
    0x26c: quad_core_loongson_3a_5xxx
    0x26d: multi_core_loongson_3a_5xxx
    0x26e: quad_core_loongson_3b_5xxx
    0x26f: multi_core_loongson_3b_5xxx
    0x270: multi_core_loongson_3c_5xxx
    0x271: multi_core_loongson_3d_5xxx
    0x300: intel_core_3
    0x301: intel_core_5
    0x302: intel_core_7
    0x303: intel_core_9
    0x304: intel_core_ultra_3
    0x305: intel_core_ultra_5
    0x306: intel_core_ultra_7
    0x307: intel_core_ultra_9
  cpu_status:
    0: unknown
    1: enabled
    2: disabled_by_user
    3: disabled_by_firmware
    4: idle
    7: other
  processor_upgrade:
    0x01: other
    0x02: unknown
    0x03: daughter_board
    0x04: zif_socket
    0x05: replaceable_piggy_back
    0x06: none
    0x07: lif_socket
    0x08: slot_1
    0x09: slot_2
    0x0a: socket_370_pin
    0x0b: slot_a
    0x0c: slot_m
    0x0d: socket_423
    0x0e: socket_a
    0x0f: socket_478
    0x10: socket_754
    0x11: socket_940
    0x12: socket_939
    0x13: socket_mpga604
    0x14: socket_lga771
    0x15: socket_lga775
    0x16: socket_s1
    0x17: socket_am2
    0x18: socket_f
    0x19: socket_lga1366
    0x1a: socket_g34
    0x1b: socket_am3
    0x1c: socket_c32
    0x1d: socket_lga1156
    0x1e: socket_lga1567
    0x1f: socket_pga988a
    0x20: socket_bga1288
    0x21: socket_rpga988b
    0x22: socket_bga1023
    0x23: socket_bga1224
    0x24: socket_lga1155
    0x25: socket_lga1356
    0x26: socket_lga2011
    0x27: socket_fs1
    0x28: socket_fs2
    0x29: socket_fm1
    0x2a: socket_fm2
    0x2b: socket_lga2011_3
    0x2c: socket_lga1356_3
    0x2d: socket_lga1150
    0x2e: socket_bga1168
    0x2f: socket_bga1234
    0x30: socket_bga1364
    0x31: socket_am4
    0x32: socket_lga1151
    0x33: socket_bga1356
    0x34: socket_bga1440
    0x35: socket_bga1515
    0x36: socket_lga3647_1
    0x37: socket_sp3
    0x38: socket_sp3r2
    0x39: socket_lga2066
    0x3a: socket_bga1392
    0x3b: socket_bga1510
    0x3c: socket_bga1528
    0x3d: socket_lga4189
    0x3e: socket_lga1200
    0x3f: socket_lga4677
    0x40: socket_lga1700
    0x41: socket_bga1744
    0x42: socket_bga1781
    0x43: socket_bga1211
    0x44: socket_bga2422
    0x45: socket_lga1211
    0x46: socket_lga2422
    0x47: socket_lga5773
    0x48: socket_bga5773
    0x49: socket_am5
    0x4a: socket_sp5
    0x4b: socket_sp6
    0x4c: socket_bga883
    0x4d: socket_bga1190
    0x4e: socket_bga4129
    0x4f: socket_lga4710
    0x50: socket_lga7529
    0x51: socket_bga1964
    0x52: socket_bga1792
    0x53: socket_bga2049
    0x54: socket_bga2551
    0x55: socket_lga1851
    0x56: socket_bga2114
    0x57: socket_bga2833
    0xff:
      id: other_socket
      doc: The socket is named in `socket_type`.
  error_detecting_method:
    1: other
    2: unknown
    3: none
    4: parity_8_bit
    5: ecc_32_bit
    6: ecc_64_bit
    7: ecc_128_bit
    8: crc
  interleave_support:
    1: other
    2: unknown
    3: one_way
    4: two_way
    5: four_way
    6: eight_way
    7: sixteen_way
  cache_location:
    0: internal
    1: external
    2: reserved
    3: unknown
  cache_operational_mode:
    0: write_through
    1: write_back
    2: varies_with_memory_address
    3: unknown
  cache_error_correction_type:
    1: other
    2: unknown
    3: none
    4: parity
    5: single_bit_ecc
    6: multi_bit_ecc
  system_cache_type:
    1: other
    2: unknown
    3: instruction
    4: data
    5: unified
  cache_associativity:
    1: other
    2: unknown
    3: direct_mapped
    4: set_associative_2_way
    5: set_associative_4_way
    6: fully_associative
    7: set_associative_8_way
    8: set_associative_16_way
    9: set_associative_12_way
    10: set_associative_24_way
    11: set_associative_32_way
    12: set_associative_48_way
    13: set_associative_64_way
    14: set_associative_20_way
  connector_type:
    0x00: none
    0x01: centronics
    0x02: mini_centronics
    0x03: proprietary
    0x04: db_25_pin_male
    0x05: db_25_pin_female
    0x06: db_15_pin_male
    0x07: db_15_pin_female
    0x08: db_9_pin_male
    0x09: db_9_pin_female
    0x0a: rj_11
    0x0b: rj_45
    0x0c: mini_scsi_50_pin
    0x0d: mini_din
    0x0e: micro_din
    0x0f: ps2
    0x10: infrared
    0x11: hp_hil
    0x12: access_bus_usb
    0x13: ssa_scsi
    0x14: circular_din_8_male
    0x15: circular_din_8_female
    0x16: on_board_ide
    0x17: on_board_floppy
    0x18: dual_inline_9_pin
    0x19: dual_inline_25_pin
    0x1a: dual_inline_50_pin
    0x1b: dual_inline_68_pin
    0x1c: on_board_sound_input_from_cd_rom
    0x1d: mini_centronics_type_14
    0x1e: mini_centronics_type_26
    0x1f: mini_jack_headphones
    0x20: bnc
    0x21: ieee1394
    0x22: sas_sata_plug_receptacle
    0x23: usb_type_c_receptacle
    0xa0: pc_98
    0xa1: pc_98_hireso
    0xa2: pc_h98
    0xa3: pc_98_note
    0xa4: pc_98_full
    0xff:
      id: other
      doc: The reference designator strings describe the connector.
  port_type:
    0x00: none
    0x01: parallel_port_xt_at_compatible
    0x02: parallel_port_ps2
    0x03: parallel_port_ecp
    0x04: parallel_port_epp
    0x05: parallel_port_ecp_epp
    0x06: serial_port_xt_at_compatible
    0x07: serial_port_16450_compatible
    0x08: serial_port_16550_compatible
    0x09: serial_port_16550a_compatible
    0x0a: scsi_port
    0x0b: midi_port
    0x0c: joy_stick_port
    0x0d: keyboard_port
    0x0e: mouse_port
    0x0f: ssa_scsi
    0x10: usb
    0x11: firewire
    0x12: pcmcia_type_i
    0x13: pcmcia_type_ii
    0x14: pcmcia_type_iii
    0x15: cardbus
    0x16: access_bus_port
    0x17: scsi_ii
    0x18: scsi_wide
    0x19: pc_98
    0x1a: pc_98_hireso
    0x1b: pc_h98
    0x1c: video_port
    0x1d: audio_port
    0x1e: modem_port
    0x1f: network_port
    0x20: sata
    0x21: sas
    0x22: mfdp
    0x23: thunderbolt
    0xa0: compatible_8251
    0xa1: fifo_compatible_8251
    0xff: other
  slot_type:
    0x01: other
    0x02: unknown
    0x03: isa
    0x04: mca
    0x05: eisa
    0x06: pci
    0x07: pc_card
    0x08: vl_vesa
    0x09: proprietary
    0x0a: processor_card_slot
    0x0b: proprietary_memory_card_slot
    0x0c: io_riser_card_slot
    0x0d: nubus
    0x0e: pci_66mhz_capable
    0x0f: agp
    0x10: agp_2x
    0x11: agp_4x
    0x12: pci_x
    0x13: agp_8x
    0x14: m2_socket_1_dp_key_a
    0x15: m2_socket_1_sd_key_e
    0x16: m2_socket_2_key_b
    0x17: m2_socket_3_key_m
    0x18: mxm_type_i
    0x19: mxm_type_ii
    0x1a: mxm_type_iii_standard_connector
    0x1b: mxm_type_iii_he_connector
    0x1c: mxm_type_iv
    0x1d: mxm_3_0_type_a
    0x1e: mxm_3_0_type_b
    0x1f: pci_express_gen2_sff_8639
    0x20: pci_express_gen3_sff_8639
    0x21: pci_express_mini_52_pin_with_bottom_side_keep_outs
    0x22: pci_express_mini_52_pin_without_bottom_side_keep_outs
    0x23: pci_express_mini_76_pin
    0x24: pci_express_gen4_sff_8639
    0x25: pci_express_gen5_sff_8639
    0x26: ocp_nic_3_0_sff
    0x27: ocp_nic_3_0_lff
    0x28: ocp_nic_prior_to_3_0
    0x30:
      id: cxl_flexbus_1_0
      doc: Deprecated, see `slot_characteristics_2`.
    0xa0: pc_98_c20
    0xa1: pc_98_c24
    0xa2: pc_98_e
    0xa3: pc_98_local_bus
    0xa4: pc_98_card
    0xa5: pci_express
    0xa6: pci_express_x1
    0xa7: pci_express_x2
    0xa8: pci_express_x4
    0xa9: pci_express_x8
    0xaa: pci_express_x16
    0xab: pci_express_gen2
    0xac: pci_express_gen2_x1
    0xad: pci_express_gen2_x2
    0xae: pci_express_gen2_x4
    0xaf: pci_express_gen2_x8
    0xb0: pci_express_gen2_x16
    0xb1: pci_express_gen3
    0xb2: pci_express_gen3_x1
    0xb3: pci_express_gen3_x2
    0xb4: pci_express_gen3_x4
    0xb5: pci_express_gen3_x8
    0xb6: pci_express_gen3_x16
    0xb8: pci_express_gen4
    0xb9: pci_express_gen4_x1
    0xba: pci_express_gen4_x2
    0xbb: pci_express_gen4_x4
    0xbc: pci_express_gen4_x8
    0xbd: pci_express_gen4_x16
    0xbe: pci_express_gen5
    0xbf: pci_express_gen5_x1
    0xc0: pci_express_gen5_x2
    0xc1: pci_express_gen5_x4
    0xc2: pci_express_gen5_x8
    0xc3: pci_express_gen5_x16
    0xc4:
      id: pci_express_gen6_and_beyond
      doc: The generation is in `slot_information`, the width in `slot_physical_width`.
    0xc5: edsff_e1
    0xc6: edsff_e3
  slot_width:
    0x01: other
    0x02: unknown
    0x03: bit_8
    0x04: bit_16
    0x05: bit_32
    0x06: bit_64
    0x07: bit_128
    0x08: x1
    0x09: x2
    0x0a: x4
    0x0b: x8
    0x0c: x12
    0x0d: x16
    0x0e: x32
  slot_current_usage:
    1: other
    2: unknown
    3: available
    4: in_use
    5: unavailable
  slot_length:
    1: other
    2: unknown
    3: short_length
    4: long_length
    5: drive_form_factor_2_5_inch
    6: drive_form_factor_3_5_inch
  slot_height:
    0: not_applicable
    1: other
    2: unknown
    3: full_height
    4: low_profile
  onboard_device_type:
    0x01: other
    0x02: unknown
    0x03: video
    0x04: scsi_controller
    0x05: ethernet
    0x06: token_ring
    0x07: sound
    0x08: pata_controller
    0x09: sata_controller
    0x0a: sas_controller
    0x0b: wireless_lan
    0x0c: bluetooth
    0x0d: wwan
    0x0e: emmc
    0x0f: nvme_controller
    0x10: ufs_controller
    0x11: infiniband_controller
    0x12: gpu_controller
  event_log_access_method:
    0: indexed_io_1_8_bit_index_1_8_bit_data
    1: indexed_io_2_8_bit_index_1_8_bit_data
    2: indexed_io_1_16_bit_index_1_8_bit_data
    3: memory_mapped_32
    4:
      id: gpnv
      doc: General-purpose non-volatile data functions.
  event_log_header_format:
    0: no_header
    1: type_1
  event_log_type:
    0x01: single_bit_ecc_memory_error
    0x02: multi_bit_ecc_memory_error
    0x03: parity_memory_error
    0x04: bus_timeout
    0x05: io_channel_check
    0x06: software_nmi
    0x07: post_memory_resize
    0x08: post_error
    0x09: pci_parity_error
    0x0a: pci_system_error
    0x0b: cpu_failure
    0x0c: eisa_failsafe_timer_timeout
    0x0d: correctable_memory_log_disabled
    0x0e: logging_disabled_for_event_type
    0x10: system_limit_exceeded
    0x11: asynchronous_hardware_timer_expired
    0x12: system_configuration_information
    0x13: hard_disk_information
    0x14: system_reconfigured
    0x15: uncorrectable_cpu_complex_error
    0x16: log_area_reset
    0x17: system_boot
    0xff: end_of_log
  event_log_variable_data_format:
    0: none
    1: handle
    2: multiple_event
    3: multiple_event_handle
    4: post_results_bitmap
    5: system_management_type
    6: multiple_event_system_management_type
  memory_array_location:
    0x01: other
    0x02: unknown
    0x03: system_board
    0x04: isa_add_on_card
    0x05: eisa_add_on_card
    0x06: pci_add_on_card
    0x07: mca_add_on_card
    0x08: pcmcia_add_on_card
    0x09: proprietary_add_on_card
    0x0a: nubus
    0xa0: pc_98_c20_add_on_card
    0xa1: pc_98_c24_add_on_card
    0xa2: pc_98_e_add_on_card
    0xa3: pc_98_local_bus_add_on_card
    0xa4: cxl_add_on_card
  memory_array_use:
    1: other
    2: unknown
    3: system_memory
    4: video_memory
    5: flash_memory
    6: non_volatile_ram
    7: cache_memory
  memory_array_error_correction:
    1: other
    2: unknown
    3: none
    4: parity
    5: single_bit_ecc
    6: multi_bit_ecc
    7: crc
  memory_form_factor:
    0x01: other
    0x02: unknown
    0x03: simm
    0x04: sip
    0x05: chip
    0x06: dip
    0x07: zip
    0x08: proprietary_card
    0x09: dimm
    0x0a: tsop
    0x0b: row_of_chips
    0x0c: rimm
    0x0d: sodimm
    0x0e: srimm
    0x0f: fb_dimm
    0x10: die
    0x11: camm
    0x12: cudimm
    0x13: csodimm
  memory_device_type:
    0x01: other
    0x02: unknown
    0x03: dram
    0x04: edram
    0x05: vram
    0x06: sram
    0x07: ram
    0x08: rom
    0x09: flash
    0x0a: eeprom
    0x0b: feprom
    0x0c: eprom
    0x0d: cdram
    0x0e: ram_3d
    0x0f: sdram
    0x10: sgram
    0x11: rdram
    0x12: ddr
    0x13: ddr2
    0x14: ddr2_fb_dimm
    0x18: ddr3
    0x19: fbd2
    0x1a: ddr4
    0x1b: lpddr
    0x1c: lpddr2
    0x1d: lpddr3
    0x1e: lpddr4
    0x1f: logical_non_volatile_device
    0x20: hbm
    0x21: hbm2
    0x22: ddr5
    0x23: lpddr5
    0x24: hbm3
    0x25: mrdimm
    0x26: lpddr6
  memory_technology:
    1: other
    2: unknown
    3: dram
    4: nvdimm_n
    5: nvdimm_f
    6: nvdimm_p
    7: intel_optane_persistent_memory
    8:
      id: mrdimm
      doc: Deprecated, `memory_device_type::mrdimm` replaces it.
  memory_error_type:
    0x01: other
    0x02: unknown
    0x03: ok
    0x04: bad_read
    0x05: parity_error
    0x06: single_bit_error
    0x07: double_bit_error
    0x08: multi_bit_error
    0x09: nibble_error
    0x0a: checksum_error
    0x0b: crc_error
    0x0c: corrected_single_bit_error
    0x0d: corrected_error
    0x0e: uncorrectable_error
  memory_error_granularity:
    1: other
    2: unknown
    3: device_level
    4: memory_partition_level
  memory_error_operation:
    1: other
    2: unknown
    3: read
    4: write
    5: partial_write
  pointing_device_type:
    1: other
    2: unknown
    3: mouse
    4: track_ball
    5: track_point
    6: glide_point
    7: touch_pad
    8: touch_screen
    9: optical_sensor
  pointing_device_interface:
    0x01: other
    0x02: unknown
    0x03: serial
    0x04: ps2
    0x05: infrared
    0x06: hp_hil
    0x07: bus_mouse
    0x08: adb
    0xa0: bus_mouse_db_9
    0xa1: bus_mouse_micro_din
    0xa2: usb
    0xa3: i2c
    0xa4: spi
  battery_chemistry:
    1: other
    2: unknown
    3: lead_acid
    4: nickel_cadmium
    5: nickel_metal_hydride
    6: lithium_ion
    7: zinc_air
    8: lithium_polymer
  system_reset_boot_option:
    1: operating_system
    2: system_utilities
    3: do_not_reboot
  hardware_security_status:
    0: disabled
    1: enabled
    2: not_implemented
    3: unknown
  probe_status:
    1: other
    2: unknown
    3: ok
    4: non_critical
    5: critical
    6: non_recoverable
  probe_location:
    0x01: other
    0x02: unknown
    0x03: processor
    0x04: disk
    0x05: peripheral_bay
    0x06: system_management_module
    0x07: motherboard
    0x08: memory_module
    0x09: processor_module
    0x0a: power_unit
    0x0b: add_in_card
    0x0c:
      id: front_panel_board
      doc: Temperature probes only.
    0x0d:
      id: back_panel_board
      doc: Temperature probes only.
    0x0e:
      id: power_system_board
      doc: Temperature probes only.
    0x0f:
      id: drive_back_plane
      doc: Temperature probes only.
  cooling_device_type:
    0x01: other
    0x02: unknown
    0x03: fan
    0x04: centrifugal_blower
    0x05: chip_fan
    0x06: cabinet_fan
    0x07: power_supply_fan
    0x08: heat_pipe
    0x09: integrated_refrigeration
    0x10: active_cooling
    0x11: passive_cooling
  boot_status:
    0: no_errors
    1: no_bootable_media
    2: operating_system_failed_to_load
    3: firmware_detected_hardware_failure
    4: operating_system_detected_hardware_failure
    5: user_requested_boot
    6: system_security_violation
    7: previously_requested_image
    8: watchdog_timer_expired
  management_device_type:
    0x01: other
    0x02: unknown
    0x03: lm75
    0x04: lm78
    0x05: lm79
    0x06: lm80
    0x07: lm81
    0x08: adm9240
    0x09: ds1780
    0x0a: maxim_1617
    0x0b: gl518sm
    0x0c: w83781d
    0x0d: ht82h791
  management_device_address_type:
    1: other
    2: unknown
    3: io_port
    4: memory
    5: sm_bus
  memory_channel_type:
    1: other
    2: unknown
    3: rambus
    4: synclink
  ipmi_interface_type:
    0: unknown
    1:
      id: kcs
      doc: Keyboard Controller Style.
    2:
      id: smic
      doc: Server Management Interface Chip.
    3:
      id: bt
      doc: Block Transfer.
    4:
      id: ssif
      doc: SMBus System Interface.
  ipmi_register_spacing:
    0: successive_bytes
    1: boundary_32_bit
    2: boundary_16_byte
    3: reserved
  power_supply_type:
    1: other
    2: unknown
    3: linear
    4: switching
    5: battery
    6: ups
    7: converter
    8: regulator
  power_supply_range_switching:
    1: other
    2: unknown
    3: manual
    4: auto_switch
    5: wide_range
    6: not_applicable
  host_interface_type:
    0x40:
      id: network
      doc: Network host interface, DSP0270.
    0xf0: oem
  host_interface_protocol_type:
    2: ipmi
    3: mctp
    4: redfish_over_ip
    0xf0: oem
  processor_architecture_type:
    0x01: ia32
    0x02: x64
    0x03: itanium
    0x04: aarch32
    0x05: aarch64
    0x06: riscv_rv32
    0x07: riscv_rv64
    0x08: riscv_rv128
    0x09: loongarch32
    0x0a: loongarch64
  aarch64_data_sub_type:
    0: architecture
    1: vendor_specific
  firmware_version_format:
    0: free_form
    1:
      id: major_minor
      doc: Decimal "MAJOR.MINOR", e.g. "1.45".
    2:
      id: hex_32_bit
      doc: E.g. "0x0001002d".
    3:
      id: hex_64_bit
      doc: E.g. "0x000000010000002d".
  firmware_id_format:
    0: free_form
    1:
      id: uefi_guid
      doc: UEFI ESRT FwClass or FMP ImageTypeId GUID as a string.
  firmware_state:
    1: other
    2: unknown
    3: disabled
    4: enabled
    5: absent
    6: standby_offline
    7: standby_spare
    8: unavailable_offline
  string_property_id:
    1:
      id: uefi_device_path
      doc: Text form of a UEFI device path.
