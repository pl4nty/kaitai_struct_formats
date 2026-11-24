meta:
  id: asterix_compound
  title: ASTERIX compound data field
  license: GPL-3.0-only
  ks-version: 0.9
  imports:
    - asterix_field_spec
    - asterix_fixed
    - asterix_repetitive
    - asterix_explicit
    - asterix_extended

  endian: be

doc: |
  Implementation of ASTERIX format.

  From Eurocontrol Asterix web page at
  https://www.eurocontrol.int/asterix

  Compound Standard Field format.

  The compound field format is a variable length and content field.
  This uses four parameters:

  item, which is just the item name, as I001/010, or I062/390. It is just
  informative, and is not used during parsing, but permits consult the item name
  in the target language.

  f_fmt, is a string with a list of the formats of the subfields,
  The available formats are:
      F, for Fixed.
      E, for Explicit.
      X, for Extended.
      R, for Repetitive.
      Z (or any other character), for an absent subfield.

  f_pri_sizes, is an array of the parameter sizes for the subfields formats.

  f_sec_sizes, is an array of the second parameter size, which is only used for
  Extended subfields. For all the other formats a 0 should be used, although it is
  not used at all.

doc-ref: |
  https://www.eurocontrol.int/publication/eurocontrol-specification-surveillance-data-exchange-part-i

params:
  - id: name
    type: str
  - id: f_fmt
    type: str
  - id: f_pri_sizes
  - id: f_sec_sizes

seq:
  - id: flags
    type: asterix_field_spec
  - id: data
    doc: |
      Subfield k is announced by bit k % 7 of primary-subfield octet k / 7.
      When the FX chain ends before that octet, the subfield is absent
      (ASTERIX Part 1, compound data item format), so the index is bounds
      checked before the bit is read.
    type:
      switch-on: f_fmt.substring(_index, _index + 1)
      cases:
        '"E"': asterix_explicit("", (_index / 7 < flags.octects.size and flags.octects[_index / 7].bits[_index % 7]))
        '"F"': asterix_fixed("", (_index / 7 < flags.octects.size and flags.octects[_index / 7].bits[_index % 7]), f_pri_sizes[_index])
        '"R"': asterix_repetitive("", (_index / 7 < flags.octects.size and flags.octects[_index / 7].bits[_index % 7]), f_pri_sizes[_index])
        '"X"': asterix_extended("", (_index / 7 < flags.octects.size and flags.octects[_index / 7].bits[_index % 7]), f_pri_sizes[_index], f_sec_sizes[_index])
        _: empty
    repeat: expr
    repeat-expr: total_flags

instances:
  total_flags:
    value: 'f_fmt.length'

  type:
    value: '"Compound"'


types:
  empty:
    seq:
      - id: no_val
        size: 0

    instances:
      tot_size:
        value: 0
