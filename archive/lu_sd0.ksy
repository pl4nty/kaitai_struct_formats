# Imported from https://github.com/lcdr/lu_formats/blob/eb15852181d3fd55f638eb20ce4a2e9cd7f08dac/files/sd0.ksy
meta:
  id: lu_sd0
  title: LEGO Universe compressed file (.sd0)
  file-extension: sd0
  license: LicenseRef-All-Rights-Reserved
  imports:
    - /database/lu_common
  endian: le
seq:
  - id: header
    contents: ['sd0', 0x01, 0xFF]
  - id: compressed_chunks
    type: compressed_chunks
    repeat: eos
types:
  compressed_chunks:
    seq:
      - id: chunk_size
        type: u4
      - id: compressed_chunk
        size: chunk_size
