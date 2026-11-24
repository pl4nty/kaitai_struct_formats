# Imported from https://gist.githubusercontent.com/matty45/382f5a1c936504a9a1f01f0134f011cc/raw/4003d602860e803df91b26ebc643b599744e854d/halo_reach_gr2.ksy
meta:
  id: halo_reach_gr2
  title: "Halo: Reach Granny 3D file (.gr2)"
  application: Halo Reach
  file-extension: gr2
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    type: magic
    doc: |
      All Granny files start with this magic structure that defines endianness,
      bitness and header format.
  - id: header
    type: header
  - id: padding
    size: 8
  - id: sections
    type: section
    repeat: expr
    repeat-expr: header.num_sections
types:
  magic:
    seq:
      - id: magic_signature
        size: 16
        doc: magic value
      - id: headers_size
        type: u4
        doc: Size of file header; offset of the start of section data
      - id: headers_format
        type: u4
        doc: If not 0, the file is compressed. (0 = uncompressed, 1-2 = Oodle0/1 ?)
      - id: reserved_1
        type: u4
      - id: reserved_2
        type: u4
  header:
    seq:
      - id: version
        type: u4
        doc: File format version
      - id: file_size
        type: u4
        doc: Total size of .GR2 file, including headers
      - id: crc
        type: u4
        doc: |
          CRC-32 hash of the data starting after the header (offset = HeaderSize) to the
          end of the file (Header.fileSize - HeaderSize bytes)
      - id: sections_offset
        type: u4
        doc: Offset of the section list relative to the beginning of the file
      - id: num_sections
        type: u4
        doc: Number of Sections in the .GR2 file
      - id: root_type
        type: u4
      - id: root_node
        type: u4
      - id: tag
        type: u4
        doc: File format version tag
      - id: extra_tags
        type: u4
        repeat: expr
        repeat-expr: 4
        doc: Number of extra tags might differ!
      - id: string_table_crc
        type: u4
        doc: CRC of string table; seems to be unused?
      - id: reserved_1
        type: u4
      - id: reserved_2
        type: u4
      - id: reserved_3
        type: u4
  section:
    seq:
      - id: compression
        type: u4
        doc: Type of compression used; 0 = no compression; 1-2 = Oodle 1/2 compression
      - id: offset_in_file
        type: u4
        doc: Absolute position of the section data in the GR2 file
      - id: compressed_size
        type: u4
        doc: Compressed size of section data
      - id: uncompressed_size
        type: u4
        doc: Unompressed size of section data
      - id: alignment
        type: u4
      - id: first16bit
        type: u4
        doc: Oodle1 compressor stops
      - id: first8bit
        type: u4
        doc: Oodle1 compressor stops
      - id: relocations_offset
        type: u4
        doc: Absolute position of the relocation data in the GR2 file
      - id: num_relocations
        type: u4
        doc: Number of relocations for this section
      - id: mixed_marshalling_data_offset
        type: u4
        doc: Absolute position of the mixed-endianness marshalling data in the GR2 file
      - id: num_mixed_marshalling_data
        type: u4
        doc: Number of mixed-marshalling entries for this section
