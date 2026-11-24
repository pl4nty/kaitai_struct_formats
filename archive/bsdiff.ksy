meta:
  id: bsdiff
  title: bsdiff binary patch
  application:
    - bsdiff / bspatch
    - bsdiff4 (Python)
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Binary patch produced by Colin Percival's bsdiff (also FreeBSD
  `bsdiff`, Python `bsdiff4`, Chromium/Android OTA tooling), and the
  incompatible variant written by Matthew Endsley's embeddable bsdiff
  library.

  Both variants describe the new file as a sequence of control triples
  `(x, y, z)`: add `x` bytes of the diff block to `x` bytes of the old
  file (bytewise, modulo 256) at the current old position, then copy
  `y` bytes from the extra block, then move the old position by `z`
  (which may be negative).

  * `BSDIFF40` (original): a 32-byte header with the compressed sizes
    of the control block and diff block and the size of the new file,
    followed by three independent bzip2 streams: control block (24 bytes
    per triple), diff block and extra block.
  * `ENDSLEY/BSDIFF43`: a 24-byte header with the size of the new file,
    followed by a single bzip2 stream in which every control triple is
    directly followed by its `x` diff bytes and `y` extra bytes.

  All integers, including the control triples, are 64-bit
  sign-and-magnitude little-endian numbers (bit 63 is the sign). The
  bzip2-compressed payloads are left as raw bytes; once decompressed
  they can be parsed with `control_block` (BSDIFF40 control stream) or
  `endsley_payload` (BSDIFF43 stream).
doc-ref:
  - https://github.com/freebsd/freebsd-src/blob/main/usr.bin/bsdiff/bspatch/bspatch.c
  - https://github.com/mendsley/bsdiff/blob/b817e9491cf7b8699c8462ef9e2657ca4ccd7667/bspatch.c
  - https://github.com/mendsley/bsdiff/blob/b817e9491cf7b8699c8462ef9e2657ca4ccd7667/bsdiff.c
seq:
  - id: magic
    size: 8
    type: str
    encoding: ASCII
    valid:
      any-of: ['"BSDIFF40"', '"ENDSLEY/"']
  - id: body
    type:
      switch-on: magic
      cases:
        '"BSDIFF40"': bsdiff40_body
        '"ENDSLEY/"': endsley_body
types:
  sign_magnitude_s8:
    doc: 64-bit integer stored as magnitude in bits 0-62 and sign in bit 63 (`offtin`).
    seq:
      - id: raw
        type: u8
    instances:
      magnitude:
        value: raw & 0x7fff_ffff_ffff_ffff
      is_negative:
        value: raw >> 63 != 0
      value:
        value: 'is_negative ? -magnitude : magnitude'
  bsdiff40_body:
    seq:
      - id: len_control_compressed
        -orig-id: bzctrllen
        type: sign_magnitude_s8
      - id: len_diff_compressed
        -orig-id: bzdatalen
        type: sign_magnitude_s8
      - id: len_new_file
        -orig-id: newsize
        type: sign_magnitude_s8
      - id: control_compressed
        size: len_control_compressed.value
        doc: bzip2 stream; decompresses to a `control_block`.
      - id: diff_compressed
        size: len_diff_compressed.value
        doc: bzip2 stream of the diff bytes of all triples, concatenated.
      - id: extra_compressed
        size-eos: true
        doc: bzip2 stream of the extra bytes of all triples, concatenated.
  endsley_body:
    seq:
      - id: magic_rest
        contents: BSDIFF43
      - id: len_new_file
        -orig-id: newsize
        type: sign_magnitude_s8
      - id: payload_compressed
        size-eos: true
        doc: bzip2 stream; decompresses to an `endsley_payload`.
  control_triple:
    seq:
      - id: len_diff
        -orig-id: ctrl[0]
        type: sign_magnitude_s8
        doc: Number of bytes to take from the diff block and add to the old file.
      - id: len_extra
        -orig-id: ctrl[1]
        type: sign_magnitude_s8
        doc: Number of bytes to copy from the extra block.
      - id: old_seek
        -orig-id: ctrl[2]
        type: sign_magnitude_s8
        doc: Relative adjustment of the position in the old file.
  # ksylint: disable-next-line=KSY600 -- applies to the bzip2-decompressed payload
  control_block:
    doc: Decompressed control block of a BSDIFF40 patch.
    seq:
      - id: triples
        type: control_triple
        repeat: eos
  # ksylint: disable-next-line=KSY600 -- applies to the bzip2-decompressed payload
  endsley_payload:
    doc: Decompressed payload of an ENDSLEY/BSDIFF43 patch.
    seq:
      - id: entries
        type: endsley_entry
        repeat: eos
  endsley_entry:
    seq:
      - id: control
        type: control_triple
      - id: diff
        size: control.len_diff.value
      - id: extra
        size: control.len_extra.value
