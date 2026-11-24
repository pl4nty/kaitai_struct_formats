meta:
  id: pea
  title: PeaZIP archive file
  application:
    - PeaZIP
    - PEA
    - UnPEA
  file-extension: pea
  xref:
    wikidata: Q1275912
  license: Unlicense
  endian: le
doc: |
  Format for PeaZIP archiver. WARNING: don't design formats like this!

  This spec covers the plaintext headers at the start of the first volume:
  the 10-byte archive header, the 10-byte stream header, the crypto
  subheader(s) when the stream control algorithm is an authenticated
  encryption scheme, and the compression buffer size. Everything after
  that is either compressed or encrypted. For the triple-cipher schemes
  (`TRIATS` and friends), the writer appends 1..128 bytes of encrypted
  random padding after the subheaders, so the compression buffer size
  cannot be located without decrypting.
doc-ref:
  - https://github.com/peazip/PeaZip/blob/ded9d2d94100969a48c8ccfe934c4b6e358b697f/peazip-sources/dev/pea_utils.pas
  - https://github.com/peazip/PeaZip/blob/ded9d2d94100969a48c8ccfe934c4b6e358b697f/peazip-sources/dev/pea.pas
seq:
  - id: archive_header
    type: archive_header
  - id: stream_header
    type: stream_header
  - id: crypto_subheaders
    type: crypto_subheader
    repeat: expr
    repeat-expr: 'stream_header.is_triple_cipher ? 3 : 1'
    if: stream_header.requires_password
  - id: compression_buffer_size
    -orig-id: WBUFSIZE
    type: u4
    if: stream_header.compression_algo.compress and not stream_header.requires_password
    doc: Size of the buffer that is compressed at once.
  - id: compression_buffer_size_encrypted
    size: 4
    if: >-
      stream_header.compression_algo.compress and
      stream_header.requires_password and
      not stream_header.is_triple_cipher
    doc: |
      `compression_buffer_size`, encrypted with the stream control
      algorithm.
types:
  archive_header:
    -orig-id: pea_archive_hdr
    seq:
      - id: signature
        contents: [0xea]
      - id: format_version
        -orig-id: PEA_FILEFORMAT_VER
        type: u1
      - id: format_revision
        -orig-id: PEA_FILEFORMAT_REV
        type: u1
      - id: volume_control_algo
        type: u1
        enum: control_algo
        doc: |
          Integrity check of each volume. Only the non-keyed algorithms
          (`none` to `blake2b`) are valid here.
      - id: archive_ecc_scheme
        type: u1
        doc: Archive-wide ECC scheme. Always 0, no ECC scheme is implemented.
      - id: os
        -orig-id: get_OS
        type: u1
        enum: os
      - id: date_time_encoding
        -orig-id: get_system_datetimeencoding
        type: u1
        enum: date_time_encoding
      - id: string_encoding
        type: u1
        enum: string_encoding
      - id: cpu
        -orig-id: get_CPUe
        type: cpu_type
      - id: kdf_iteration_multiplier
        -orig-id: niter
        type: u1
        doc: |
          Cost setting for the key derivation function of the triple-cipher
          schemes, not an iteration count: PBKDF2 runs
          `kdf_iteration_multiplier * 100000 + 25000` iterations, and scrypt
          picks its memory and parallelism from it. Reserved (0) in older
          revisions.
  stream_header:
    -orig-id: pea_stream_hdr
    seq:
      - id: trigger
        contents: [0, 0]
      - id: pea_pod_signature
        contents: ["POD", 0]
      - id: compression_algo
        -orig-id: encode_compression
        type: compression_algo
      - id: stream_ecc_scheme
        type: u1
        doc: Stream-wide ECC scheme. Always 0, no ECC scheme is implemented.
      - id: stream_control_algo
        -orig-id: encode_algo_stream
        type: u1
        enum: control_algo
      - id: object_control_algo
        -orig-id: encode_algo_nonstream
        type: u1
        enum: control_algo
        doc: |
          Integrity check of each object. Only the non-keyed algorithms
          (`none` to `blake2b`) are valid here.
    instances:
      requires_password:
        value: stream_control_algo.to_i >= 0x30
        doc: |
          HMAC and the authenticated encryption schemes (codes 0x30 and up)
          need a password and are followed by a crypto subheader.
      is_triple_cipher:
        value: stream_control_algo.to_i >= 0x44 and stream_control_algo.to_i <= 0x4c
        doc: |
          Cascades of three ciphers, followed by three crypto subheaders
          (one per cipher) and encrypted random padding.
    types:
      compression_algo:
        seq:
          - id: algo
            -orig-id: PCOMPRESS0..PCOMPRESS3
            type: u1
        instances:
          compress:
            value: algo > 0
          deflate_level:
            value: algo * 3
            if: compress
  cpu_type:
    seq:
      - id: is_big_endian
        -orig-id: ENDIAN_BIG
        type: b1
      - id: instruction_set
        type: b7
        enum: cpu
    enums:
      cpu:
        0x00: unknown
        0x01:
          id: generic_32_bit
          -orig-id: CPU32
        0x02:
          id: generic_64_bit
          -orig-id: CPU64
        0x11:
          id: i8086
          -orig-id: CPU86
        0x12:
          id: i8087
          -orig-id: CPU87
        0x13:
          id: i386
          -orig-id: CPUI386
        0x21:
          id: x86_64
          -orig-id: CPUX86_64
        0x31:
          id: m68k
          -orig-id: CPU68k
        0x32:
          id: m68020
          -orig-id: CPUM68020
        0x33:
          id: m68
          -orig-id: CPU68
        0x34:
          id: sparc
          -orig-id: CPUSPARC
        0x35:
          id: alpha
          -orig-id: CPUALPHA
        0x36:
          id: power_pc
          -orig-id: CPUPOWERPC
  crypto_subheader:
    -orig-id: TFCAHdr
    doc: |
      Header of the "file crypt/authenticate" (FCA) units of
      W. Ehrhardt's crypto library, which PEA uses for its keyed schemes.
      The signature and flags bytes are zeroed, the information is in the
      stream header instead.
    seq:
      - id: fca_sig
        -orig-id: FCAsig
        type: u1
      - id: flags
        type: u1
      - id: salt
        type: u4
        repeat: expr
        repeat-expr: 3
      - id: password_verifier
        -orig-id: PW_Ver
        type: u2
        doc: |
          Derived from the key material, to reject a wrong password early.
          For the triple-cipher schemes it is zero in the first two
          subheaders, and the third one holds the XOR of the three
          verifiers.
enums:
  control_algo:
    0x00:
      id: none
      -orig-id: NOALGO
    0x01:
      id: adler32
      -orig-id: ADLER32
    0x02:
      id: crc32
      -orig-id: CRC32
    0x03:
      id: crc64
      -orig-id: CRC64
    0x10:
      id: md5
      -orig-id: MD5
    0x11:
      id: ripemd160
      -orig-id: RIPEMD160
    0x12:
      id: sha1
      -orig-id: SHA1
    0x13:
      id: sha256
      -orig-id: SHA256
    0x14:
      id: sha512
      -orig-id: SHA512
    0x15:
      id: whirlpool
      -orig-id: WHIRLPOOL
    0x16:
      id: sha3_256
      -orig-id: SHA3_256
    0x17:
      id: sha3_512
      -orig-id: SHA3_512
    0x18:
      id: blake2s
      -orig-id: BLAKE2S
    0x19:
      id: blake2b
      -orig-id: BLAKE2B
    0x30:
      id: hmac
      -orig-id: HMAC
      doc: AES-128 in CTR mode, authenticated with HMAC-SHA1. Encrypts too.
    0x31:
      id: aes128_eax
      -orig-id: EAX
    0x32:
      id: twofish128_eax
      -orig-id: TF
    0x33:
      id: serpent128_eax
      -orig-id: SP
    0x41:
      id: aes256_eax
      -orig-id: EAX256
    0x42:
      id: twofish256_eax
      -orig-id: TF256
    0x43:
      id: serpent256_eax
      -orig-id: SP256
    0x44:
      id: aes_twofish_serpent_pbkdf2
      -orig-id: TRIATS
    0x45:
      id: twofish_serpent_aes_pbkdf2
      -orig-id: TRITSA
    0x46:
      id: serpent_aes_twofish_pbkdf2
      -orig-id: TRISAT
    0x47:
      id: aes_twofish_serpent_scrypt
      -orig-id: SRIATS
    0x48:
      id: twofish_serpent_aes_scrypt
      -orig-id: SRITSA
    0x49:
      id: serpent_aes_twofish_scrypt
      -orig-id: SRISAT
    0x4a:
      id: aes_twofish_serpent_hybrid_kdf
      -orig-id: HRIATS
    0x4b:
      id: twofish_serpent_aes_hybrid_kdf
      -orig-id: HRITSA
    0x4c:
      id: serpent_aes_twofish_hybrid_kdf
      -orig-id: HRISAT
  os:
    0x00: unknown
    0x10:
      id: generic_windows
      -orig-id: MSWINDOWS
    0x11:
      id: win_32
      -orig-id: WIN32
    0x12:
      id: win_64
      -orig-id: WIN64
    0x13:
      id: win_ce
      -orig-id: WINCE
    0x21:
      id: go32v2
      -orig-id: GO32V2
    0x22:
      id: os2
      -orig-id: OS2
    0x30:
      id: generic_nix
      -orig-id: UNIX
    0x31:
      id: free_bsd
      -orig-id: FREEBSD
    0x32:
      id: net_bsd
      -orig-id: NETBSD
    0x33:
      id: linux
      -orig-id: LINUX
    0x34:
      id: beos
      -orig-id: BEOS
    0x35:
      id: qnx
      -orig-id: QNX
    0x36:
      id: sunos
      -orig-id: SUNOS
    0x37:
      id: darwin
      -orig-id: DARWIN
    0x38:
      id: open_bsd
      -orig-id: OPENBSD
    0x51:
      id: amiga
      -orig-id: AMIGA
    0x52:
      id: atari_tos
      -orig-id: ATARI
    0x53:
      id: mac_classic
      -orig-id: MAC
    0x54:
      id: palm_os
      -orig-id: PALMOS
  date_time_encoding:
    0x00: unknown
    0x10: windows
    0x30: unix
    0x53: mac_classic
  string_encoding:
    0x01: ansi
