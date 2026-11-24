# Imported from https://github.com/sorche942/koa-formats-kaitai/blob/efc04be2db704e88200d287aa5c583c05ec09282/fab_bxml.ksy
meta:
  id: koa_fab_bxml
  title: Kingdoms of Amalur Fab BXML
  file-extension: fab_bxml
  license: LicenseRef-All-Rights-Reserved
  ks-version: 0.11
  endian: le

doc: |
  Reverse-engineered fab BXML container.
  Confirmed/stable today:
  - fixed-size header
  - first data-section ID list (ids_a)
  Remaining tail content is variant-dependent and is kept mostly raw
  to avoid incorrect hard assertions while RE is in progress.
  Also handles nonstandard `.fab_bxml` wrappers seen in corpus:
  - prefixed variants with 12/16/20-byte preambles before a normal "30SE" header
  - fully nonstandard payloads (kept raw)

seq:
  - id: leading_prefix
    size: prefix_len
  - id: header
    type: header
    if: has_header
  - id: data_section
    type: data_section
    if: has_header
  - id: nonstandard_payload
    size-eos: true
    if: not has_header

instances:
  magic_u4_at_4:
    pos: 4
    type: u4
    if: _io.size >= 8
  magic_u4_at_16:
    pos: 16
    type: u4
    if: _io.size >= 20
  magic_u4_at_20:
    pos: 20
    type: u4
    if: _io.size >= 24
  magic_u4_at_24:
    pos: 24
    type: u4
    if: _io.size >= 28
  is_standard_magic:
    value: magic_u4_at_4 == 0x45533033
  is_magic_at_16:
    value: (not is_standard_magic) and _io.size >= 20 and magic_u4_at_16 == 0x45533033
  is_magic_at_20:
    value: (not is_standard_magic) and _io.size >= 24 and magic_u4_at_20 == 0x45533033
  is_magic_at_24:
    value: (not is_standard_magic) and _io.size >= 28 and magic_u4_at_24 == 0x45533033
  is_prefixed_magic:
    value: is_magic_at_16 or is_magic_at_20 or is_magic_at_24
  has_header:
    value: is_standard_magic or is_prefixed_magic
  prefix_len:
    value: 'is_standard_magic ? 0 : (is_magic_at_16 ? 12 : (is_magic_at_20 ? 16 : (is_magic_at_24 ? 20 : 0)))'
  has_standard_header_copy:
    value: 'has_header ? header.header_size == header.header_size_2 : false'

types:
  header:
    seq:
      - id: header_size
        type: u4
      - id: magic
        contents: "30SE"
      - id: header_size_2
        type: u4
      - id: zero_1
        type: u4
      - id: struct_size
        type: u4
      - id: count_a
        type: u4
      - id: count_b
        type: u4
      - id: offset_1
        type: u4
      - id: offset_2
        type: u4
      - id: offset_3
        type: u4
      - id: offset_4
        type: u4
      - id: offset_5
        type: u4
      - id: offset_6
        type: u4
      - id: body
        size: 'header_size >= _io.pos ? header_size - _io.pos : 0'

    instances:
      count_b_lo:
        value: count_b & 0xFFFF
      count_b_hi:
        value: (count_b >> 16) & 0xFFFF
      offset_1_expected_from_count_b_lo:
        value: 0x28 + count_b_lo * 0x10
      offset_1_matches_expected_from_count_b_lo:
        value: offset_1 == offset_1_expected_from_count_b_lo
      offsets_all_in_header:
        value: offset_1 < header_size and offset_2 < header_size and offset_3 < header_size and offset_4 < header_size and offset_5 < header_size and offset_6 < header_size

  data_section:
    seq:
      - id: zero_1
        type: u4
        if: has_count_ids_a
      - id: count_ids_a
        type: u4
        if: has_count_ids_a
      - id: ids_a
        type: u4
        repeat: expr
        repeat-expr: num_ids_a_safe
        if: has_count_ids_a
      - id: tail
        size-eos: true
        type: data_tail

    instances:
      has_count_ids_a:
        value: _io.size - _io.pos >= 8
      num_ids_a_safe:
        value: 'has_count_ids_a ? (count_ids_a <= ((_io.size - _io.pos) / 4) ? count_ids_a : 0) : 0'
      ids_a_was_truncated:
        value: has_count_ids_a and num_ids_a_safe != count_ids_a
      count_a_matches_ids_a:
        value: _root.has_header and has_count_ids_a and _root.header.count_a == count_ids_a
      safe_to_reauthor_ids_a:
        value: _root.has_header and has_count_ids_a and (not ids_a_was_truncated) and count_a_matches_ids_a and _root.header.offset_1_matches_expected_from_count_b_lo
      count_ids_b:
        value: 'tail.has_count_ids_b ? tail.count_ids_b : 0'
      count_items:
        value: 'tail.has_count_items ? tail.count_items : 0'

  data_tail:
    doc: |
      Variant-dependent tail.
      We only decode length-safe scalar/count probes; everything else stays raw.
    seq:
      - id: count_ids_b
        type: u4
        if: has_count_ids_b
      - id: ids_b_raw
        size: ids_b_raw_len
        if: has_ids_b_block
      - id: count_items
        type: u4
        if: has_count_items
      - id: remaining
        size-eos: true

    instances:
      has_count_ids_b:
        value: _io.size >= 4
      ids_b_raw_len:
        value: 'has_count_ids_b and count_ids_b * 4 <= _io.size - 4 ? count_ids_b * 4 : 0'
      has_ids_b_block:
        value: has_count_ids_b and ids_b_raw_len > 0
      has_count_items:
        value: has_count_ids_b and count_ids_b * 4 <= _io.size - 8

  vector3:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4

  quaternion:
    seq:
      - id: x
        type: f4
      - id: 'y'
        type: f4
      - id: z
        type: f4
      - id: w
        type: f4
