# Imported from https://github.com/The-Knights-of-the-Eastern-Calculus/lainextract/blob/51d8322a0d75c71e089607c97197c7bde56c82a6/lapk_python/lapk.ksy
meta:
  id: serial_experiments_lain_lapk
  title: Serial Experiments Lain LAPK archive
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  ks-opaque-types: true  # ksylint: disable=KSY210
  endian: le
seq:
  - id: magic
    contents: 'lapk'
  - id: lapk_size
    type: u4
  - id: data
    size: lapk_size
    type: lapk_data
types:
  cell_header:
    seq:
      - id: cell_offset
        type: u4
      - id: negative_x_position
        type: u2
      - id: negative_y_position
        type: u2
      - id: unknown
        type: u4
  cell_data:
    seq:
      - id: width
        type: u2
      - id: height
        type: u2
      - id: chrominance_quantisation_scale
        type: u2
      - id: luminance_quantisation_scale
        type: u2
      - id: image_data_size
        type: u4
      - id: run_length_code_count
        type: u4
      - id: image_data
        size: image_data_size - 4
      - id: bit_mask
        size-eos: true
        type: lain_compress

  lapk_data:
    seq:
      - id: cell_count
        type: u4
      - id: cell_headers
        type: cell_header
        repeat: expr
        repeat-expr: cell_count
      - id: cell_data
        size: '_index == cell_count - 1 ? (_parent.lapk_size - 4 - cell_count * 12 - cell_headers[_index].cell_offset) : (cell_headers[_index + 1].cell_offset - cell_headers[_index].cell_offset)'
        type: cell_data
        repeat: expr
        repeat-expr: cell_count
