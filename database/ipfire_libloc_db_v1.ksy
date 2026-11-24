# Imported from https://github.com/tbu-/libloc-rs/blob/213a347e2f79112182f0863bf909a0f878756b4c/ipfire_libloc_db_v1.ksy
meta:
  id: ipfire_libloc_db_v1
  file-extension: db
  license: MIT OR Apache-2.0
  endian: be
seq:
  - id: header
    type: header
instances:
  as:
    pos: header.as.offset
    type: as
    repeat: expr
    repeat-expr: header.as.length / 8 # 8 = sizeof(as)
  networks:
    pos: header.networks.offset
    type: network
    repeat: expr
    repeat-expr: header.networks.length / 12 # 12 = sizeof(network)
  network_nodes:
    pos: header.network_nodes.offset
    type: network_node
    repeat: expr
    repeat-expr: header.network_nodes.length / 12 # 12 = sizeof(network_node)
  countries:
    pos: header.countries.offset
    type: country
    repeat: expr
    repeat-expr: header.countries.length / 8 # 8 = sizeof(country)
  strings:
    pos: header.string_pool.offset
    size: header.string_pool.length
    type: strzseq
    repeat: eos
types:
  header:
    seq:
      - id: magic
        contents: 'LOCDBXX'
      - id: version
        contents: "\x01"
      - id: created_at
        type: u8
      - id: vendor
        type: str_ref
      - id: description
        type: str_ref
      - id: license
        type: str_ref
      - id: as
        type: file_range
      - id: networks
        type: file_range
      - id: network_nodes
        type: file_range
      - id: countries
        type: file_range
      - id: string_pool
        type: file_range
      - id: signature1_length
        type: u2
      - id: signature2_length
        type: u2
      - id: signature1
        size: signature1_length
      - id: signature1_padding
        size: 2048 - signature1_length
      - id: signature2
        size: signature2_length
      - id: signature2_padding
        size: 2048 - signature2_length
      - id: padding
        size: 32
  file_range:
    seq:
      - id: offset
        type: u4
      - id: length
        type: u4
  str_ref:
    seq:
      - id: offset
        type: u4
    instances:
      value:
        io: _root._io
        pos: _root.header.string_pool.offset + offset
        type: strz
        encoding: UTF-8
  as:
    seq:
      - id: number
        type: u4
      - id: name
        type: str_ref
  network:
    seq:
      - id: country_code
        size: 2
        type: str
        encoding: ASCII
      - id: padding1
        size: 2
      - id: asn
        type: u4
      - id: flags
        type: u2
      - id: padding2
        size: 2
  network_node:
    seq:
      - id: child_zero
        type: u4
      - id: child_one
        type: u4
      - id: network
        type: u4
  country:
    seq:
      - id: code
        size: 2
        type: str
        encoding: ASCII
      - id: continent_code
        size: 2
        type: str
        encoding: ASCII
      - id: name
        type: str_ref
  strzseq:
    seq:
      - id: str
        type: strz
        encoding: UTF-8
        repeat: eos
