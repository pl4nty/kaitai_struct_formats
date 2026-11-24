# Imported from https://github.com/kibertoad/dark-sun-wake-redux/blob/bf7acb3dbf5224a4f46160ec7ce42a02f58e0af0/spec/formats/fmt_gff_003.ksy
# Licence and copyright: see _community/README.md
meta:
  id: fmt_gff_003
  title: GFF tag table
  license: MIT
  imports:
    - fmt_gff_004
    - fmt_gff_006
  endian: le
  bit-endian: le
doc-ref: FMT-GFF-003, FND-GFF-002, FND-GFF-003, FND-GFF-005
seq:
  - id: tag
    size: 4
    type: str
    encoding: ASCII
    doc: A three-letter tag is padded with one space at the end.
  - id: entry_count
    type: b31
  - id: is_indexed
    type: b1
  - id: entries
    type: fmt_gff_004
    repeat: expr
    repeat-expr: entry_count
    if: not is_indexed
  - id: indexed_count
    type: u4
    if: is_indexed
    doc: Equal to entry_count.
  - id: index_number
    type: u4
    if: is_indexed
    doc: Number of the GFFI resource (fmt_gff_007) holding the offsets and sizes.
  - id: range_count
    type: u4
    if: is_indexed
  - id: number_ranges
    type: fmt_gff_006
    repeat: expr
    repeat-expr: range_count
    if: is_indexed
