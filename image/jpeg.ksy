meta:
  id: jpeg
  title: JPEG (Joint Photographic Experts Group) File Interchange Format
  file-extension:
    - jpg
    - jpeg
    - jpe
    - jif
    - jfif
    - jfi
  xref:
    ecma: TR/98
    forensicswiki: jpeg
    justsolve: JFIF
    loc: fdd000017
    mime: image/jpeg
    pronom:
      - fmt/42 # JFIF 1.00
      - fmt/43 # JFIF 1.01
      - fmt/44 # JFIF 1.02
    wikidata: Q26329975
  license: CC0-1.0
  imports:
    - exif
  endian: be
doc: |
  JPEG File Interchange Format, or JFIF, or, more colloquially known
  as just "JPEG" or "JPG", is a popular 2D bitmap image file format,
  offering lossy compression which works reasonably well with
  photographic images.

  Format is organized as a container format, serving multiple
  "segments", each starting with a magic and a marker. JFIF standard
  dictates order and mandatory appearance of segments:

  * SOI
  * APP0 (with JFIF magic)
  * APP0 (with JFXX magic, optional)
  * everything else
  * SOS
  * JPEG-compressed stream
  * EOI
seq:
  - id: segments
    type: segment
    repeat: eos
types:
  segment:
    seq:
      - id: magic
        contents: [0xff]
      - id: marker
        type: u1
        enum: marker_enum
      - id: length
        type: u2
        if: has_length
      - id: data
        size: length - 2
        type:
          switch-on: marker
          cases:
            'marker_enum::app0': segment_app0
            'marker_enum::app1': segment_app1
            'marker_enum::dqt': segment_dqt
            'marker_enum::dht': segment_dht
            # All SOFn segments share the same frame header layout (T.81 B.2.2)
            'marker_enum::sof0': segment_sof0
            'marker_enum::sof1': segment_sof0
            'marker_enum::sof2': segment_sof0
            'marker_enum::sof3': segment_sof0
            'marker_enum::sof5': segment_sof0
            'marker_enum::sof6': segment_sof0
            'marker_enum::sof7': segment_sof0
            'marker_enum::sof9': segment_sof0
            'marker_enum::sof10': segment_sof0
            'marker_enum::sof11': segment_sof0
            'marker_enum::sof13': segment_sof0
            'marker_enum::sof14': segment_sof0
            'marker_enum::sof15': segment_sof0
            'marker_enum::sos': segment_sos
        if: has_length
      - id: image_data
        size-eos: true
        if: marker == marker_enum::sos
        doc: |
          Entropy-coded scan data. Its end is only marked by the next marker
          (0xFF followed by a byte other than 0x00 or RST0-RST7), which
          cannot be expressed here, so this takes the rest of the file and
          the segments after the first scan (further scans of progressive
          JPEGs, EOI, trailing data) are not parsed as segments.
    instances:
      has_length:
        value: |
          marker != marker_enum::soi and marker != marker_enum::eoi and
          marker != marker_enum::tem and
          (marker.to_i < 0xd0 or marker.to_i > 0xd7)
        doc: |
          SOI, EOI, TEM and RST0-RST7 are standalone markers without a length
          field (T.81 B.1.1.3).
    enums:
      marker_enum:
        0x01: tem
        0xc0: sof0 # start of frame 0
        0xc1: sof1 # start of frame 1
        0xc2: sof2 # start of frame 2
        0xc3: sof3 # start of frame 3
        0xc4: dht # define Huffman table
        0xc5: sof5 # start of frame 5
        0xc6: sof6 # start of frame 6
        0xc7: sof7 # start of frame 7
        0xc8: jpg # reserved for JPEG extensions
        0xc9: sof9 # start of frame 9
        0xca: sof10 # start of frame 10
        0xcb: sof11 # start of frame 11
        0xcc: dac # define arithmetic coding conditioning
        0xcd: sof13 # start of frame 13
        0xce: sof14 # start of frame 14
        0xcf: sof15 # start of frame 15
        0xd0: rst0 # restart with modulo 8 count 0
        0xd1: rst1
        0xd2: rst2
        0xd3: rst3
        0xd4: rst4
        0xd5: rst5
        0xd6: rst6
        0xd7: rst7
        0xd8: soi # start of image
        0xd9: eoi # end of image
        0xda: sos # start of scan
        0xdb: dqt # define quantization table
        0xdc: dnl # define number of lines
        0xdd: dri # define restart interval
        0xde: dhp # define hierarchical progression
        0xdf: exp # expand reference components
        0xe0: app0
        0xe1: app1
        0xe2: app2
        0xe3: app3
        0xe4: app4
        0xe5: app5
        0xe6: app6
        0xe7: app7
        0xe8: app8
        0xe9: app9
        0xea: app10
        0xeb: app11
        0xec: app12
        0xed: app13
        0xee: app14
        0xef: app15
        0xf0: jpg0 # reserved for JPEG extensions
        0xf1: jpg1
        0xf2: jpg2
        0xf3: jpg3
        0xf4: jpg4
        0xf5: jpg5
        0xf6: jpg6
        0xf7: jpg7
        0xf8: jpg8
        0xf9: jpg9
        0xfa: jpg10
        0xfb: jpg11
        0xfc: jpg12
        0xfd: jpg13
        0xfe: com # comment
  segment_app0:
    seq:
      - id: magic
        size: 5
        type: str
        encoding: ASCII
      - id: version_major
        type: u1
      - id: version_minor
        type: u1
      - id: density_units
        type: u1
        enum: density_unit
      - id: density_x
        type: u2
        doc: Horizontal pixel density. Must not be zero.
      - id: density_y
        type: u2
        doc: Vertical pixel density. Must not be zero.
      - id: thumbnail_x
        type: u1
        doc: Horizontal pixel count of the following embedded RGB thumbnail. May be zero.
      - id: thumbnail_y
        type: u1
        doc: Vertical pixel count of the following embedded RGB thumbnail. May be zero.
      - id: thumbnail
        size: thumbnail_x * thumbnail_y * 3
        doc: |
          Uncompressed 24 bit RGB (8 bits per color channel) raster thumbnail data in the
          order R0, G0, B0, ... Rn, Gn, Bn
    enums:
      density_unit:
        0: no_units
        1: pixels_per_inch
        2: pixels_per_cm
  segment_app1:
    seq:
      - id: magic
        type: strz
        encoding: ASCII
      - id: body
        type:
          switch-on: magic
          cases:
            '"Exif"': exif_in_jpeg
  segment_dqt:
    doc: Define quantization tables
    doc-ref: https://www.w3.org/Graphics/JPEG/itu-t81.pdf - section B.2.4.1
    seq:
      - id: tables
        type: quantization_table
        repeat: eos
    types:
      quantization_table:
        seq:
          - id: precision
            type: b4
            valid:
              any-of: [0, 1]
            doc: Element precision; 0 = 8-bit values, 1 = 16-bit values
          - id: table_id
            type: b4
            doc: Destination identifier (0-3)
          - id: values
            type:
              switch-on: precision
              cases:
                0: u1
                1: u2
            repeat: expr
            repeat-expr: 64
            doc: Quantization table elements, in zig-zag order
  segment_dht:
    doc: Define Huffman tables
    doc-ref: https://www.w3.org/Graphics/JPEG/itu-t81.pdf - section B.2.4.2
    seq:
      - id: tables
        type: huffman_table
        repeat: eos
    types:
      huffman_table:
        seq:
          - id: table_class
            type: b4
            doc: 0 = DC table or lossless table, 1 = AC table
          - id: table_id
            type: b4
            doc: Destination identifier (0-3)
          - id: num_codes
            type: u1
            repeat: expr
            repeat-expr: 16
            doc: Number of Huffman codes of each length 1-16
          - id: values
            size: |
              num_codes[0] + num_codes[1] + num_codes[2] + num_codes[3] +
              num_codes[4] + num_codes[5] + num_codes[6] + num_codes[7] +
              num_codes[8] + num_codes[9] + num_codes[10] + num_codes[11] +
              num_codes[12] + num_codes[13] + num_codes[14] + num_codes[15]
            doc: Values associated with each Huffman code, in order of increasing code length
  segment_sof0:
    doc: |
      Frame header. Despite the name, used for all SOFn markers, which share
      this layout.
    doc-ref: https://www.w3.org/Graphics/JPEG/itu-t81.pdf - section B.2.2
    seq:
      - id: bits_per_sample
        type: u1
      - id: image_height
        type: u2
      - id: image_width
        type: u2
      - id: num_components
        type: u1
      - id: components
        type: component
        repeat: expr
        repeat-expr: num_components
    types:
      component:
        seq:
          - id: id
            type: u1
            enum: component_id
            doc: Component selector
          - id: sampling_factors
            type: u1
          - id: quantization_table_id
            type: u1
        instances:
          sampling_x:
            value: (sampling_factors & 0xf0) >> 4
          sampling_y:
            value: sampling_factors & 0xf
  segment_sos:
    seq:
      - id: num_components
        type: u1
        doc: Number of components in scan
      - id: components
        type: component
        repeat: expr
        repeat-expr: num_components
        doc: Scan components specification
      - id: start_spectral_selection
        type: u1
        doc: Start of spectral selection or predictor selection
      - id: end_spectral
        type: u1
        doc: End of spectral selection
      - id: appr_bit_pos
        type: u1
        doc: |
          Successive approximation bit position high + Successive approximation bit
          position low or point transform
    types:
      component:
        seq:
          - id: id
            type: u1
            enum: component_id
            doc: Scan component selector
          - id: huffman_table
            type: u1
  # Extra wrapper for EXIF, as there is extra 0 byte that needs to be
  # parsed. The actual EXIF specification is defined in external .ksy
  # file, as it is shared with other formats (TIFF, PNG, XCF, etc).
  exif_in_jpeg:
    seq:
      - id: extra_zero
        contents: [0]
      - id: data
        size-eos: true
        type: exif
enums:
  component_id:
    1: y
    2: cb
    3: cr
    4: i
    5: q
