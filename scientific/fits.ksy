meta:
  id: fits
  title: Flexible Image Transport System (FITS)
  application: CFITSIO
  file-extension:
    - fits
    - fit
    - fts
  xref:
    mime:
      - application/fits
      - image/fits
  license: CC0-1.0
  ks-version: '0.9'
  encoding: ASCII
doc: |
  FITS is the standard data format of astronomy, used for images, spectra,
  tables and data cubes. A file is a sequence of header and data units
  (HDUs): the primary HDU, followed by optional extensions (`IMAGE`,
  ASCII `TABLE`, `BINTABLE` and others). Everything is stored in 2880-byte
  blocks.

  A header is a sequence of 80-character ASCII keyword records ("cards"),
  each with an 8-character keyword name, the value indicator `= ` for
  records with a value, and the value with an optional comment. The header
  ends with the `END` keyword and is padded with spaces to a whole number of
  blocks. The data follows, padded to a whole number of blocks.

  The size of the data is computed from the mandatory keywords, which must
  come first and in a fixed order: `SIMPLE` (primary HDU) or `XTENSION`
  (extension), `BITPIX`, `NAXIS`, `NAXIS1` to `NAXISn`, and, in extensions,
  `PCOUNT` and `GCOUNT`. The size in bits is
  |BITPIX| × GCOUNT × (PCOUNT + NAXIS1 × … × NAXISn). Their values are
  fixed-format integers, right-justified in bytes 11 to 30 of the record.

  This spec parses all HDUs with their keyword records, and gives the data
  of each as raw bytes, with integers and floating-point values stored
  big-endian. Random groups in the primary HDU (`NAXIS1 = 0` with `GROUPS =
  T`, a deprecated structure whose `PCOUNT` and `GCOUNT` may appear anywhere
  in the header) are not supported: their data size is computed as 0.
  Special records that may follow the last extension are not parsed.
doc-ref: https://fits.gsfc.nasa.gov/standard40/fits_standard40aa-le.pdf
seq:
  - id: hdus
    type: hdu
    repeat: until
    repeat-until: _.is_last
    doc: The primary HDU, followed by the extension HDUs, if any.
instances:
  block_size:
    value: 2880
types:
  hdu:
    seq:
      - id: cards
        size: 80
        type: card
        repeat: until
        repeat-until: _.keyword == "END     "
      - id: header_padding
        size: num_padding_cards * 80
      - id: data
        size: len_data
      - id: data_padding
        size: '(_root.block_size - len_data % _root.block_size) % _root.block_size'
    instances:
      num_padding_cards:
        value: (36 - cards.size % 36) % 36
      len_header:
        value: (cards.size + num_padding_cards) * 80
        doc: Size of the header, a multiple of 2880.
      is_primary:
        value: cards[0].keyword == "SIMPLE  "
      bitpix:
        value: cards[1].integer_value.value
        doc: |
          Bits per data value: 8, 16, 32 or 64 for unsigned 8-bit or signed integers,
          -32 or -64 for IEEE floating-point numbers.
      num_axes:
        value: cards[2].integer_value.value
        doc: Number of axes of the data array, 0 for no data.
      axes:
        type: 'axis(_index, _index == 0 ? 1 : axes[_index - 1].product)'
        repeat: expr
        repeat-expr: num_axes
        doc: The `NAXIS1` to `NAXISn` keyword records, which follow `NAXIS`.
      pcount:
        value: 'is_primary ? 0 : cards[3 + num_axes].integer_value.value'
        doc: Number of bytes in the heap after a binary table, otherwise 0.
      gcount:
        value: 'is_primary ? 1 : cards[4 + num_axes].integer_value.value'
      len_data:
        value: |
          num_axes == 0 ? 0
            : (bitpix < 0 ? -bitpix : bitpix) / 8 * gcount * (pcount + axes.last.product)
        doc: Size of the data, without the padding.
      next_keyword:
        pos: _io.pos
        size: 8
        type: str
        if: _io.size - _io.pos >= 8
        doc: |
          Keyword of the record following this HDU, used right after
          parsing the HDU to tell whether an extension follows.
      is_last:
        value: _io.size - _io.pos < 8 or next_keyword != "XTENSION"
        doc: |
          True if no extension follows, i.e. at the end of the file or
          before special records.
  axis:
    doc: |
      One axis of the data array. It holds no data of its own, only
      values derived from the header of the HDU.
    params:
      - id: idx
        type: s4
        doc: Index of the axis, 0 for `NAXIS1`.
      - id: product_before
        type: s8
        doc: Product of the lengths of the previous axes (1 for the first axis).
    instances:
      card:
        value: _parent.cards[3 + idx]
        doc: The `NAXISn` keyword record.
      len_axis:
        value: card.integer_value.value
      product:
        value: product_before * len_axis
        doc: Product of the lengths of this axis and the previous ones.
  card:
    -webide-representation: '{keyword}{value_indicator}{value_and_comment}'
    seq:
      - id: keyword
        size: 8
        type: str
        doc: Keyword name, padded with spaces.
      - id: value_indicator
        size: 2
        type: str
        doc: '`= ` if the record has a value.'
      - id: value_and_comment
        size: 70
        type: str
        doc: The value and optional comment (after `/`), or commentary text.
    instances:
      has_value:
        value: value_indicator == "= "
      integer_value:
        pos: 10
        size: 20
        type: fixed_integer
        if: has_value
        doc: |
          The value as a fixed-format integer; only meaningful for keywords with an
          integer value, such as the mandatory ones.
  fixed_integer:
    seq:
      - id: leading_spaces
        type: u1
        repeat: until
        repeat-until: _ != 0x20
        doc: The spaces before the number, followed by its first character.
    instances:
      text:
        pos: leading_spaces.size - 1
        size-eos: true
        type: str
      value:
        value: text.to_i
