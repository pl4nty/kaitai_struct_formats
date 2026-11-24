meta:
  id: amd_microcode
  title: AMD x86 CPU microcode container
  application:
    - Linux kernel
    - linux-firmware
  file-extension: bin
  license: CC0-1.0
  ks-version: '0.11'
  endian: le
doc: |
  Container format in which AMD distributes microcode patches for its x86
  processors, as shipped in the `amd-ucode/microcode_amd*.bin` files of
  linux-firmware and loaded by the Linux kernel (also used by coreboot).

  A container starts with the `DMA\0` magic, followed by a CPU equivalence
  table that maps CPUID signatures to the 16-bit "equivalent CPU" IDs referenced
  by the patches (terminated by an all-zero entry), and then a sequence of patch
  sections, each one a type/size header followed by the patch itself. Several
  containers may be concatenated in one file (e.g. in an early initrd), so this
  spec parses containers until end of stream.

  Only the 64-byte patch header is parsed; the patch body is opaque (and
  encrypted/signed on newer CPUs).
doc-ref:
  - https://github.com/torvalds/linux/blob/master/arch/x86/kernel/cpu/microcode/amd.c
  - https://github.com/ddcc/microparse/blob/master/amd.py
seq:
  - id: containers
    type: container
    repeat: eos
types:
  container:
    seq:
      - id: magic
        contents: [0x44, 0x4d, 0x41, 0x00]
        doc: '`UCODE_MAGIC` (0x00414d44, "DMA\0" on disk).'
      - id: equiv_table_type
        type: u4
        valid: 0
        doc: '`UCODE_EQUIV_CPU_TABLE_TYPE`, always 0.'
      - id: len_equiv_table
        type: u4
      - id: equiv_table
        size: len_equiv_table
        type: equiv_cpu_table
      - id: sections
        type: section
        repeat: until
        repeat-until: _io.eof or _.next_type != 1
  equiv_cpu_table:
    seq:
      - id: entries
        type: equiv_cpu_entry
        repeat: eos
  equiv_cpu_entry:
    seq:
      - id: installed_cpu
        type: u4
        doc: CPUID function 1 EAX signature; 0 marks the end of the table.
      - id: fixed_errata_mask
        type: u4
      - id: fixed_errata_compare
        type: u4
      - id: equiv_cpu
        type: u2
        doc: Matched against `patch_header.processor_rev_id`.
      - id: reserved
        -orig-id: res
        type: u2
  section:
    seq:
      - id: type
        type: u4
        valid: 1
        doc: '`UCODE_UCODE_TYPE`, always 1.'
      - id: len_patch
        type: u4
      - id: patch
        size: len_patch
        type: patch
    instances:
      next_type:
        pos: _io.pos
        type: u4
        if: not _io.eof
        doc: |
          Peeks at the word following this section to find out whether another
          patch section (1) or a new container (the magic) follows.
  patch:
    seq:
      - id: header
        type: patch_header
      - id: body
        -orig-id: mpb
        size-eos: true
  patch_header:
    -orig-id: microcode_header_amd
    seq:
      - id: data_code
        type: u4
        doc: |
          Release date, written in hexadecimal digits as 0xMMDDYYYY (e.g.
          0x02232024 is 2024-02-23).
      - id: patch_id
        type: u4
        doc: Microcode revision reported by the CPU after loading this patch.
      - id: patch_data_id
        -orig-id: mc_patch_data_id
        type: u2
      - id: patch_data_len
        -orig-id: mc_patch_data_len
        type: u1
      - id: init_flag
        type: u1
      - id: patch_data_checksum
        -orig-id: mc_patch_data_checksum
        type: u4
      - id: nb_dev_id
        type: u4
        doc: Northbridge device ID.
      - id: sb_dev_id
        type: u4
        doc: Southbridge device ID.
      - id: processor_rev_id
        type: u2
        doc: Equivalent CPU ID, as listed in `equiv_cpu_entry.equiv_cpu`.
      - id: nb_rev_id
        type: u1
      - id: sb_rev_id
        type: u1
      - id: bios_api_rev
        type: u1
      - id: reserved1
        size: 3
      - id: match_reg
        type: u4
        repeat: expr
        repeat-expr: 8
