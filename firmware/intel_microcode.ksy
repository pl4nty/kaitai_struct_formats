meta:
  id: intel_microcode
  title: Intel x86 CPU microcode update
  application:
    - Linux kernel
    - iucode-tool
  license: CC0-1.0
  ks-version: '0.11'
  endian: le
doc: |
  Microcode updates for Intel x86 processors, as distributed by Intel
  (`intel-ucode/<family>-<model>-<stepping>` files) and loaded by the
  operating system or firmware. A file is a concatenation of one or
  more updates.

  Each update consists of a 48-byte header, the encrypted update data
  and an optional extended signature table listing additional
  processor signatures / platform IDs the update applies to. If
  `len_data` is 0, the update is an old-style one with 2000 bytes of
  data and a total size of 2048 bytes.

  All 32-bit words of header and data sum to 0 (mod 2^32); likewise
  for the extended signature table.
doc-ref:
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/arch/x86/include/asm/microcode.h
  - https://github.com/torvalds/linux/blob/8d7fe9885c62fc9a95bf55d9db244d9672a8aadc/arch/x86/kernel/cpu/microcode/intel.c
  - https://github.com/ddcc/microparse/blob/0b58a9ba1089ce906048722653783bfe15beed7a/intel.py
seq:
  - id: updates
    type: update
    repeat: eos
types:
  update:
    seq:
      - id: header
        type: header
      - id: data
        size: header.len_data_effective
        doc: Encrypted microcode update data.
      - id: extended_signature_table
        size: header.len_total_effective - 48 - header.len_data_effective
        type: extended_signature_table
        if: header.len_total_effective > 48 + header.len_data_effective
  header:
    -orig-id: microcode_header_intel
    seq:
      - id: header_version
        -orig-id: hdrver
        type: u4
        doc: 1 for microcode updates, 2 for In-Field Scan (IFS) images.
      - id: update_revision
        -orig-id: rev
        type: u4
      - id: date
        type: date
      - id: processor_signature
        -orig-id: sig
        type: processor_signature
        doc: CPUID(1).EAX value of the processor this update is for.
      - id: checksum
        -orig-id: cksum
        type: u4
      - id: loader_revision
        -orig-id: ldrver
        type: u4
        valid: 1
      - id: processor_flags
        -orig-id: pf
        type: u4
        doc: Bit mask of the platform IDs this update applies to.
      - id: len_data
        -orig-id: datasize
        type: u4
        doc: Size of the update data; 0 means 2000.
      - id: len_total
        -orig-id: totalsize
        type: u4
        doc: |
          Total size of the update including header and extended
          signature table; only meaningful if `len_data` is not 0.
      - id: len_metadata
        -orig-id: metasize
        type: u4
      - id: min_required_version
        -orig-id: min_req_ver
        type: u4
      - id: reserved
        type: u4
    instances:
      len_data_effective:
        value: 'len_data != 0 ? len_data : 2000'
      len_total_effective:
        value: 'len_data != 0 ? len_total : 2048'
  date:
    doc: Release date stored as hexadecimal digits 0xMMDDYYYY.
    seq:
      - id: raw
        type: u4
    instances:
      year:
        value: |
          ((raw >> 12) & 0xf) * 1000 + ((raw >> 8) & 0xf) * 100
          + ((raw >> 4) & 0xf) * 10 + (raw & 0xf)
      day:
        value: ((raw >> 20) & 0xf) * 10 + ((raw >> 16) & 0xf)
      month:
        value: ((raw >> 28) & 0xf) * 10 + ((raw >> 24) & 0xf)
    -webide-representation: '{year:dec}-{month:dec}-{day:dec}'
  processor_signature:
    doc: Processor signature as returned in EAX by CPUID leaf 1.
    seq:
      - id: raw
        type: u4
    instances:
      stepping:
        value: raw & 0xf
      model:
        value: (raw >> 4) & 0xf
      family:
        value: (raw >> 8) & 0xf
      processor_type:
        value: (raw >> 12) & 0x3
      extended_model:
        value: (raw >> 16) & 0xf
      extended_family:
        value: (raw >> 20) & 0xff
    -webide-representation: '{raw:hex}'
  extended_signature_table:
    -orig-id: extended_sigtable
    seq:
      - id: num_signatures
        -orig-id: count
        type: u4
      - id: checksum
        -orig-id: cksum
        type: u4
      - id: reserved
        size: 12
      - id: signatures
        type: extended_signature
        repeat: expr
        repeat-expr: num_signatures
  extended_signature:
    seq:
      - id: processor_signature
        -orig-id: sig
        type: processor_signature
      - id: processor_flags
        -orig-id: pf
        type: u4
      - id: checksum
        -orig-id: cksum
        type: u4
