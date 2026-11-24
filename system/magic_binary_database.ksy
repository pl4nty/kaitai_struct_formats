meta:
  id: magic_binary_database
  title: file/libmagic compiled magic pattern database
  application:
    - file
    - libmagic
  file-extension: mgc
  tags:
    - database
  license: CC0-1.0
  ks-version: '0.9'
  encoding: UTF-8
doc: |
  A compiled binary database of "magic patterns" that the `file` command
  (and the underlying libmagic library) uses to identify the type of a file.
  It is produced by `file -C -m <source>` from text magic pattern files and
  is usually installed as `/usr/share/misc/magic.mgc` or
  `/usr/share/file/magic.mgc` (see `file --version`).

  The file is an array of fixed-size `struct magic` records written in the
  byte order of the machine that compiled it (libmagic byte-swaps it on
  load when needed). The first record is a header holding the magic number,
  the format version and the number of entries in each of the two sets:
  set 0 holds the ordinary patterns, set 1 the named patterns (`name` type)
  that are invoked with `use`.

  The record layout depends on the format version. This spec supports
  versions 14 (file up to 5.38, 344-byte records), 16-18 (file 5.39-5.45,
  376-byte records) and 20-21 (file 5.46 and later, 432-byte records).
doc-ref:
  - https://github.com/file/file/blob/master/src/file.h
  - https://github.com/file/file/blob/master/src/apprentice.c
  - https://man7.org/linux/man-pages/man5/magic.5.html
seq:
  - id: magic
    type: u4le
    valid:
      any-of:
        - 0xf11e041c
        - 0x1c041ef1
    doc: |
      0xF11E041C in the byte order of the compiling machine; read as
      little-endian here to detect that byte order.
  - id: body
    type: body
types:
  body:
    meta:
      endian:
        switch-on: _root.magic
        cases:
          0xf11e041c: le
          0x1c041ef1: be
    seq:
      - id: version
        type: u4
        valid:
          any-of: [14, 16, 17, 18, 20, 21]
      - id: num_entries
        -orig-id: nmagic
        type: u4
        doc: Number of entries in set 0 (regular patterns).
      - id: num_named_entries
        -orig-id: nmagic
        type: u4
        doc: Number of entries in set 1 (named patterns, `name`/`use`).
      - id: header_padding
        size: len_entry - 16
        doc: Rest of the header record (zero).
      - id: entries
        size: len_entry
        type: magic_entry
        repeat: expr
        repeat-expr: num_entries
      - id: named_entries
        size: len_entry
        type: magic_entry
        repeat: expr
        repeat-expr: num_named_entries
    instances:
      len_entry:
        value: 'version >= 20 ? 432 : version >= 16 ? 376 : 344'
        doc: sizeof(struct magic) for this version (FILE_MAGICSIZE).
      len_value_field:
        value: 'version >= 16 ? 128 : 96'
        doc: MAXstring for this version.
      len_ext:
        value: 'version >= 20 ? 120 : 64'
        doc: MAXEXT for this version.
    types:
      magic_entry:
        -orig-id: magic
        doc: One magic test, i.e. one line of a source magic file.
        seq:
          - id: cont_level_old
            type: u2
            if: _parent.version < 20
          - id: flag_old
            type: u1
            if: _parent.version < 20
          - id: flag_new
            type: u2
            if: _parent.version >= 20
          - id: cont_level_new
            type: u1
            if: _parent.version >= 20
          - id: factor
            type: u1
            doc: Strength adjustment operand (`!:strength`).
          - id: reln
            type: u1
            doc: |
              Relation operator character ('=', '<', '>', '&', '^', '!', 'x', ...); 0 means
              equality.
          - id: len_value_str
            -orig-id: vallen
            type: u1
            doc: Length of the string value, if any.
          - id: type_raw
            -orig-id: type
            type: u1
            doc: Test type (FILE_* constant); see `type`.
          - id: in_type_raw
            -orig-id: in_type
            type: u1
            doc: Type of the indirect offset (FILE_* constant); see `in_type`.
          - id: in_op
            type: u1
            doc: |
              Operator for indirection: bits 0-2 select the operation (see
              `operators`), 0x20 = signed, 0x40 = inverse, 0x80 = indirect.
          - id: mask_op
            type: u1
            doc: Operator for the mask; same encoding as `in_op`.
          - id: cond
            type: u1
            doc: |
              Conditional type (0 = none, 1 = if, 2 = elif, 3 = else) if compiled with
              conditionals.
          - id: factor_op
            type: u1
            doc: Strength adjustment operator character ('+', '-', '*', '/', or 0 for none).
          - id: offset
            type: s4
            doc: Offset of the test.
          - id: in_offset
            type: s4
            doc: Offset applied to the indirect offset.
          - id: lineno
            type: u4
            doc: Line number in the source magic file.
          - id: num_mask
            type: u8
            if: not is_string
            doc: Mask for numeric and date types.
          - id: str_range
            type: u4
            if: is_string
            doc: Repeat/line count (range of a search/regex test).
          - id: str_flags
            type: u4
            if: is_string
            doc: |
              String modifier flags: 0x1 compact whitespace (W), 0x2 compact
              optional whitespace (w), 0x4 ignore lowercase (c), 0x8 ignore
              uppercase (C), 0x10 regex offset start (s), 0x20 text test (t),
              0x40 binary test (b), 0x80/0x100/0x200/0x400/0x800 pascal string
              length width and byte order (0x800 is also the regex line count
              flag), 0x1000 pascal length includes itself (J), 0x2000 trim (T),
              0x4000 full word (f).
          - id: value
            size: _parent.len_value_field
            doc: |
              Test value, a native-endian C union: the string or regex pattern
              (`len_value_str` bytes long) for string types, otherwise an integer,
              float, double or GUID stored from the first byte.
          - id: desc
            size: 64
            type: strz
            doc: Description printed when the test matches.
          - id: mime_type
            -orig-id: mimetype
            size: 80
            type: strz
          - id: apple
            size: 8
            type: strz
            doc: Apple creator/type code.
          - id: ext
            size: _parent.len_ext
            type: strz
            doc: Slash-separated list of popular file extensions.
        instances:
          cont_level:
            value: '_parent.version >= 20 ? cont_level_new : cont_level_old'
            doc: Continuation level (number of leading '>').
          flag:
            value: '_parent.version >= 20 ? flag_new : flag_old'
            doc: |
              Bit flags: 0x01 indir, 0x02 offadd, 0x04 indiroffadd, 0x08 unsigned,
              0x10 nospace, 0x20 bintest, 0x40 texttest, 0x80 offnegative,
              0x100 offpositive (version 20+).
          type:
            value: '(_parent.version < 21 and type_raw >= 50) ? type_raw + 2 : type_raw'
            enum: types
            doc: |
              Test type, normalised to version 21 numbering (version 21 inserted
              `leguid` and `beguid` at 50 and 51, shifting later types by 2).
          in_type:
            value: '(_parent.version < 21 and in_type_raw >= 50) ? in_type_raw + 2 : in_type_raw'
            enum: types
            doc: Indirect offset type, normalised like `type`.
          is_string:
            value: |
              type_raw == 5 or type_raw == 13 or type_raw == 17 or type_raw == 18
              or type_raw == 19 or type_raw == 20 or type_raw == 41 or type_raw == 45
              or type_raw == 46 or type == types::octal
            doc: Whether `type` is a string type (IS_STRING in file.h).
          value_str:
            pos: 32
            size: len_value_str
            if: is_string
            doc: The string/pattern value.
          value_int:
            pos: 32
            type: u8
            if: not is_string
            doc: |
              The first 8 bytes of the value union read as an integer. For types
              narrower than 8 bytes, only the corresponding first bytes of the
              union are meaningful.
enums:
  types:
    0: invalid
    1: byte
    2: short
    3: default
    4: long
    5: string
    6: date
    7: beshort
    8: belong
    9: bedate
    10: leshort
    11: lelong
    12: ledate
    13: pstring
    14: ldate
    15: beldate
    16: leldate
    17: regex
    18: bestring16
    19: lestring16
    20: search
    21: medate
    22: meldate
    23: melong
    24: quad
    25: lequad
    26: bequad
    27: qdate
    28: leqdate
    29: beqdate
    30: qldate
    31: leqldate
    32: beqldate
    33: float
    34: befloat
    35: lefloat
    36: double
    37: bedouble
    38: ledouble
    39: beid3
    40: leid3
    41: indirect
    42: qwdate
    43: leqwdate
    44: beqwdate
    45: name
    46: use
    47: clear
    48: der
    49: guid
    50: leguid
    51: beguid
    52: offset
    53: bevarint
    54: levarint
    55: msdosdate
    56: lemsdosdate
    57: bemsdosdate
    58: msdostime
    59: lemsdostime
    60: bemsdostime
    61: octal
