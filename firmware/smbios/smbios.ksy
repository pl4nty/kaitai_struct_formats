meta:
  id: smbios
  title: SMBIOS structure table
  license: LicenseRef-All-Rights-Reserved
  encoding: UTF-8
  endian: le
doc: |
  SMBIOS (System Management BIOS) is the standard way for the firmware of a
  computer to tell the operating system what hardware it runs on: vendor,
  model and serial numbers, processors, memory modules, slots and so on.
  The data that `dmidecode` prints comes from this table.

  This spec describes the structure table itself, a sequence of structures
  that normally ends with one of type 127. Linux exposes it as
  `/sys/firmware/dmi/tables/DMI`. It does not cover the entry point
  (`_SM_` or `_SM3_` anchor) that tells where the table is in memory; a
  file written by `dmidecode --dump-bin` starts with a copy of the entry
  point and has the table at offset 0x20.

  Every structure consists of a formatted area, whose length depends on the
  version of the standard the firmware follows, and of the strings its
  fields refer to by number. Only a few of the structure types are parsed
  in detail so far.
doc-ref:
  - https://www.dmtf.org/standards/smbios
  - https://github.com/mirror/dmidecode/blob/master/dmidecode.c
seq:
  - id: structures
    type: structure
    repeat: until
    repeat-until: _.type == structure_type::end_of_table or _io.eof
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
        doc: Number that other structures use to refer to this one.
      - id: formatted_area
        size: len_formatted_area - 4
        type:
          switch-on: type
          cases:
            'structure_type::bios_information': bios_information
            'structure_type::system_information': system_information
            'structure_type::processor_information': processor_information
            'structure_type::portable_battery': portable_battery
      - id: strings
        type: strz
        repeat: until
        repeat-until: _ == ""
        doc: |
          Strings of the structure, followed by an empty one that ends the
          list. A string field of the formatted area holds the number of
          its string, starting at 1, or 0 if it has none.
      - id: terminator
        size: 1
        if: strings.size == 1
        doc: |
          A structure without strings still ends in two zero bytes; this is
          the second one.
  bios_information:
    seq:
      - id: idx_vendor
        type: u1
      - id: idx_version
        type: u1
      - id: starting_address_segment
        type: u2
        doc: Segment of the BIOS starting address, e.g. 0xe800.
      - id: idx_release_date
        type: u1
      - id: rom_size
        type: u1
        doc: |
          Size of the ROM is `(rom_size + 1) * 64` KiB; 0xff means that it is
          16 MiB or more and given in `extended_rom_size`.
      - id: characteristics
        type: u8
      - id: characteristics_extension1
        type: u1
        if: not _io.eof
      - id: characteristics_extension2
        type: u1
        if: not _io.eof
      - id: system_bios_major_release
        type: u1
        if: not _io.eof
      - id: system_bios_minor_release
        type: u1
        if: not _io.eof
      - id: embedded_controller_firmware_major_release
        type: u1
        if: not _io.eof
      - id: embedded_controller_firmware_minor_release
        type: u1
        if: not _io.eof
      - id: extended_rom_size
        type: u2
        if: not _io.eof
        doc: |
          The 14 low bits are the size, the 2 high bits its unit: 0 for MiB,
          1 for GiB.
    instances:
      vendor:
        value: _parent.strings[idx_vendor - 1]
        if: idx_vendor != 0
      version:
        value: _parent.strings[idx_version - 1]
        if: idx_version != 0
      release_date:
        value: _parent.strings[idx_release_date - 1]
        if: idx_release_date != 0
  system_information:
    seq:
      - id: idx_manufacturer
        type: u1
      - id: idx_product_name
        type: u1
      - id: idx_version
        type: u1
      - id: idx_serial_number
        type: u1
      - id: uuid
        size: 16
        if: not _io.eof
      - id: wake_up_type
        type: u1
        enum: wake_up_type
        if: not _io.eof
      - id: idx_sku_number
        type: u1
        if: not _io.eof
      - id: idx_family
        type: u1
        if: not _io.eof
    instances:
      manufacturer:
        value: _parent.strings[idx_manufacturer - 1]
        if: idx_manufacturer != 0
      product_name:
        value: _parent.strings[idx_product_name - 1]
        if: idx_product_name != 0
      version:
        value: _parent.strings[idx_version - 1]
        if: idx_version != 0
      serial_number:
        value: _parent.strings[idx_serial_number - 1]
        if: idx_serial_number != 0
      sku_number:
        value: _parent.strings[idx_sku_number - 1]
        if: _io.size > 21 and idx_sku_number != 0
      family:
        value: _parent.strings[idx_family - 1]
        if: _io.size > 22 and idx_family != 0
  processor_information:
    seq:
      - id: idx_socket_designation
        type: u1
      - id: processor_type
        type: u1
        enum: processor_type
      - id: processor_family
        type: u1
        doc: 0xfe means that the family is given in `processor_family2`.
      - id: idx_processor_manufacturer
        type: u1
      - id: processor_id
        type: u8
      - id: idx_processor_version
        type: u1
      - id: voltage
        type: u1
      - id: external_clock
        type: u2
        doc: In MHz, 0 if unknown.
      - id: max_speed
        type: u2
        doc: In MHz, 0 if unknown.
      - id: current_speed
        type: u2
        doc: In MHz, 0 if unknown.
      - id: status
        type: u1
        doc: |
          Bit 6 is set if the socket is populated, the 3 low bits hold the
          status of the processor.
      - id: processor_upgrade
        type: u1
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
      - id: idx_serial_number
        type: u1
        if: not _io.eof
      - id: idx_asset_tag
        type: u1
        if: not _io.eof
      - id: idx_part_number
        type: u1
        if: not _io.eof
      - id: core_count
        type: u1
        if: not _io.eof
        doc: 0xff means that the number is given in `core_count2`.
      - id: core_enabled
        type: u1
        if: not _io.eof
        doc: 0xff means that the number is given in `core_enabled2`.
      - id: thread_count
        type: u1
        if: not _io.eof
        doc: 0xff means that the number is given in `thread_count2`.
      - id: processor_characteristics
        type: u2
        if: not _io.eof
      - id: processor_family2
        type: u2
        if: not _io.eof
      - id: core_count2
        type: u2
        if: not _io.eof
      - id: core_enabled2
        type: u2
        if: not _io.eof
      - id: thread_count2
        type: u2
        if: not _io.eof
      - id: thread_enabled
        type: u2
        if: not _io.eof
    instances:
      socket_designation:
        value: _parent.strings[idx_socket_designation - 1]
        if: idx_socket_designation != 0
      processor_manufacturer:
        value: _parent.strings[idx_processor_manufacturer - 1]
        if: idx_processor_manufacturer != 0
      processor_version:
        value: _parent.strings[idx_processor_version - 1]
        if: idx_processor_version != 0
      serial_number:
        value: _parent.strings[idx_serial_number - 1]
        if: _io.size > 28 and idx_serial_number != 0
      asset_tag:
        value: _parent.strings[idx_asset_tag - 1]
        if: _io.size > 29 and idx_asset_tag != 0
      part_number:
        value: _parent.strings[idx_part_number - 1]
        if: _io.size > 30 and idx_part_number != 0
  portable_battery:
    seq:
      - id: idx_location
        type: u1
      - id: idx_manufacturer
        type: u1
      - id: idx_manufacture_date
        type: u1
        doc: 0 if the date is given in `sbds_manufacture_date`.
      - id: idx_serial_number
        type: u1
        doc: 0 if the number is given in `sbds_serial_number`.
      - id: idx_device_name
        type: u1
      - id: device_chemistry
        type: u1
        enum: device_chemistry
        doc: |
          `unknown` if the chemistry is given in `sbds_device_chemistry`.
      - id: design_capacity
        type: u2
        doc: |
          In mWh, to be multiplied by `design_capacity_multiplier` if that is
          present; 0 if unknown.
      - id: design_voltage
        type: u2
        doc: In mV, 0 if unknown.
      - id: idx_sbds_version_number
        type: u1
      - id: maximum_error_in_battery_data
        type: u1
        doc: In percent, 0xff if unknown.
      - id: sbds_serial_number
        type: u2
        if: not _io.eof
      - id: sbds_manufacture_date
        type: u2
        if: not _io.eof
        doc: |
          Bits 0 to 4 are the day, bits 5 to 8 the month and bits 9 to 15 the
          year minus 1980.
      - id: idx_sbds_device_chemistry
        type: u1
        if: not _io.eof
      - id: design_capacity_multiplier
        type: u1
        if: not _io.eof
      - id: oem_specific
        type: u4
        if: not _io.eof
    instances:
      location:
        value: _parent.strings[idx_location - 1]
        if: idx_location != 0
      manufacturer:
        value: _parent.strings[idx_manufacturer - 1]
        if: idx_manufacturer != 0
      manufacture_date:
        value: _parent.strings[idx_manufacture_date - 1]
        if: idx_manufacture_date != 0
      serial_number:
        value: _parent.strings[idx_serial_number - 1]
        if: idx_serial_number != 0
      device_name:
        value: _parent.strings[idx_device_name - 1]
        if: idx_device_name != 0
      sbds_version_number:
        value: _parent.strings[idx_sbds_version_number - 1]
        if: idx_sbds_version_number != 0
      sbds_device_chemistry:
        value: _parent.strings[idx_sbds_device_chemistry - 1]
        if: _io.size > 16 and idx_sbds_device_chemistry != 0
enums:
  structure_type:
    0: bios_information
    1: system_information
    2: baseboard_information
    3: system_enclosure
    4: processor_information
    7: cache_information
    9: system_slots
    14: group_associations
    17: memory_device
    22: portable_battery
    38: ipmi_device_information
    43: tpm_device
    126: inactive
    127: end_of_table
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
  processor_type:
    1: other
    2: unknown
    3: central_processor
    4: math_processor
    5: dsp_processor
    6: video_processor
  device_chemistry:
    1: other
    2: unknown
    3: lead_acid
    4: nickel_cadmium
    5: nickel_metal_hydride
    6: lithium_ion
    7: zinc_air
    8: lithium_polymer
