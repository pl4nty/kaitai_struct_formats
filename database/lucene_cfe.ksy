meta:
  id: lucene_cfe
  title: Apache Lucene compound file entry table
  application: Apache Lucene
  file-extension: cfe
  license: CC0-1.0
  ks-version: '0.9'
  imports:
    - /common/vlq_base128_le
  endian: be
doc: |
  Entry table (`.cfe`) of an Apache Lucene compound file. When a segment
  uses the compound file format, all of its index files are concatenated
  into a single `.cfs` data file, and the `.cfe` file lists, for every
  inner file, its name (without the segment name prefix), its start
  offset in the `.cfs` file and its length.

  Two versions of the format are supported, distinguished by the codec
  name in the header:

  * `Lucene50CompoundEntries` (Lucene 5.0 to 8.x): offsets and lengths
    are big-endian.
  * `Lucene90CompoundEntries` (Lucene 9.0 and later): offsets and lengths
    are little-endian, since Lucene 9 switched `DataOutput.writeLong` to
    little-endian. Inner files start at 64-byte aligned offsets in the
    `.cfs` file.

  In both versions the codec header and footer are big-endian.
doc-ref:
  - https://github.com/apache/lucene/blob/main/lucene/core/src/java/org/apache/lucene/codecs/lucene90/Lucene90CompoundFormat.java
  - https://github.com/apache/lucene/blob/main/lucene/core/src/java/org/apache/lucene/codecs/CodecUtil.java
  - https://github.com/apache/lucene-solr/blob/releases/lucene-solr/8.7.0/lucene/core/src/java/org/apache/lucene/codecs/lucene50/Lucene50CompoundFormat.java
seq:
  - id: header
    type: index_header
  - id: num_files
    type: vlq_base128_le
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: num_files.value
  - id: footer
    type: codec_footer
instances:
  is_le:
    value: header.codec_name == "Lucene90CompoundEntries"
    doc: Whether offsets and lengths are stored little-endian.
types:
  lucene_string:
    doc: String prefixed with its UTF-8 byte length as a VInt.
    seq:
      - id: len_value
        type: vlq_base128_le
      - id: value
        size: len_value.value
        type: str
        encoding: UTF-8
  index_header:
    doc: Lucene `CodecUtil` index header.
    seq:
      - id: magic
        contents: [0x3f, 0xd7, 0x6c, 0x17]
      - id: len_codec_name
        type: u1
        doc: |
          Length of the codec name. It is written as a VInt, but codec names
          are limited to 127 ASCII characters, so it is always one byte.
      - id: codec_name
        size: len_codec_name
        type: str
        encoding: ASCII
        valid:
          any-of:
            - '"Lucene50CompoundEntries"'
            - '"Lucene90CompoundEntries"'
      - id: version
        type: u4
      - id: object_id
        size: 16
        doc: Unique segment ID; must match the ID in the segment info.
      - id: len_suffix
        type: u1
      - id: suffix
        size: len_suffix
        type: str
        encoding: ASCII
  entry:
    seq:
      - id: name
        type: lucene_string
        doc: Inner file name with the segment name stripped, e.g. `.fdt`.
      - id: ofs_data
        type:
          switch-on: _root.is_le
          cases:
            true: u8le
            false: u8be
        doc: Start offset of the inner file in the `.cfs` file.
      - id: len_data
        type:
          switch-on: _root.is_le
          cases:
            true: u8le
            false: u8be
        doc: Length of the inner file (including its own header and footer).
  codec_footer:
    doc: Lucene `CodecUtil` footer.
    seq:
      - id: magic
        contents: [0xc0, 0x28, 0x93, 0xe8]
      - id: algorithm_id
        type: u4
        doc: Checksum algorithm; always 0 (zlib CRC-32).
      - id: checksum
        type: u8
        doc: |
          CRC-32 of all preceding bytes of the file, including footer magic and algorithm
          ID.
