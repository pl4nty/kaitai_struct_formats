# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0274.ksy
meta:
  id: gameservice_server_0274_tiki_shop_item_recycle_response
  title: GameService Server Tiki Shop Item Recycle Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges converting items to Tiki Points (TP) in Tiki's Shop.
  
  This is one of the responses to [GameService Client 0x018d Tiki Shop Item
  Recycle](/packets/gameservice/client/018d.ksy).

seq:
  - id: unknown_a
    size: 4
    doc: All 0x00?
  - id: tiki_amount
    type: u4
    doc: Number of points gained from recycling.
  - id: tiki_bonus
    type: u4
    doc: Number of bonus points gained from recycling.
