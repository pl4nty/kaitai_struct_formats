# Imported from https://github.com/quatric/Wii-Kaitai/blob/d5029381b1ac4052b07a214f5529978210c7e111/games/pckg.ksy
meta:
  id: town_factory_pckg
  title: Town Factory PCKG package (Little King's Story)
  file-extension: pac
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  Town Factory's `PCKG` package from Little King's Story (Wii); worked out from
  the 2008 `.pac` / `.pcha` / `.pac0-9` / `.bin` / `.dat` packages of the US
  disc. Members are ordinary files (`.brres`, `.col`, `.brstm`, nested PCKG).
  The entry chain starts at 0x20; each entry is padded so `next` is 0x20
  aligned.
seq:
  - id: magic
    contents: 'PCKG'
  - id: zero
    size: 0x1c
  - id: entries
    type: entry
    repeat: until
    repeat-until: _.next == 0 or _io.eof
types:
  entry:
    seq:
      - id: next
        type: u4
        doc: Distance from this entry's start to the next, 0 for the last.
      - id: size
        type: u4
      - id: data_offset
        type: u4
        doc: Payload offset from the entry start (0x20).
      - id: name
        size: 20
        type: strz
        encoding: ASCII
      - id: payload
        size: size
      - id: padding
        size: next - data_offset - size
        if: next != 0
