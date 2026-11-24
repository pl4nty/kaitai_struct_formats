# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0132.ksy
meta:
  id: gameservice_server_0132_treasure_point_status
  title: GameService Server Treasure Point Status
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains the progress toward filling the Treasure Point meter.
  
  It is one of the responses to [GameService Server 0x001C Room
  Resync](/packets/gameservice/client/001c.ksy).

seq:
  - id: treasure_point_amount
    type: u4
    doc: |
      Can exceed 1000 (0x03E8), although the displayed meter caps at 1000 no
      additional benefit is believed to exist.
