# Imported from https://gist.github.com/Hugoberry/3696b06b63934e45dd9583471aafa033
meta:
  id: parquet
  title: Apache Parquet columnar storage format
  file-extension: parquet
  license: CC0-1.0
  ks-version: 0.9
  endian: le

doc: |
  Minimal Parquet container layout:
    [4B "PAR1"] [row groups & column chunks ...]
    [FileMetaData (Thrift Compact)] [4B footer_len (LE u32)] [4B "PAR1"]

seq:
  - id: magic_header
    contents: "PAR1"
    doc: Magic at file start.

instances:
  # Absolute positions for footer components
  footer_len_pos:
    value: _io.size - 8
  footer_end_pos:
    value: _io.size - 4

  footer_len:
    pos: footer_len_pos
    type: u4
    doc: Length in bytes of Thrift-serialized FileMetaData.

  footer_start_pos:
    value: _io.size - 8 - footer_len

  magic_footer:
    pos: _io.size - 4
    type: magic_t
    doc: Magic at file end.

  footer:
    pos: footer_start_pos
    size: footer_len
    type: footer_t
    doc: Raw Thrift-compact FileMetaData blob.

  row_groups_and_data:
    pos: 4
    size: footer_start_pos - 4
    doc: Unparsed middle payload (row groups + column chunks).

  # Convenience offsets / sanity
  footer_offset:
    value: footer_start_pos
  expected_size_check:
    value: 4 + (footer_start_pos - 4) + footer_len + 4 + 4

types:
  # Tiny wrapper to make magic validation reusable
  magic_t:
    seq:
      - id: magic
        contents: "PAR1"

  # Raw footer payload (Thrift Compact-encoded FileMetaData)
  footer_t:
    seq:
      - id: bytes
        size-eos: true

  # OPTIONAL helper showing the "delta-sum" (scan) pattern from the article:
  # feed a stream of deltas and compute cumulative ids — useful for SchemaElement field IDs.
  delta_sum_stream:
    params:
      - id: initial
        type: u4
    seq:
      - id: item
        type: delta_item(initial)
        repeat: eos
    types:
      delta_item:
        params:
          - id: prev
            type: u4
        seq:
          - id: delta
            type: u1
        instances:
          value:
            value: prev + delta
      # Example usage (outside): read bytes as delta_sum_stream(0) to get running sums.
      # You’d adapt this to the exact bit-width/encoding used by your Thrift field headers.
