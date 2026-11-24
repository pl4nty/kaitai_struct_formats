# Imported from https://github.com/damir78/iextops/blob/03a9c0925fd14617e9f80350b291e1d665005cd3/src/main/resources/iextops.ksy
meta:
  id: iex_tops
  title: IEX TOPS market data
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: message_type
    type: u1
  - id: body
    type:
      switch-on: message_type
      cases:
        0x51: quote_update
types:
  quote_update:
    seq:
      - id: flags
        type: u1 # or lots of individual flags
      - id: timestamp
        type: u8
      - id: symbol
        size: 10
        type: str
        encoding: ASCII
      - id: bid_size
        type: u4
      - id: bid_price
        type: u8
      - id: ask_price
        type: u8
      - id: ask_size
        type: u4
