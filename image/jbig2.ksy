meta:
  id: jbig2
  title: JBIG2 bi-level image
  application:
    - Apache PDFBox
    - jbig2dec
  file-extension:
    - jb2
    - jbig2
  xref:
    iso: '14492'
  license: CC0-1.0
  ks-version: '0.11'
  endian: be
doc: |
  JBIG2 (ITU-T T.88 | ISO/IEC 14492) compressed bi-level image, as stored in
  stand-alone files or embedded in PDF (JBIG2Decode filter).

  A stand-alone file starts with an 8-byte ID and a file header giving the
  organisation and optionally the number of pages, followed by segments. In the
  sequential organisation each segment header is directly followed by its data;
  in the random-access organisation all segment headers come first (up to the
  end-of-file segment) and the segment data follow in the same order. Streams
  embedded in PDF have no file header and use the sequential organisation.

  This spec parses the file header and the segment headers (number, type, page
  association, referred-to segments, data length); segment data is left raw.
  The "unknown data length" value 0xFFFFFFFF allowed for immediate generic
  regions is not supported.
doc-ref:
  - https://www.itu.int/rec/T-REC-T.88
  - https://github.com/apache/pdfbox-jbig2/blob/2d62947a279423dfdadcd4ca2d894c55b4e665d9/src/main/java/org/apache/pdfbox/jbig2/SegmentHeader.java
  - https://github.com/apache/pdfbox-jbig2/blob/2d62947a279423dfdadcd4ca2d894c55b4e665d9/src/main/java/org/apache/pdfbox/jbig2/JBIG2Document.java
seq:
  - id: file_header
    type: file_header
    if: has_file_header
  - id: sequential_segments
    type: segment(true)
    repeat: until
    repeat-until: _.header.type == segment_type::end_of_file or _io.eof
    if: is_sequential
  - id: random_access_headers
    type: segment_header
    repeat: until
    repeat-until: _.type == segment_type::end_of_file or _io.eof
    if: not is_sequential
  - id: random_access_data
    size: random_access_headers[_index].len_data
    repeat: expr
    repeat-expr: random_access_headers.size
    if: not is_sequential
instances:
  magic_peek:
    pos: 0
    size: 8
    if: _io.size >= 8
  has_file_header:
    value: _io.size >= 8 and magic_peek == [0x97, 0x4a, 0x42, 0x32, 0x0d, 0x0a, 0x1a, 0x0a]
  is_sequential:
    value: 'has_file_header ? file_header.is_sequential : true'
types:
  file_header:
    seq:
      - id: magic
        contents: [0x97, 0x4a, 0x42, 0x32, 0x0d, 0x0a, 0x1a, 0x0a]
      - id: reserved
        type: b5
      - id: uses_extended_templates
        type: b1
        doc: Generic region segments may use extended templates.
      - id: num_pages_unknown
        type: b1
      - id: is_sequential
        type: b1
        doc: 1 - sequential organisation, 0 - random-access organisation.
      - id: num_pages
        type: u4
        if: not num_pages_unknown
  segment:
    params:
      - id: has_data
        type: bool
    seq:
      - id: header
        type: segment_header
      - id: data
        size: header.len_data
        if: has_data
  segment_header:
    seq:
      - id: number
        type: u4
      - id: deferred_non_retain
        type: b1
        doc: Called "retain flag" in some implementations.
      - id: has_long_page_association
        type: b1
      - id: type
        type: b6
        enum: segment_type
      - id: num_referred_short
        type: b3
        doc: Number of referred-to segments (0-4), or 7 for the long form.
      - id: retain_bits_short
        type: b5
        if: num_referred_short != 7
      - id: num_referred_long
        type: b29
        if: num_referred_short == 7
      - id: retain_bits_long
        size: (num_referred_long + 8) / 8
        if: num_referred_short == 7
      - id: referred_segments
        type:
          switch-on: len_referred_number
          cases:
            1: u1
            2: u2
            4: u4
        repeat: expr
        repeat-expr: num_referred_segments
      - id: page_association
        type:
          switch-on: has_long_page_association
          cases:
            true: u4
            false: u1
        doc: Page this segment belongs to, 0 for global segments.
      - id: len_data
        type: u4
    instances:
      num_referred_segments:
        value: 'num_referred_short == 7 ? num_referred_long : num_referred_short'
      len_referred_number:
        value: 'number <= 256 ? 1 : number <= 65536 ? 2 : 4'
        doc: Size of each referred-to segment number, depending on this segment's number.
enums:
  segment_type:
    0: symbol_dictionary
    4: intermediate_text_region
    6: immediate_text_region
    7: immediate_lossless_text_region
    16: pattern_dictionary
    20: intermediate_halftone_region
    22: immediate_halftone_region
    23: immediate_lossless_halftone_region
    36: intermediate_generic_region
    38: immediate_generic_region
    39: immediate_lossless_generic_region
    40: intermediate_generic_refinement_region
    42: immediate_generic_refinement_region
    43: immediate_lossless_generic_refinement_region
    48: page_information
    50: end_of_stripe
    51: end_of_file
    52: profiles
    53: tables
