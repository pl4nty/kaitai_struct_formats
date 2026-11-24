meta:
  id: smile
  title: Smile binary JSON
  xref:
    mime: application/x-jackson-smile
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  Smile is a binary, JSON-compatible data format created by the Jackson JSON
  processor project. Its data model is exactly JSON's: a document is a
  sequence of tokens forming nested objects, arrays and scalar values.

  A Smile stream starts with a 4-byte header (`:)` + LF + a flags byte) and
  is followed by value tokens. Every token starts with a type byte which
  defines how many (if any) bytes follow. Tokens are interpreted in one of
  two modes: "value mode" (top level, inside arrays and in value position
  inside objects), and "key mode" (property name position inside objects).

  This spec parses the complete token structure: objects, arrays, all
  string flavours, integers (VInt with ZigZag), floats (7-bit packed IEEE
  754 bits), big integers / big decimals and binary data. What it cannot do
  is resolve shared-string back references (tokens which refer to the N-th
  previously seen short string or key name): such tokens are exposed with
  their raw reference index, and the application must keep the tables of
  seen strings itself, as described in the specification.

  Floating point values are exposed as the raw IEEE 754 bit pattern
  (`float_bits`), since the spec reassembles them from 7-bit groups.

  Only a single section (header + values up to end of stream or the 0xFF
  end marker) is parsed; concatenated sections are not handled.
doc-ref: https://github.com/FasterXML/smile-format-specification/blob/master/smile-specification.md
seq:
  - id: header
    type: header
  - id: values
    type: value
    repeat: until
    repeat-until: _.marker == 0xff or _io.eof
    doc: |
      Root-level values. Parsing stops at the end of the stream or after
      the optional 0xFF end-of-content marker.
types:
  header:
    seq:
      - id: magic
        contents: [':', ')', 0x0a]
      - id: version
        type: b4
        doc: Format version; 0 for the current version.
      - id: reserved
        type: b1
      - id: has_raw_binary
        type: b1
        doc: Whether raw (unescaped 8-bit) binary values may be present.
      - id: has_shared_string_values
        type: b1
        doc: |
          Whether shared value string checking was enabled during encoding,
          i.e. whether value back references may appear.
      - id: has_shared_property_names
        type: b1
        doc: |
          Whether shared property name checking was enabled during
          encoding, i.e. whether key name back references may appear.
  value:
    doc: A token in value mode.
    seq:
      - id: marker
        type: u1
        doc: Type byte of the token.
      - id: body
        type:
          switch-on: token_type
          cases:
            0x24: zigzag_vint
            0x25: zigzag_vint
            0x26: big_integer
            0x28: packed_float(5)
            0x29: packed_float(10)
            0x2a: big_decimal
            0xe0: long_string
            0xe4: long_string
            0xe8: safe_binary
            0xf8: array
            0xfa: object
            0xfd: raw_binary
        if: not is_short_string and not is_long_shared_ref
      - id: str_value
        size: short_string_len
        type: str
        encoding: UTF-8
        if: is_short_string
        doc: Value of a tiny / short ASCII or Unicode string.
      - id: long_shared_ref_lsb
        type: u1
        if: is_long_shared_ref
        doc: Low 8 bits of a long shared value string reference.
    instances:
      token_type:
        value: '(marker >= 0xe0 and marker <= 0xef) ? marker & 0xfc : marker'
        doc: |
          Type byte with the 2 low bits masked out for 0xe0-0xef, where they
          are either reserved or (for long shared references) part of the
          index.
      is_short_shared_ref:
        value: marker >= 0x01 and marker <= 0x1f
        doc: Short shared value string reference (index in `marker`).
      is_long_shared_ref:
        value: token_type == 0xec
      shared_ref_index:
        value: 'is_short_shared_ref ? marker - 1 : ((marker & 0x03) << 8) | long_shared_ref_lsb'
        if: is_short_shared_ref or is_long_shared_ref
        doc: |
          Index into the table of previously seen shareable value strings.
          A short reference with type byte N refers to index N - 1.
      is_empty_string:
        value: marker == 0x20
      is_null:
        value: marker == 0x21
      is_bool:
        value: marker == 0x22 or marker == 0x23
      bool_value:
        value: marker == 0x23
        if: is_bool
      is_small_int:
        value: marker >= 0xc0 and marker <= 0xdf
      small_int_value:
        value: '((marker & 0x1f) >> 1) ^ -(marker & 0x01)'
        if: is_small_int
        doc: ZigZag-decoded value in range -16..15.
      is_short_string:
        value: marker >= 0x40 and marker <= 0xbf
      is_ascii:
        value: (marker >= 0x40 and marker <= 0x7f) or token_type == 0xe0
      short_string_len:
        value: 'marker <= 0x7f ? marker - 0x3f : marker - 0x7e'
        if: is_short_string
        doc: |
          Byte length of a short string: 0x40-0x7f encode ASCII strings of
          1-64 bytes, 0x80-0xbf encode UTF-8 strings of 2-65 bytes.
      is_end_array:
        value: marker == 0xf9
      is_end_of_content:
        value: marker == 0xff
  key:
    doc: A token in key (property name) mode.
    seq:
      - id: marker
        type: u1
      - id: long_shared_ref_lsb
        type: u1
        if: is_long_shared_ref
        doc: Low 8 bits of a long shared key name reference.
      - id: long_name
        type: str
        terminator: 0xfc
        encoding: UTF-8
        if: marker == 0x34
        doc: Long (not yet shared) Unicode name, terminated by 0xfc.
      - id: short_name
        size: short_name_len
        type: str
        encoding: UTF-8
        if: is_short_name
    instances:
      is_empty_name:
        value: marker == 0x20
      is_long_shared_ref:
        value: marker >= 0x30 and marker <= 0x33
      is_short_shared_ref:
        value: marker >= 0x40 and marker <= 0x7f
      shared_ref_index:
        value: 'is_short_shared_ref ? marker - 0x40 : ((marker & 0x03) << 8) | long_shared_ref_lsb'
        if: is_short_shared_ref or is_long_shared_ref
        doc: Index into the table of previously seen key names.
      is_short_name:
        value: marker >= 0x80 and marker <= 0xf7
      short_name_len:
        value: 'marker <= 0xbf ? marker - 0x7f : marker - 0xbe'
        if: is_short_name
        doc: |
          0x80-0xbf: ASCII names of 1-64 bytes; 0xc0-0xf7: Unicode names of
          2-57 bytes.
      is_end_object:
        value: marker == 0xfb
  array:
    seq:
      - id: items
        type: value
        repeat: until
        repeat-until: _.marker == 0xf9
        doc: Array elements; the last one is the END_ARRAY (0xf9) marker.
  object:
    seq:
      - id: entries
        type: object_entry
        repeat: until
        repeat-until: _.key.is_end_object
        doc: Object members; the last one holds only the END_OBJECT (0xfb) key.
  object_entry:
    seq:
      - id: key
        type: key
      - id: value
        type: value
        if: not key.is_end_object
  long_string:
    seq:
      - id: value
        type: str
        terminator: 0xfc
        encoding: UTF-8
        doc: Variable length string terminated by the 0xfc end-of-string marker.
  vint:
    doc: |
      Unsigned variable length integer: big-endian groups, all but the last
      byte have the MSB clear and carry 7 data bits; the last byte has the
      MSB set and carries 6 data bits (bit 6 is always clear).
    seq:
      - id: groups
        type: u1
        repeat: until
        repeat-until: (_ & 0x80) != 0
    instances:
      last:
        value: groups.size - 1
      value:
        value: |
          ((groups[last] & 0x3f)
          + (last >= 1 ? ((groups[last - 1] & 0x7f) << 6) : 0)
          + (last >= 2 ? ((groups[last - 2] & 0x7f) << 13) : 0)
          + (last >= 3 ? ((groups[last - 3] & 0x7f) << 20) : 0)
          + (last >= 4 ? ((groups[last - 4] & 0x7f) << 27) : 0)
          + (last >= 5 ? ((groups[last - 5] & 0x7f) << 34) : 0)
          + (last >= 6 ? ((groups[last - 6] & 0x7f) << 41) : 0)
          + (last >= 7 ? ((groups[last - 7] & 0x7f) << 48) : 0)
          + (last >= 8 ? ((groups[last - 8] & 0x7f) << 55) : 0)
          + (last >= 9 ? ((groups[last - 9] & 0x7f) << 62) : 0)).as<u8>
  zigzag_vint:
    seq:
      - id: raw
        type: vint
    instances:
      value:
        value: (raw.value >> 1) ^ -(raw.value & 1)
        doc: ZigZag-decoded signed value.
  packed_float:
    doc: |
      IEEE 754 value stored big-endian in 7-bit groups (right-aligned, so
      the first byte holds the leftover most significant bits): 5 bytes for
      a 32-bit float, 10 bytes for a 64-bit double.
    params:
      - id: num_groups
        type: u1
    seq:
      - id: groups
        type: u1
        repeat: expr
        repeat-expr: num_groups
    instances:
      float_bits:
        value: |
          (num_groups == 5 ?
            ((groups[0] & 0x0f) << 28) | ((groups[1] & 0x7f) << 21) | ((groups[2] & 0x7f) << 14)
            | ((groups[3] & 0x7f) << 7) | (groups[4] & 0x7f)
          :
            ((groups[0] & 0x01) << 63) | ((groups[1] & 0x7f) << 56) | ((groups[2] & 0x7f) << 49)
            | ((groups[3] & 0x7f) << 42) | ((groups[4] & 0x7f) << 35) | ((groups[5] & 0x7f) << 28)
            | ((groups[6] & 0x7f) << 21) | ((groups[7] & 0x7f) << 14) | ((groups[8] & 0x7f) << 7)
            | (groups[9] & 0x7f)
          ).as<u8>
        doc: Raw IEEE 754 bit pattern of the value.
  safe_binary:
    doc: |
      Binary data in "safe" 7-bit encoding: a VInt with the decoded length,
      then the data with 7 bits per byte (the last byte holds the remaining
      1-7 bits in its least significant bits).
    seq:
      - id: len_decoded
        type: vint
      - id: encoded
        size: len_encoded
    instances:
      len_encoded:
        value: >-
          (len_decoded.value / 7) * 8
          + (len_decoded.value % 7 == 0 ? 0 : len_decoded.value % 7 + 1)
  raw_binary:
    seq:
      - id: len_data
        type: vint
      - id: data
        size: len_data.value
  big_integer:
    seq:
      - id: magnitude
        type: safe_binary
        doc: Two's complement big-endian bytes of the value (7-bit encoded).
  big_decimal:
    seq:
      - id: scale
        type: zigzag_vint
      - id: magnitude
        type: safe_binary
        doc: Unscaled value as two's complement big-endian bytes (7-bit encoded).
