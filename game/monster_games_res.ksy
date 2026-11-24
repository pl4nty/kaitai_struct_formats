# Imported from https://github.com/TheGameCommunity/ExciteModder/blob/82eadbf9fafb5b699a5247fc4737e7eee22289fe/src/main/resources/kaitai/monster_res.ksy
meta:
  id: monster_games_res
  title: Monster Game Resource
  file-extension: res
  license: LicenseRef-All-Rights-Reserved
  imports: /archive/quicklz_rcmp
  endian: le
seq:
  - id: header
    type: header
  - id: data
    type: data
types:
  header:
    seq:
      - id: magic_1
        size: 4
        contents: "0TSR"
      - id: size_header
        type: u4
      - id: version
        type: u4
      - id: compression_bitfield
        type: b1
        repeat: expr
        repeat-expr: 32
      - id: archive_size
        type: u4
      - id: unix_timestamp
        type: u4
        doc: Creation Date
      - id: rcmp_offset
        type: u4
      - id: unknown_1
        type: u4
      - id: num_file
        type: u4
      - id: uncompressed_size
        type: u4
        doc: Add 128
      - id: compressed_size
        type: u4
        doc: Add 128
      - id: compressed
        type: u4
        doc: 128 if compressed 0 if uncompressed
      - id: unknown_3
        type: u4
      - id: filename_dirlen
        type: u4
      - id: unknown_4
        type: u4
      - id: hash
        type: u4
      - id: unknown_5
        type: u1
        repeat: expr
        repeat-expr: 64
  data:
    seq:
      - id: compressed_data
        type: quicklz_rcmp
        if: _root.header.compressed == 128
      - id: uncompressed_data
        size-eos: true
        if: _root.header.compressed == 0
