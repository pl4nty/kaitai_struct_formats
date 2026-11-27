meta:
  id: smbios_entry_point
  title: SMBIOS entry point structure
  license: CC0-1.0
  ks-version: '0.11'
  imports:
    - smbios
  encoding: ASCII
  endian: le
doc: |
  The SMBIOS entry point tells software where the SMBIOS structure table
  (see `smbios`) is in physical memory, how long it is and which version of
  DSP0134 it follows. There are three kinds, told apart by their anchor
  string:

  * `_SM_`, the 32-bit entry point of SMBIOS 2.1 and later, which embeds a
    legacy `_DMI_` entry point at offset 0x10;
  * `_SM3_`, the 64-bit entry point of SMBIOS 3.0 and later;
  * `_DMI_` on its own, the entry point of the legacy DMI 2.0 table.

  Firmware places the entry point on a 16-byte boundary in 0xf0000-0xfffff,
  or publishes its address in the EFI configuration table. Linux exposes it
  as `/sys/firmware/dmi/tables/smbios_entry_point`; there the table address
  is a physical one and the table is in the `DMI` file next to it.

  `dmidecode --dump-bin` writes the entry point with the table address
  changed to 0x20, followed by the table at that offset, so for such a file
  `table` parses the whole structure table. `table` is null if the address
  is beyond the end of the input.

  The checksums are not verified: all bytes of the entry point (and, for the
  32-bit one, the 15 bytes from `_DMI_`) add up to 0 modulo 256.
doc-ref: https://www.dmtf.org/sites/default/files/standards/documents/DSP0134_3.10.0.pdf
seq:
  - id: anchor
    size: 4
    type: str
  - id: body
    type:
      switch-on: anchor
      cases:
        '"_SM_"': entry_point_32
        '"_SM3"': entry_point_64
        '"_DMI"': legacy_entry_point
types:
  entry_point_32:
    doc: SMBIOS 2.1 (32-bit) entry point, after the `_SM_` anchor.
    seq:
      - id: checksum
        type: u1
      - id: len_entry_point
        type: u1
        doc: |
          0x1f; some version 2.1 implementations use 0x1e, as that version of
          the specification stated by mistake.
      - id: major_version
        type: u1
      - id: minor_version
        type: u1
      - id: len_max_structure
        type: u2
        doc: Size of the largest structure, strings included.
      - id: entry_point_revision
        type: u1
        doc: 0 for the SMBIOS 2.1 definition.
      - id: formatted_area
        size: 5
        doc: Zero for `entry_point_revision` 0.
      - id: intermediate_anchor
        contents: _DMI
      - id: legacy
        type: legacy_entry_point
        doc: Intermediate entry point, for legacy DMI browsers.
    instances:
      table:
        value: legacy.table
        doc: Same as `legacy.table`.
  legacy_entry_point:
    doc: |
      DMI 2.0 entry point, or the intermediate entry point that a 32-bit
      SMBIOS entry point embeds.
    seq:
      - id: magic
        contents: _
        doc: Last byte of the `_DMI_` anchor.
      - id: checksum
        type: u1
      - id: len_structure_table
        type: u2
      - id: ofs_structure_table
        type: u4
        doc: Physical address of the structure table.
      - id: num_structures
        type: u2
      - id: bcd_revision
        type: u1
        doc: |
          Version in BCD, e.g. 0x21 for 2.1; 0 if only `major_version` and
          `minor_version` of the 32-bit entry point give it.
    instances:
      table:
        io: _io
        pos: ofs_structure_table
        size: len_structure_table
        type: smbios
        if: ofs_structure_table + len_structure_table <= _io.size
  entry_point_64:
    doc: SMBIOS 3.0 (64-bit) entry point, after the `_SM3` part of the anchor.
    seq:
      - id: magic
        contents: _
        doc: Last byte of the `_SM3_` anchor.
      - id: checksum
        type: u1
      - id: len_entry_point
        type: u1
        doc: 0x18.
      - id: major_version
        type: u1
      - id: minor_version
        type: u1
      - id: docrev
        type: u1
        doc: Third part of the version, e.g. 1 for 2.7.1.
      - id: entry_point_revision
        type: u1
        doc: 1 for the SMBIOS 3.0 definition.
      - id: reserved
        type: u1
      - id: max_len_structure_table
        type: u4
        doc: The table is at most this long and ends with an end-of-table structure.
      - id: ofs_structure_table
        type: u8
        doc: Physical address of the structure table.
    instances:
      table:
        io: _io
        pos: ofs_structure_table
        size: 'ofs_structure_table + max_len_structure_table <= _io.size ? max_len_structure_table : _io.size - ofs_structure_table'
        type: smbios
        if: ofs_structure_table < _io.size
