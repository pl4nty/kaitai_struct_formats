# Imported from https://github.com/TheGameCommunity/ExciteModder/blob/82eadbf9fafb5b699a5247fc4737e7eee22289fe/src/main/resources/kaitai/quicklz_rcmp.ksy
meta:
  id: quicklz_rcmp
  title: quickLZ compressed data
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: header
    type: header
  - id: bytes
    size-eos: true
    process: com.gamebuster19901.excite.modding.quicklz.quicklz_dumper
types:
  header:
    seq:
      - id: magic
        size: 4
        contents: "PMCr"
      - id: unknown
        type: u4
      - id: compressed_length
        type: u4
      - id: uncompressed_length
        type: u4
