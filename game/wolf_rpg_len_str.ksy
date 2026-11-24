# Imported from https://github.com/whitearine/wolf-rpg-kaitai/blob/42cd3f6a1d31fb6d0da1042c47c4ec692d7217a8/len_str.ksy
# Licence and copyright: see _community/README.md
meta:
  id: wolf_rpg_len_str
  title: WOLF RPG Editor length-prefixed string
  license: MIT
  endian: le
doc: |
  A u4 length followed by that many bytes of string data. Upstream wraps
  this in a nested `len_str` type; it is the top-level type here so that
  importers referring to `wolf_rpg_len_str` parse the string.
seq:
  - id: len
    type: u4
  - id: str
    size: len
