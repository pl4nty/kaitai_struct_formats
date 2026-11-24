# Imported from https://github.com/Bithack/principia/blob/7a5dcfc7697227ebea74e982b6ace1eefd05c11a/utils/kaitai/ppkg.ksy
# Licence and copyright: see _community/README.md
meta:
  id: principia_ppkg
  file-extension: ppkg
  license: BSD-2-Clause
  endian: le
seq:
  - id: version
    type: u1
  - id: community_id
    type: u4
    if: version >= 2
  - id: name
    size: 0xFF
    type: str
    encoding: UTF-8
  - id: levels_unlocked
    type: u1
    if: version >= 3
    doc: The amount of incomplete levels that are available at a time. Default is 2.
  - id: first_is_menu
    type: u1
    if: version >= 1
    doc: |
      When 1, Principia automatically plays the first level in the package. On level
      completion, you go back to this first level. Can be used for a custom level
      selection level.
  - id: return_on_finish
    type: u1
    if: version >= 1
    doc: Return to level select on level finish
  - id: levels
    type: u1
  - id: level_id
    type: u4
    repeat: expr
    repeat-expr: levels
