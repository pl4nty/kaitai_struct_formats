# Imported from https://github.com/whitearine/wolf-rpg-kaitai/blob/42cd3f6a1d31fb6d0da1042c47c4ec692d7217a8/len_str.ksy
# Licence and copyright: see _community/README.md
meta:
  id: len_str
  title: WOLF RPG Editor length-prefixed string
  license: MIT
  endian: le
types:
  len_str:
    seq:
      - id: len
        type: u4
      - id: str
        size: len
