meta:
  id: seven_zip
  title: 7z archive
  application:
    - 7-Zip
    - p7zip
  file-extension: 7z
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Archive format of 7-Zip. An archive starts with a 32-byte signature header
  that locates the "next header" at the end of the archive. Between them are
  the packed streams: the compressed file data and, usually, the compressed
  archive header.

  The next header is either the archive header itself (`kHeader`, with the
  streams and files information), or, as written by 7-Zip by default, an
  encoded header (`kEncodedHeader`): a description of the packed streams and
  coders (e.g. LZMA) that decode to the real archive header.

  Numbers in headers mostly use a variable-length encoding in which the
  number of leading 1 bits of the first byte gives the number of extra bytes.

  This spec parses the signature header and the encoded header: pack info
  (position, sizes and CRCs of the packed streams) and coders info (folders
  with their coders, bind pairs, packed stream indices, unpack sizes and
  CRCs), and locates the packed streams. An unencoded archive header, and
  substreams info in an encoded header, are not parsed.
doc-ref:
  - https://github.com/ip7z/7zip/blob/d3296e39e1f1f92c7b41c0c3848e65640428d42d/DOC/7zFormat.txt
  - https://github.com/ip7z/7zip/blob/d3296e39e1f1f92c7b41c0c3848e65640428d42d/C/7zArcIn.c
seq:
  - id: signature
    contents: [0x37, 0x7a, 0xbc, 0xaf, 0x27, 0x1c]
  - id: version_major
    type: u1
  - id: version_minor
    type: u1
  - id: start_header_crc
    type: u4
    doc: CRC-32 of the following 20 bytes.
  - id: ofs_next_header
    type: u8
    doc: Offset of the next header, relative to the end of the signature header (32).
  - id: len_next_header
    type: u8
  - id: next_header_crc
    type: u4
instances:
  ofs_packed_streams:
    value: 32
    doc: Packed stream positions are relative to the end of the signature header.
  next_header:
    pos: ofs_packed_streams + ofs_next_header
    size: len_next_header
    type: next_header
    if: len_next_header != 0
types:
  next_header:
    seq:
      - id: kind
        type: u1
        enum: property_id
        valid:
          any-of:
            - property_id::header
            - property_id::encoded_header
      - id: encoded_header
        type: streams_info
        if: kind == property_id::encoded_header
        doc: Describes how the packed archive header is decoded.
      - id: header
        size-eos: true
        if: kind == property_id::header
        doc: Unencoded archive header (not parsed).
  streams_info:
    seq:
      - id: items
        type: streams_info_item
        repeat: until
        repeat-until: _.id == property_id::end
    instances:
      pack_info:
        value: items[0].body.as<pack_info>
        if: items[0].id == property_id::pack_info
      coders_info:
        value: |
          (items[0].id == property_id::unpack_info ? items[0].body : items[1].body).as<coders_info>
        if: |
          items[0].id == property_id::unpack_info
            or (items.size > 1 and items[1].id == property_id::unpack_info)
  streams_info_item:
    seq:
      - id: id
        type: u1
        enum: property_id
        valid:
          any-of:
            - property_id::end
            - property_id::pack_info
            - property_id::unpack_info
      - id: body
        type:
          switch-on: id
          cases:
            property_id::pack_info: pack_info
            property_id::unpack_info: coders_info
  pack_info:
    seq:
      - id: pack_pos
        type: number
        doc: |
          Position of the first packed stream, relative to the end of the signature
          header.
      - id: num_pack_streams
        type: number
      - id: items
        type: pack_info_item(num_pack_streams.value)
        repeat: until
        repeat-until: _.id == property_id::end
  pack_info_item:
    params:
      - id: num_pack_sizes
        type: u8
    seq:
      - id: id
        type: u1
        enum: property_id
      - id: pack_sizes
        type: number
        repeat: expr
        repeat-expr: num_pack_sizes
        if: id == property_id::size
      - id: pack_stream_digests
        type: digests(num_pack_sizes)
        if: id == property_id::crc
  coders_info:
    seq:
      - id: folder_id
        contents: [0x0b]
      - id: num_folders
        type: number
      - id: is_external
        type: u1
      - id: data_stream_index
        type: number
        if: is_external != 0
      - id: folders
        type: folder
        repeat: expr
        repeat-expr: num_folders.value
        if: is_external == 0
      - id: coders_unpack_size_id
        contents: [0x0c]
      - id: unpack_sizes
        type: folder_unpack_sizes(folders[_index].num_out_streams_total)
        repeat: expr
        repeat-expr: num_folders.value
        if: is_external == 0
      - id: items
        type: coders_info_item(num_folders.value)
        repeat: until
        repeat-until: _.id == property_id::end
  coders_info_item:
    params:
      - id: num_folders
        type: u8
    seq:
      - id: id
        type: u1
        enum: property_id
      - id: unpack_digests
        type: digests(num_folders)
        if: id == property_id::crc
        doc: CRCs of the unpacked data of each folder.
  folder:
    doc: |
      A folder is a group of coders whose output is one unpacked stream; its
      inputs are packed streams.
    seq:
      - id: num_coders
        type: number
      - id: coders
        type: 'coder(_index == 0 ? 0 : coders[_index - 1].num_in_streams_total, _index == 0 ? 0 : coders[_index - 1].num_out_streams_total)'
        repeat: expr
        repeat-expr: num_coders.value
      - id: bind_pairs
        type: bind_pair
        repeat: expr
        repeat-expr: num_bind_pairs
      - id: packed_stream_indices
        type: number
        repeat: expr
        repeat-expr: num_packed_stream_indices
        if: num_packed_stream_indices > 1
    instances:
      num_in_streams_total:
        value: coders.last.num_in_streams_total
      num_out_streams_total:
        value: coders.last.num_out_streams_total
      num_bind_pairs:
        value: num_out_streams_total - 1
      num_packed_stream_indices:
        value: num_in_streams_total - num_bind_pairs
  coder:
    params:
      - id: num_in_streams_before
        type: u8
      - id: num_out_streams_before
        type: u8
    seq:
      - id: flags
        type: u1
        doc: |
          Bits 0-3: size of the codec ID; bit 4: complex coder; bit 5: has
          properties; bits 6-7: reserved (0).
      - id: codec_id
        size: flags & 0x0f
        doc: Method ID of the codec, most significant byte first.
      - id: num_in_streams
        type: number
        if: is_complex
      - id: num_out_streams
        type: number
        if: is_complex
      - id: len_properties
        type: number
        if: has_properties
      - id: properties
        size: len_properties.value
        if: has_properties
    instances:
      is_complex:
        value: flags & 0x10 != 0
      has_properties:
        value: flags & 0x20 != 0
      num_in_streams_total:
        value: 'num_in_streams_before + (is_complex ? num_in_streams.value : 1)'
      num_out_streams_total:
        value: 'num_out_streams_before + (is_complex ? num_out_streams.value : 1)'
  bind_pair:
    seq:
      - id: in_index
        type: number
      - id: out_index
        type: number
  folder_unpack_sizes:
    params:
      - id: num_sizes
        type: u8
    seq:
      - id: sizes
        type: number
        repeat: expr
        repeat-expr: num_sizes
        doc: Unpacked size of each output stream of the folder's coders.
  digests:
    params:
      - id: num_items
        type: u8
    seq:
      - id: all_defined
        type: u1
      - id: defined_bytes
        type: 'defined_byte(_index == 0 ? 0 : defined_bytes[_index - 1].num_defined_total, num_items - _index * 8)'
        repeat: expr
        repeat-expr: (num_items + 7) / 8
        if: all_defined == 0
        doc: Bit vector (most significant bit first) of the items that have a CRC.
      - id: crcs
        type: u4
        repeat: expr
        repeat-expr: num_crcs
    instances:
      num_crcs:
        value: 'all_defined != 0 ? num_items : num_items == 0 ? 0 : defined_bytes.last.num_defined_total'
  defined_byte:
    params:
      - id: num_defined_before
        type: u8
      - id: num_items_left
        type: s8
    seq:
      - id: bits
        type: u1
    instances:
      masked:
        value: 'num_items_left >= 8 ? bits : bits & (0xff00 >> num_items_left)'
      num_defined_total:
        value: |
          num_defined_before
            + (masked >> 7 & 1) + (masked >> 6 & 1) + (masked >> 5 & 1) + (masked >> 4 & 1)
            + (masked >> 3 & 1) + (masked >> 2 & 1) + (masked >> 1 & 1) + (masked & 1)
  number:
    doc: |
      Variable-length unsigned integer: the number of leading 1 bits of the
      first byte gives the number of extra bytes (0 to 8), which hold the low
      bits of the value in little-endian order; the remaining bits of the
      first byte are the high bits.
    seq:
      - id: first
        type: u1
      - id: extra
        size: len_extra
    instances:
      len_extra:
        value: |
          first & 0x80 == 0 ? 0
            : first & 0x40 == 0 ? 1
            : first & 0x20 == 0 ? 2
            : first & 0x10 == 0 ? 3
            : first & 0x08 == 0 ? 4
            : first & 0x04 == 0 ? 5
            : first & 0x02 == 0 ? 6
            : first & 0x01 == 0 ? 7
            : 8
      low:
        value: |
          (len_extra > 0 ? extra[0].as<u8> : 0)
            | (len_extra > 1 ? extra[1].as<u8> << 8 : 0)
            | (len_extra > 2 ? extra[2].as<u8> << 16 : 0)
            | (len_extra > 3 ? extra[3].as<u8> << 24 : 0)
            | (len_extra > 4 ? extra[4].as<u8> << 32 : 0)
            | (len_extra > 5 ? extra[5].as<u8> << 40 : 0)
            | (len_extra > 6 ? extra[6].as<u8> << 48 : 0)
            | (len_extra > 7 ? extra[7].as<u8> << 56 : 0)
      value:
        value: 'len_extra >= 7 ? low : ((first & (0x7f >> len_extra)).as<u8> << (8 * len_extra)) | low'
enums:
  property_id:
    0x00: end
    0x01: header
    0x02: archive_properties
    0x03: additional_streams_info
    0x04: main_streams_info
    0x05: files_info
    0x06: pack_info
    0x07: unpack_info
    0x08: substreams_info
    0x09: size
    0x0a: crc
    0x0b: folder
    0x0c: coders_unpack_size
    0x0d: num_unpack_stream
    0x0e: empty_stream
    0x0f: empty_file
    0x10: anti
    0x11: name
    0x12: ctime
    0x13: atime
    0x14: mtime
    0x15: win_attributes
    0x16: comment
    0x17: encoded_header
    0x18: start_pos
    0x19: dummy
