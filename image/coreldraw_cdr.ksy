meta:
  id: coreldraw_cdr
  title: CorelDRAW drawing (RIFF-based CDR)
  application: CorelDRAW
  file-extension: cdr
  license: CC0-1.0
  ks-version: '0.9'
  encoding: ASCII
  endian: le
doc: |
  Native drawing format of the CorelDRAW vector graphics editor. Since 1992
  CDR files are RIFF files whose form type is "CDR" (or "cdr") followed by
  a character identifying the version. CorelDRAW X4 and later wrap this
  RIFF stream as `content/riffData.cdr` inside a ZIP archive; this spec
  describes the RIFF stream itself (the pre-1992 "WL" format is not
  covered).

  The top level usually contains a `vrsn` chunk (version number, e.g. 1500
  for X7), a `DISP` thumbnail, `LIST` chunks and a `sumi` summary. A
  `LIST` chunk of type `cmpr` holds two zlib-compressed parts: part 1 is a
  sequence of chunks in which each chunk's size field is not a size but an
  index into part 2, a table of 32-bit chunk sizes. The parts are
  decompressed here, but the chunks of part 1 are left raw.
doc-ref:
  - https://github.com/photopea/CDR-specification/blob/f91b3c7e8c812b28473f6399e95a624a72a3d6b8/README.md
  - https://github.com/LibreOffice/libcdr/blob/b5211a57af37dac59a04f6041822a07f4a7cf7d6/src/lib/CDRParser.cpp
seq:
  - id: magic
    contents: RIFF
  - id: len_body
    type: u4
    doc: Size of the rest of the RIFF chunk, starting with the form type.
  - id: form_type
    size: 3
    type: str
    valid:
      any-of: ['"CDR"', '"cdr"']
  - id: version_char
    type: u1
    doc: |
      Version identifier (a space for version 3, '4'..'9', and 'A'.. for
      version 10 and later); the exact version is in the `vrsn` chunk.
  - id: body
    size: len_body - 4
    type: chunk_list
instances:
  version:
    value: |
      version_char == 0x20 ? 300
        : version_char >= 0x31 and version_char <= 0x39 ? (version_char - 0x30) * 100
        : version_char >= 0x41 ? (version_char - 0x37) * 100
        : 0
    doc: |
      CorelDRAW version times 100 as derived from `version_char`, e.g. 700
      for '7' and 1000 for 'A'; 0 if the character is not valid.
types:
  chunk:
    seq:
      - id: id
        size: 4
        type: str
      - id: len_body
        type: u4
      - id: body
        size: len_body
        type:
          switch-on: id
          cases:
            '"vrsn"': version_chunk
            '"LIST"': list_chunk
      - id: padding
        size: len_body % 2
        doc: Chunks are padded to an even length.
  version_chunk:
    seq:
      - id: version
        type: u2
        doc: CorelDRAW version times 100 (e.g. 1500 = X7).
  list_chunk:
    seq:
      - id: list_type
        size: 4
        type: str
      - id: body
        size-eos: true
        type:
          switch-on: list_type
          cases:
            '"cmpr"': compressed_list
            '"stlt"': text_styles
            _: chunk_list
  chunk_list:
    seq:
      - id: chunks
        type: chunk
        repeat: eos
  text_styles:
    doc: |
      Body of a `LIST` chunk of type `stlt` (text styles). Up to version 6
      it is a chunk sequence like any other list; since version 7 it is a
      single record of style tables, kept raw here.
    seq:
      - id: chunks
        type: chunk
        repeat: eos
        if: _root.version < 700
      - id: data
        size-eos: true
        if: _root.version >= 700
  compressed_list:
    seq:
      - id: len_part1
        type: u4
        doc: Size of part 1 including its 8-byte CPng header.
      - id: len_part1_unpacked
        type: u4
      - id: len_part2
        type: u4
        doc: Size of part 2 including its 8-byte CPng header.
      - id: len_part2_unpacked
        type: u4
      - id: part1
        size: len_part1
        type: cpng_block
        doc: Part 1, decompressing to a chunk sequence with indexed sizes.
      - id: part2
        size: len_part2
        type: cpng_size_table
        doc: Part 2, decompressing to the table of chunk sizes.
  cpng_block:
    seq:
      - id: magic
        contents: CPng
      - id: unknown1
        contents: [0x01, 0x00]
      - id: unknown2
        contents: [0x04, 0x00]
      - id: data
        size-eos: true
        process: zlib
  cpng_size_table:
    seq:
      - id: magic
        contents: CPng
      - id: unknown1
        contents: [0x01, 0x00]
      - id: unknown2
        contents: [0x04, 0x00]
      - id: sizes
        size-eos: true
        type: size_table
        process: zlib
  size_table:
    seq:
      - id: sizes
        type: u4
        repeat: eos
