meta:
  id: intel_me_fpt
  title: Intel ME / CSE Flash Partition Table ($FPT)
  application: Intel Management Engine / Converged Security Engine firmware
  license: CC0-1.0
  ks-version: '0.9'
  encoding: ASCII
  endian: le
doc: |
  Flash Partition Table ("$FPT") at the start of the Intel Management
  Engine (ME), Trusted Execution Engine (TXE), Server Platform Services
  (SPS) or Converged Security Engine (CSE) region of an SPI flash
  image. It lists the firmware partitions of the region (code
  partitions such as FTPR, NFTP, the MFS file system, etc.) with their
  offsets and sizes.

  The region may start with a 16-byte ROM-bypass vector, in which case
  "$FPT" begins at offset 0x10. The header exists in version 1.0/2.0
  (8-bit checksum) and 2.1 (CRC-32); 32-byte entries always follow 0x20
  bytes after the "$FPT" tag.

  Coverage: the optional ROM-bypass vector, the header (both layouts)
  and the entries. Input is the ME/CSE region itself (for a full SPI
  image, extract the region using the flash descriptor first). Entry
  offsets are relative to the start of the region (including the
  ROM-bypass vector) in the common case, but some layouts differ, so
  partition contents are not exposed: $CPD code partition directories,
  manifests and MFS are not parsed.

  Tested only on synthetic data built from the MEAnalyzer structure
  definitions; no real firmware image was available.
doc-ref: https://github.com/platomav/MEAnalyzer/blob/d27ccdba0aadbad490f47b5b631c369b682a7ef5/MEA.py
seq:
  - id: rom_bypass
    type: u4
    repeat: expr
    repeat-expr: 4
    if: tag_at_start != "$FPT"
    doc: ROM-bypass instructions (FPT_Pre_Header); 0 or 0xFFFFFFFF when unused.
  - id: header
    type: fpt_header
  - id: entries
    type: fpt_entry
    repeat: expr
    repeat-expr: header.num_partitions
instances:
  tag_at_start:
    pos: 0
    size: 4
    type: str
types:
  fpt_header:
    seq:
      - id: tag
        contents: $FPT
      - id: num_partitions
        -orig-id: NumPartitions
        type: u4
      - id: header_version
        -orig-id: HeaderVersion
        type: u1
        doc: 0x10, 0x20 or 0x21.
      - id: entry_version
        -orig-id: EntryVersion
        type: u1
      - id: len_header
        -orig-id: HeaderLength
        type: u1
      - id: checksum_or_flags
        -orig-id: HeaderChecksum / Flags
        type: u1
        doc: |
          8-bit header checksum in v1.0/2.0; flags in v2.1 (bit 0: a
          redundant copy of $FPT is kept at 0x1000).
      - id: ticks_to_add
        -orig-id: FlashCycleLife / TicksToAdd
        type: u2
      - id: tokens_to_add
        -orig-id: FlashCycleLimit / TokensToAdd
        type: u2
      - id: uma_size_or_sps_flags
        -orig-id: UMASize / SPSFlags
        type: u4
      - id: flags_or_crc32
        -orig-id: Flags / HeaderChecksum
        type: u4
        doc: |
          Flash layout flags in v1.0/2.0; in v2.1 CRC-32 over the header
          and entries computed with this field set to 0.
      - id: fit_major
        type: u2
      - id: fit_minor
        type: u2
      - id: fit_hotfix
        type: u2
      - id: fit_build
        type: u2
        doc: Version of the Flash Image Tool that built the image.
    instances:
      is_v21:
        value: header_version == 0x21
        doc: |
          MEAnalyzer also treats a 0x20 header whose upper CRC half
          (bytes 0x16-0x17) is neither 0000 nor FFFF as v2.1.
  fpt_entry:
    seq:
      - id: name
        size: 4
        type: str
        doc: Partition name, e.g. FTPR, NFTP, MFS, ROMB.
      - id: owner
        size: 4
        type: str
        doc: Reserved on CSE.
      - id: ofs_partition
        -orig-id: Offset
        type: u4
        doc: Partition offset; 0 or 0xFFFFFFFF means empty.
      - id: len_partition
        -orig-id: Size
        type: u4
      - id: start_tokens
        type: u4
      - id: max_tokens
        type: u4
      - id: scratch_sectors
        type: u4
      - id: flags
        -orig-id: Flags
        type: u4
        doc: FPT_ENTRY_ATTRIBUTES bit field.
    instances:
      partition_type:
        value: flags & 0x7f
        doc: Bits 0-6; 0 code, 1 data (PARTITION_TYPES).
      copy_to_dram_cache:
        value: (flags >> 7) & 1 != 0
      built_with_length1:
        value: (flags >> 15) & 1 != 0
      built_with_length2:
        value: (flags >> 16) & 1 != 0
      entry_valid:
        value: flags >> 24
        doc: Bits 24-31; 0xFF marks an invalid entry.
