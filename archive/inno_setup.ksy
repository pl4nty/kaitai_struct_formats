meta:
  id: inno_setup
  title: Inno Setup installer
  application: Inno Setup
  file-extension: exe
  license: MIT OR Apache-2.0
  ks-version: '0.11'
  encoding: ASCII
  endian: le
doc: |
  An Inno Setup installer is a small loader executable followed by the
  compressed setup program (`setup.e32`), the setup header (`setup-0`) and
  the compressed files (`setup-1`), or with the files in separate
  `setup-N.bin` slices beside the executable.

  The loader finds them through the setup loader offset table. Before
  Inno Setup 5.1.5 its offset is stored at offset 0x34 of the executable,
  after the magic "Inno" at 0x30 (and followed by its bitwise NOT). Since
  5.1.5 the table is the `RCDATA` resource with ID 11111. Pass the offset
  of the table as `ofs_offset_table`; searching for its signature
  ("rDlPtS" or "nS5W7dT") also works.

  `setup-0` starts with a 64-byte version string and, since Inno Setup
  6.5, an encryption header. It then holds two compressed streams: the
  primary stream (the setup header and all of its entries) and the file
  location stream. Each stream has a CRC-protected header that gives its
  stored size and whether it is compressed (zlib before 4.1.6, LZMA
  since), followed by the stored data in blocks of up to 4 KiB, each
  preceded by its CRC-32. The compressed data is the concatenation of the
  block payloads; it is joined and checked with kaitai_compress's
  `crc32_chunks` process and then decompressed with `zlib` or
  `lzma_props`. The decompressed setup header and entries, whose layout
  changes with almost every release, are not parsed here.
doc-ref:
  - https://github.com/russellbanks/inno/tree/v0.7.6/core/src
  - https://github.com/devicie/Komac-anthelion/blob/f9b303df556625ef39215e9c66e08ca037829866/src/analysis/installers/exe.rs
  - https://github.com/jrsoftware/issrc/blob/is-6_7_3/Projects/Src/Shared.Struct.pas
params:
  - id: ofs_offset_table
    type: u8
    doc: Offset of the setup loader offset table in the executable.
instances:
  offset_table:
    pos: ofs_offset_table
    type: offset_table
  setup_0:
    pos: offset_table.ofs_header
    type: setup_0
    if: offset_table.ofs_header != 0
types:
  offset_table:
    -orig-id: TSetupLdrOffsetTable
    seq:
      - id: signature
        -orig-id: ID
        size: 12
        valid:
          any-of:
            - '[0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0x30, 0x32, 0x87, 0x65, 0x56, 0x78]'
            - '[0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0x30, 0x34, 0x87, 0x65, 0x56, 0x78]'
            - '[0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0x30, 0x35, 0x87, 0x65, 0x56, 0x78]'
            - '[0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0x30, 0x36, 0x87, 0x65, 0x56, 0x78]'
            - '[0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0x30, 0x37, 0x87, 0x65, 0x56, 0x78]'
            - '[0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0xcd, 0xe6, 0xd7, 0x7b, 0x0b, 0x2a]'
            - '[0x6e, 0x53, 0x35, 0x57, 0x37, 0x64, 0x54, 0x83, 0xaa, 0x1b, 0x0f, 0x6a]'
        doc: |
          Identifies the layout of the table, and through it the earliest
          Inno Setup version that wrote it.
      - id: revision
        -orig-id: Version
        type: u4
        if: loader_version >= 50105
        doc: '`SetupLdrOffsetTableVersion`: 1, or 2 for 64-bit offsets.'
      - id: total_size_u4
        type: u4
        if: not has_64_bit_offsets
      - id: total_size_s8
        type: s8
        if: has_64_bit_offsets
      - id: ofs_exe_u4
        type: u4
        if: not has_64_bit_offsets
      - id: ofs_exe_s8
        type: s8
        if: has_64_bit_offsets
      - id: len_exe_compressed
        -orig-id: CompressedSizeEXE
        type: u4
        if: loader_version < 40106
      - id: len_exe_uncompressed
        -orig-id: UncompressedSizeEXE
        type: u4
      - id: checksum_exe
        -orig-id: CRCEXE
        type: u4
        doc: CRC-32 of the uncompressed `setup.e32` (Adler-32 before 4.0.3).
      - id: ofs_message
        type: u4
        if: loader_version < 40000
      - id: ofs_header_u4
        type: u4
        if: not has_64_bit_offsets
      - id: ofs_header_s8
        type: s8
        if: has_64_bit_offsets
      - id: ofs_data_u4
        type: u4
        if: not has_64_bit_offsets
      - id: ofs_data_s8
        type: s8
        if: has_64_bit_offsets
      - id: reserved_padding
        type: u4
        if: has_64_bit_offsets
      - id: checksum
        -orig-id: TableCRC
        type: u4
        if: loader_version >= 40010
        doc: CRC-32 of the preceding fields of the table.
    instances:
      loader_version:
        value: |
          signature == [0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0x30, 0x32, 0x87, 0x65, 0x56, 0x78] ? 10210
          : signature == [0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0x30, 0x34, 0x87, 0x65, 0x56, 0x78] ? 40000
          : signature == [0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0x30, 0x35, 0x87, 0x65, 0x56, 0x78] ? 40003
          : signature == [0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0x30, 0x36, 0x87, 0x65, 0x56, 0x78] ? 40010
          : signature == [0x72, 0x44, 0x6c, 0x50, 0x74, 0x53, 0x30, 0x37, 0x87, 0x65, 0x56, 0x78] ? 40106
          : 50105
        doc: |
          Earliest Inno Setup version with this signature, as
          major * 10000 + minor * 100 + patch. "rDlPtS02" to "rDlPtS07"
          are 1.2.10, 4.0.0, 4.0.3, 4.0.10 and 4.1.6; both
          `rDlPtS CD E6 D7 7B 0B 2A` and `nS5W7dT 83 AA 1B 0F 6A` are 5.1.5.
      has_64_bit_offsets:
        value: loader_version >= 50105 and revision >= 2
      total_size:
        -orig-id: TotalSize
        value: 'has_64_bit_offsets ? total_size_s8 : total_size_u4'
        doc: Minimum expected size of the executable.
      ofs_exe:
        -orig-id: OffsetEXE
        value: 'has_64_bit_offsets ? ofs_exe_s8 : ofs_exe_u4'
        doc: Offset of the compressed `setup.e32`.
      ofs_header:
        -orig-id: Offset0
        value: 'has_64_bit_offsets ? ofs_header_s8 : ofs_header_u4'
        doc: Offset of `setup-0`, the setup header.
      ofs_data:
        -orig-id: Offset1
        value: 'has_64_bit_offsets ? ofs_data_s8 : ofs_data_u4'
        doc: |
          Offset of `setup-1`, the file data, or 0 if it is in separate
          `.bin` slices.
  setup_0:
    seq:
      - id: version
        -orig-id: SetupID
        size: 64
        type: version_string
      - id: encryption_header
        type: encryption_header
        if: version.number >= 60500
      - id: primary_stream
        type: stream
        doc: The setup header and its entries (languages, files, registry...).
      - id: file_location_stream
        type: stream
        doc: The file location entries (`TSetupFileLocationEntry`).
  version_string:
    doc: |
      For example "Inno Setup Setup Data (5.5.7) (u)", where "(u)" (or
      "(U)") marks a Unicode installer before Inno Setup 6.3, which is
      always Unicode. Some versions have a fourth component, such as
      "(6.4.0.1)".
    seq:
      - id: prefix
        type: str
        terminator: 0x28
        doc: Text before the version, such as "Inno Setup Setup Data ".
      - id: major
        type: str
        terminator: 0x2e
      - id: minor
        type: str
        terminator: 0x2e
      - id: patch_and_revision
        type: patch_and_revision
        terminator: 0x29
      - id: suffix
        type: strz
        doc: Text after the version, such as " (u)".
    instances:
      number:
        value: major.to_i * 10000 + minor.to_i * 100 + patch_and_revision.patch.to_i
        doc: The first three components, as major * 10000 + minor * 100 + patch.
      is_unicode:
        value: number >= 60300 or suffix == " (u)" or suffix == " (U)"
    types:
      patch_and_revision:
        seq:
          - id: patch
            type: str
            terminator: 0x2e
            eos-error: false
          - id: revision
            size-eos: true
            type: str
            doc: The fourth component, or empty.
  encryption_header:
    -orig-id: TSetupEncryptionHeader
    seq:
      - id: checksum
        type: u4
        doc: CRC-32 of the rest of the encryption header.
      - id: encryption_use
        -orig-id: EncryptionUse
        type: u1
        enum: encryption_use
      - id: kdf_salt
        -orig-id: KDFSalt
        size: 16
      - id: kdf_iterations
        -orig-id: KDFIterations
        type: u4
      - id: base_nonce
        -orig-id: BaseNonce
        type: encryption_nonce
      - id: password_test
        -orig-id: PasswordTest
        type: u4
    enums:
      encryption_use:
        0: none
        1: files
        2: full
  encryption_nonce:
    seq:
      - id: random_xor_start_offset
        type: u8
      - id: random_xor_first_slice
        type: u4
      - id: remaining_random
        type: u4
        repeat: expr
        repeat-expr: 3
  stream:
    seq:
      - id: header
        type: stream_header
      - id: data
        size: header.len_blocks
        type: stream_data(header.compression)
        process: kaitai.compress.crc32_chunks(4096)
        doc: The stream with the block CRCs checked and removed.
  stream_header:
    seq:
      - id: checksum
        type: u4
        doc: CRC-32 of the rest of the stream header.
      - id: len_stored_u4
        type: u4
        if: version >= 40009 and version < 60700
      - id: len_stored_u8
        type: u8
        if: version >= 60700
      - id: is_compressed_flag
        type: u1
        if: version >= 40009
      - id: len_compressed_old
        type: u4
        if: version < 40009
      - id: len_uncompressed_old
        type: u4
        if: version < 40009
    instances:
      version:
        value: _parent._parent.version.number
      is_compressed:
        value: 'version >= 40009 ? is_compressed_flag != 0 : len_compressed_old != 0xffff_ffff'
      compression:
        value: |
          not is_compressed ? compression::stored
          : version >= 40106 ? compression::lzma
          : compression::zlib
        enum: compression
        doc: |
          LZMA streams start with the 5-byte LZMA properties and dictionary
          size; there is no uncompressed size, and the stream ends with an
          end marker.
      len_payload_old:
        value: 'len_compressed_old == 0xffff_ffff ? len_uncompressed_old : len_compressed_old'
        if: version < 40009
      len_blocks:
        value: |
          version >= 60700 ? len_stored_u8
          : version >= 40009 ? len_stored_u4
          : len_payload_old + (len_payload_old + 4095) / 4096 * 4
        doc: |
          Size of the blocks that follow, including their CRCs. Before
          4.0.9 the header gives the size of the payload alone.
    enums:
      compression:
        0: stored
        1: zlib
        2: lzma
  stream_data:
    params:
      - id: compression
        type: u1
        enum: stream_header::compression
    seq:
      - id: stored
        size-eos: true
        if: compression == stream_header::compression::stored
      - id: zlib
        size-eos: true
        process: zlib
        if: compression == stream_header::compression::zlib
      - id: lzma
        size-eos: true
        process: kaitai.compress.lzma_props
        if: compression == stream_header::compression::lzma
    instances:
      contents:
        value: |
          compression == stream_header::compression::lzma ? lzma
          : compression == stream_header::compression::zlib ? zlib
          : stored
        doc: |
          The decompressed stream.
