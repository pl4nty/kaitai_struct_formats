meta:
  id: vcdiff
  title: VCDIFF generic differencing and compression data format
  application:
    - xdelta3
    - open-vcdiff
  file-extension:
    - vcdiff
    - xdelta
  xref:
    rfc: 3284
  license: CC0-1.0
  ks-version: '0.9'
  imports:
    - /common/vlq_base128_be
doc: |
  VCDIFF is a delta encoding format: a delta file describes how to reconstruct
  a target file from a source file (or from itself) with COPY, ADD and RUN
  instructions. It is used by xdelta3 and open-vcdiff (as used in SDCH), among
  others.

  A delta file is a header followed by a sequence of windows. Each window
  encodes one target window and consists of three sections: the data section
  for ADD and RUN instructions, the instructions and sizes section, and the
  addresses section for COPY instructions. All integers are unsigned,
  variable-length base-128 numbers with the most significant group first.

  This spec covers the header and all windows, including the xdelta3
  extensions (application header, `VCD_ADLER32` window checksum) and the
  open-vcdiff window checksum. When the default code table is in use and the
  instructions section is not compressed by a secondary compressor, the
  instructions section is parsed into instruction codes with their separately
  coded sizes, and the instruction types, sizes and address modes are derived
  from the RFC 3284 default code table. Secondary-compressed sections and
  application-defined code tables
  are kept as raw bytes. COPY addresses and the actual reconstruction of the
  target are not decoded.

  open-vcdiff's interleaved format (fourth header byte `S`) uses the same
  window layout, with a variable-length checksum, but puts the instructions,
  sizes, data and addresses all into the instructions section; that section
  is kept as raw bytes.
doc-ref:
  - https://www.rfc-editor.org/rfc/rfc3284
  - https://github.com/jmacd/xdelta/blob/b01ee2a30275708de2e9a372ce2aa954e5361a43/xdelta3/xdelta3-decode.h
  - https://github.com/google/open-vcdiff/blob/868f459a8d815125c2457f8c74b12493853100f9/src/headerparser.cc
seq:
  - id: magic
    contents: [0xd6, 0xc3, 0xc4]
  - id: version
    type: u1
    doc: |
      Version of VCDIFF; 0 in RFC 3284. open-vcdiff uses 0x53 (`S`) for its
      interleaved extension.
  - id: header_indicator
    type: header_indicator
  - id: secondary_compressor_id
    type: u1
    enum: secondary_compressor
    if: header_indicator.secondary_compression
  - id: len_code_table_data
    type: vlq_base128_be
    if: header_indicator.code_table
  - id: code_table_data
    size: len_code_table_data.value
    type: code_table_data
    if: header_indicator.code_table
  - id: len_app_header
    type: vlq_base128_be
    if: header_indicator.app_header
  - id: app_header
    size: len_app_header.value
    if: header_indicator.app_header
    doc: |
      xdelta3 extension: application-defined data, by default the source and
      target file names and the secondary compressor used by `xdelta3 -e`,
      as `target//source/` with optional `/` separated parts.
  - id: windows
    type: window
    repeat: eos
types:
  header_indicator:
    seq:
      - id: reserved
        type: b5
      - id: app_header
        type: b1
        doc: xdelta3 extension (VCD_APPHEADER).
      - id: code_table
        type: b1
        doc: VCD_CODETABLE, an application-defined code table is supplied.
      - id: secondary_compression
        type: b1
        doc: VCD_DECOMPRESS, a secondary compressor may have been used.
  code_table_data:
    seq:
      - id: near_cache_size
        type: u1
      - id: same_cache_size
        type: u1
      - id: compressed_code_table
        size-eos: true
        doc: |
          The code table, delta-encoded against the default code table
          (see section 7 of RFC 3284).
  window:
    seq:
      - id: window_indicator
        type: window_indicator
      - id: len_source_segment
        type: vlq_base128_be
        if: window_indicator.source or window_indicator.target
      - id: ofs_source_segment
        type: vlq_base128_be
        if: window_indicator.source or window_indicator.target
        doc: |
          Position of the source segment in the source file (VCD_SOURCE) or target file
          (VCD_TARGET).
      - id: len_delta_encoding
        type: vlq_base128_be
      - id: delta_encoding
        size: len_delta_encoding.value
        type: delta_encoding
  window_indicator:
    seq:
      - id: reserved
        type: b5
      - id: adler32
        type: b1
        doc: |
          xdelta3 (VCD_ADLER32) and open-vcdiff (VCD_CHECKSUM) extension, the
          window has an Adler-32 checksum of the target window.
      - id: target
        type: b1
        doc: VCD_TARGET, the source segment comes from the target file decoded so far.
      - id: source
        type: b1
        doc: VCD_SOURCE, the source segment comes from the source file.
  delta_encoding:
    seq:
      - id: len_target_window
        type: vlq_base128_be
      - id: delta_indicator
        type: delta_indicator
      - id: len_data
        type: vlq_base128_be
      - id: len_instructions
        type: vlq_base128_be
      - id: len_addresses
        type: vlq_base128_be
      - id: adler32
        type: u4be
        if: _parent.window_indicator.adler32 and _root.version != 0x53
        doc: xdelta3 extension, Adler-32 checksum of the target window.
      - id: adler32_open_vcdiff
        type: vlq_base128_be
        if: _parent.window_indicator.adler32 and _root.version == 0x53
        doc: open-vcdiff extension, Adler-32 checksum of the target window.
      - id: data
        size: len_data.value
        doc: Unmatched data for ADD and RUN instructions.
      - id: instructions
        size: len_instructions.value
        type: instructions
        if: is_instructions_parseable
      - id: instructions_raw
        size: len_instructions.value
        if: not is_instructions_parseable
      - id: addresses
        size: len_addresses.value
        doc: Encoded addresses of the COPY instructions.
    instances:
      is_instructions_parseable:
        value: not _root.header_indicator.code_table and not delta_indicator.instructions_compressed and _root.version == 0
  delta_indicator:
    seq:
      - id: reserved
        type: b5
      - id: addresses_compressed
        type: b1
        doc: VCD_ADDRCOMP
      - id: instructions_compressed
        type: b1
        doc: VCD_INSTCOMP
      - id: data_compressed
        type: b1
        doc: VCD_DATACOMP
  instructions:
    seq:
      - id: instructions
        type: instruction
        repeat: eos
  instruction:
    doc: |
      An index into the RFC 3284 default code table, followed by the sizes
      that are not implied by the table entry. In the default table, only
      single instructions may have a separately coded size, so there is at
      most one.
    seq:
      - id: code
        type: u1
      - id: size
        type: vlq_base128_be
        if: has_size
        doc: Size of the first (and only) instruction, if not implied by the code.
    instances:
      has_size:
        value: code <= 1 or (code >= 19 and code <= 162 and (code - 19) % 16 == 0)
      inst1_type:
        value: |
          (code == 0 ? instruction_type::run
          : code <= 18 ? instruction_type::add
          : code <= 162 ? instruction_type::copy
          : code <= 246 ? instruction_type::add
          : instruction_type::copy)
      inst1_size:
        value: |
          has_size ? size.value
          : code <= 18 ? code - 1
          : code <= 162 ? (code - 19) % 16 + 3
          : code <= 234 ? (code - 163) % 12 / 3 + 1
          : code <= 246 ? (code - 235) % 4 + 1
          : 4
        doc: Size of the first instruction.
      inst1_mode:
        value: |
          code < 19 or (code >= 163 and code <= 246) ? 0
          : code <= 162 ? (code - 19) / 16
          : code - 247
        doc: Address mode of the first instruction, if it is a COPY.
      inst2_type:
        value: |
          code <= 162 ? instruction_type::noop
          : code <= 246 ? instruction_type::copy
          : instruction_type::add
      inst2_size:
        value: |
          code <= 162 ? 0
          : code <= 234 ? (code - 163) % 3 + 4
          : code <= 246 ? 4
          : 1
        doc: Size of the second instruction.
      inst2_mode:
        value: |
          code >= 163 and code <= 234 ? (code - 163) / 12
          : code >= 235 and code <= 246 ? (code - 235) / 4 + 6
          : 0
        doc: Address mode of the second instruction, if it is a COPY.
enums:
  instruction_type:
    0: noop
    1: add
    2: run
    3: copy
  secondary_compressor:
    1: djw
    2: lzma
    16: fgk
