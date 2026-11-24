# Imported from https://github.com/sorche942/koa-formats-kaitai/blob/efc04be2db704e88200d287aa5c583c05ec09282/questmgr.ksy
meta:
  id: koa_questmgr_bin
  title: Kingdoms of Amalur QuestMgr.bin
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  ks-version: 0.9
  endian: le

doc: |
  Reverse-engineered QuestMgr.bin layout (little-endian).

  Observed core sections:
  - primary quest ID set
  - full quest ID set
  - cheat mapping rows (quest_id + label)

  Optional patch-era sections:
  - meta quest ID set
  - metadata rows (location/stage/token)

  Runtime notes (koa.exe):
  - Quest IDs are canonicalized via a binary-search table in QuestMgr runtime
    state
    (`0x00A70B80` / `0x00A6D5F0`).
  - Lookup resolves `quest_id -> canonical index -> resource/key` before quest
    payload streaming/decode.

seq:
  - id: count_primary
    type: u4
  - id: quest_ids_primary
    type: u4
    repeat: expr
    repeat-expr: count_primary

  - id: count_full
    type: u4
  - id: quest_ids_full
    type: u4
    repeat: expr
    repeat-expr: count_full

  - id: count_cheat
    type: u4
  - id: cheat_rows
    type: cheat_row
    repeat: expr
    repeat-expr: count_cheat

  - id: optional_tail
    size-eos: true
    type: optional_tail

types:
  optional_tail:
    seq:
      - id: count_meta_ids
        type: u4
        if: not _io.eof
      - id: quest_ids_meta
        type: u4
        repeat: expr
        repeat-expr: count_meta_ids
        if: not _io.eof

      - id: count_meta_rows
        type: u4
        if: not _io.eof
      - id: meta_rows
        type: meta_row
        repeat: expr
        repeat-expr: count_meta_rows
        if: not _io.eof

  cheat_row:
    seq:
      - id: quest_id
        type: u4
      - id: label_len
        type: u4
      - id: label
        size: label_len
        type: str
        encoding: ASCII

  meta_row:
    seq:
      - id: location_len
        type: u4
      - id: location_key
        size: location_len
        type: str
        encoding: ASCII
      - id: stage_len
        type: u4
      - id: stage_label
        size: stage_len
        type: str
        encoding: ASCII
      - id: token
        type: u8
