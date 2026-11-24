# Imported from https://github.com/llama-for3ver/wt_replay_decoder/blob/6b2d759c0048f9757eb662a75110473651763dea/tests/replay.ksy
meta:
  id: war_thunder_replay_header
  file-extension: wrpl
  license: AGPL-3.0-only
  endian: le

seq:
  - id: magic
    type: u4
  - id: version
    type: u4
  - id: level
    size: 128
    type: str
    encoding: ASCII
  - id: level_settings
    size: 260
    type: str
    encoding: ASCII
  - id: battle_type
    size: 128
    type: str
    encoding: ASCII
  - id: environment
    size: 128
    type: str
    encoding: ASCII
  - id: visibility
    size: 32
    type: str
    encoding: ASCII
  - id: rez_offset
    type: u4
  - id: diff
    type: difficulty
  - id: padding1
    size: 35
  - id: session_type
    type: u4
  - id: padding2
    size: 4
  - id: session_id_hex
    type: u8
  - id: padding3
    size: 4
  - id: mset_size
    type: u4
  - id: padding4
    size: 32
  - id: loc_name
    size: 128
    type: str
    encoding: ASCII
  - id: start_time
    type: u4
  - id: time_limit
    type: u4
  - id: score_limit
    type: u4
  - id: padding5
    size: 48
  - id: battle_class
    size: 128
    type: str
    encoding: ASCII
  - id: battle_kill_streak
    size: 128
    type: str
    encoding: ASCII

types:
  difficulty:
    seq:
      - id: unk_nib
        type: b4
      - id: difficulty
        type: b4
