meta:
  id: via_nano_microcode
  title: VIA Nano CPU microcode update
  application: coreboot
  file-extension:
    - bin
    - dat
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Microcode update file for VIA (Centaur) Nano processors, as loaded by
  coreboot. The file is a concatenation of updates; each update has a
  48-byte header starting with the signature "RRAS" (0x53415252 as a
  little-endian dword), the release date, the CPUID family/model/stepping
  it applies to, a checksum, and the payload and total sizes, followed by
  the encrypted/opaque payload. The checksum is chosen so that the sum of
  all 32-bit words of the update (header and payload) is zero.

  Note that the microparse tool reads these files with the opposite
  (big-endian) word order, which makes the magic appear as "SARR" and
  byte-swaps the name.
doc-ref:
  - https://github.com/coreboot/coreboot/blob/4.11/src/cpu/via/nano/update_ucode.h
  - https://github.com/coreboot/coreboot/blob/4.11/src/cpu/via/nano/update_ucode.c
  - https://github.com/ddcc/microparse/blob/0b58a9ba1089ce906048722653783bfe15beed7a/via.py
seq:
  - id: updates
    type: update
    repeat: eos
types:
  update:
    seq:
      - id: magic
        contents: RRAS
      - id: update_revision
        type: u4
      - id: year
        type: u2
      - id: day
        type: u1
      - id: month
        type: u1
      - id: applicable_fms
        type: u4
        doc: CPUID(1).EAX family/model/stepping the update applies to.
      - id: checksum
        type: u4
        doc: Makes the 32-bit sum of all dwords of the update zero.
      - id: loader_revision
        type: u4
      - id: reserved1
        type: u4
      - id: len_payload
        type: u4
      - id: len_total
        type: u4
        doc: Size of the update including the 48-byte header.
      - id: name
        size: 8
        type: str
        encoding: ASCII
        doc: Name of the update file (not NUL-terminated).
      - id: reserved2
        type: u4
      - id: payload
        size: len_payload
    instances:
      has_valid_sizes:
        value: len_total == len_payload + 48
        doc: The loader rejects updates whose header is not 48 bytes.
