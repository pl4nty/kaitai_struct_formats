meta:
  id: blizzard_mpq
  title: Blizzard MPQ (Mo'PaQ) archive
  application:
    - Blizzard games (Diablo, StarCraft, Warcraft III, World of Warcraft, StarCraft II)
    - StormLib
  file-extension:
    - mpq
    - sc2replay
    - sc2map
    - w3m
    - w3x
  xref:
    justsolve: MPQ
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  MPQ ("Mike O'Brien PaCK") is the archive format used by Blizzard
  Entertainment games. An archive starts with an MPQ header (`MPQ\x1A`),
  optionally preceded by an MPQ user data header (`MPQ\x1B`, used by
  StarCraft II replays and maps) that points to it. The header locates the
  hash table and the block table (and, in newer versions, the hi-block table
  and the HET/BET tables); all positions are relative to the start of the MPQ
  header.

  This spec parses the user data header and all four versions of the MPQ
  header, and locates the hash, block and hi-block tables. The hash and block
  tables are encrypted with keys derived from the strings `(hash table)` and
  `(block table)` (see StormLib), so they are exposed as raw bytes; the
  unencrypted hi-block table is parsed. File data, which can only be located
  through the decrypted block table, is not covered.

  The spec expects the archive (or the user data header) at the start of the
  file. When an MPQ is embedded in another file (e.g. an installer), it
  starts at an offset that is a multiple of 512, which has to be searched for.
doc-ref:
  - https://web.archive.org/web/2024/http://www.zezula.net/en/mpq/mpqformat.html
  - https://github.com/ladislav-zezula/StormLib/blob/d60b7e6d3501474f4d92c7b9c752a37e78385f67/src/StormLib.h
  - https://github.com/eagleflo/mpyq/blob/6bfba18ec403f702666b4109db3d95f3b97b1dc5/mpyq.py
seq:
  - id: magic
    type: u4
    valid:
      any-of: [0x1a51504d, 0x1b51504d]
    doc: '`MPQ\x1A` for an MPQ header, `MPQ\x1B` for an MPQ user data header.'
  - id: user_data
    type: user_data_header
    if: has_user_data
instances:
  has_user_data:
    value: magic == 0x1b51504d
  ofs_archive:
    value: 'has_user_data ? user_data.ofs_mpq_header : 0'
    doc: Offset of the MPQ header (start of the archive) in the file.
  header:
    pos: ofs_archive
    type: mpq_header
  hash_table:
    pos: ofs_archive + header.ofs_hash_table
    size: header.num_hash_table_entries * 16
    doc: Encrypted hash table, 16 bytes per entry.
  block_table:
    pos: ofs_archive + header.ofs_block_table
    size: header.num_block_table_entries * 16
    doc: Encrypted block table, 16 bytes per entry.
  hi_block_table:
    pos: ofs_archive + header.ofs_hi_block_table
    type: u2
    repeat: expr
    repeat-expr: header.num_block_table_entries
    if: header.format_version >= 1 and header.ofs_hi_block_table != 0
    doc: Upper 16 bits of the file offsets of the block table entries.
types:
  user_data_header:
    seq:
      - id: len_user_data
        type: u4
        doc: Maximum size of the user data.
      - id: ofs_mpq_header
        type: u4
        doc: Offset of the MPQ header, relative to the start of the file.
      - id: len_user_data_header
        type: u4
      - id: user_data_header
        size: len_user_data_header
        doc: |
          Application-defined data (in StarCraft II replays, a serialized structure with
          the game version).
  mpq_header:
    seq:
      - id: magic
        contents: [MPQ, 0x1a]
      - id: len_header
        type: u4
      - id: len_archive_v1
        type: u4
        doc: Size of the archive; deprecated since format version 2.
      - id: format_version
        type: u2
        doc: |
          0 for format 1, 1 for format 2 (The Burning Crusade), 2 and 3 for formats 3 and
          4 (Cataclysm and later).
      - id: sector_size_shift
        type: u2
        doc: The size of each logical sector is `512 << sector_size_shift`.
      - id: ofs_hash_table_lo
        type: u4
      - id: ofs_block_table_lo
        type: u4
      - id: num_hash_table_entries
        type: u4
        doc: Number of entries in the hash table, a power of two.
      - id: num_block_table_entries
        type: u4
      # Format 2
      - id: ofs_hi_block_table
        type: u8
        if: format_version >= 1
      - id: ofs_hash_table_hi
        type: u2
        if: format_version >= 1
      - id: ofs_block_table_hi
        type: u2
        if: format_version >= 1
      # Format 3
      - id: len_archive_v3
        type: u8
        if: format_version >= 2
      - id: ofs_bet_table
        type: u8
        if: format_version >= 2
      - id: ofs_het_table
        type: u8
        if: format_version >= 2
      # Format 4
      - id: len_hash_table_compressed
        type: u8
        if: format_version >= 3
      - id: len_block_table_compressed
        type: u8
        if: format_version >= 3
      - id: len_hi_block_table_compressed
        type: u8
        if: format_version >= 3
      - id: len_het_table_compressed
        type: u8
        if: format_version >= 3
      - id: len_bet_table_compressed
        type: u8
        if: format_version >= 3
      - id: raw_chunk_size
        type: u4
        if: format_version >= 3
        doc: Size of the raw data chunks whose MD5 follows the raw file data.
      - id: md5_block_table
        size: 16
        if: format_version >= 3
      - id: md5_hash_table
        size: 16
        if: format_version >= 3
      - id: md5_hi_block_table
        size: 16
        if: format_version >= 3
      - id: md5_bet_table
        size: 16
        if: format_version >= 3
      - id: md5_het_table
        size: 16
        if: format_version >= 3
      - id: md5_mpq_header
        size: 16
        if: format_version >= 3
    instances:
      sector_size:
        value: 512 << sector_size_shift
      ofs_hash_table:
        value: |
          format_version >= 1
            ? (ofs_hash_table_hi.as<u8> << 32) | ofs_hash_table_lo
            : ofs_hash_table_lo
        doc: Offset of the hash table, relative to the start of the MPQ header.
      ofs_block_table:
        value: |
          format_version >= 1
            ? (ofs_block_table_hi.as<u8> << 32) | ofs_block_table_lo
            : ofs_block_table_lo
        doc: Offset of the block table, relative to the start of the MPQ header.
