# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/dhtb/dhtb.ksy
meta:
  id: dhtb
  title: DHTB
  license: CC0-1.0
  ks-version: 0.9
  encoding: UTF-8
  endian: le
doc-ref: https://github.com/osm0sis/dhtbsign
seq:
  - id: header
    size: 512
    type: header
  - id: payload
    size: header.len_payload
types:
  padding_byte:
    seq:
      - id: padding_byte
        contents: [0x00]
  header:
    seq:
      - id: magic
        contents: ['DHTB', 0x01, 0x00, 0x00, 0x00]
      - id: sha256
        size: 32
      - id: padding1
        contents: [0, 0, 0, 0, 0, 0, 0, 0]
      - id: len_payload
        type: u4
      - id: padding2
        type: padding_byte
        repeat: eos
