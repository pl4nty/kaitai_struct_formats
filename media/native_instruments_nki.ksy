# Imported from https://github.com/gitter-badger/ni-file/blob/c88ef5296da4f9558a3b398ea322c03473afbd7c/nki.ksy
meta:
  id: native_instruments_nki
  title: Native Instruments Kontakt instrument (.nki)
  file-extension: nki
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: length
    type: u8
  - id: chunk_data
    size: length - 8
    type: header_chunk

types:
  data_chunk:
    seq:
      - id: tag
        size: 4
        type: str
        encoding: UTF-8
      - id: type
        type: u4
      - id: unknown
        type: u4
      - id: datachunk_length
        type: u8
        if: type != 1
      - id: datachunk
        size: datachunk_length - 8
        type: data_chunk
        if: type != 1
      - id: values
        size-eos: true

  header_chunk:
    seq:
      - id: unknown1
        type: u4
      - id: tag
        size: 4
        type: str
        encoding: UTF-8
      - id: unknown2
        type: u8
      - id: checksum
        size: 16
      - id: datachunk_length
        type: u8
      - id: datachunk
        size: datachunk_length - 8
        type: data_chunk
      - id: no_compression
        type: u4
      - id: children
        type: u4
      - id: extra_tag
        size: 12
        if: children > 0 and no_compression == 1
      - id: length
        type: u8
        if: children > 0 and no_compression == 1
      - id: chunk_data
        size: length - 8
        type: header_chunk
        if: children > 0 and no_compression == 1
