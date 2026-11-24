# Imported from https://github.com/kibertoad/dark-sun-wake-redux/blob/bf7acb3dbf5224a4f46160ec7ce42a02f58e0af0/spec/formats/fmt_gff_005.ksy
meta:
  id: fmt_gff_005
  title: GFF byte range
  license: MIT
  endian: le
doc-ref: FMT-GFF-005, FND-GFF-003, FND-GFF-004
seq:
  - id: data_offset
    type: u4
    doc: File offset of the range's first byte.
  - id: data_size
    type: u4
