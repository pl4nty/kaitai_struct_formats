# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0264.ksy
meta:
  id: gameservice_server_0264_memorial_coin_result
  title: GameService Server Memorial Coin Result
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains the result of a Memorial Coin play.
  
  This is one of the responses to [GameService Client 0x017F Memorial Coin
  Play](/packets/gameservice/client/017f.ksy).

seq:
  - id: unknown_a
    type: u4
    doc: All examples show 0 (0x00000000).
  - id: unknown_b
    type: u4
    doc: All examples show 1 (0x00000001).
  - id: unknown_c
    type: s4
    doc: All examples show -1 (0xFFFFFFFF).
  - id: item_id
    type: u4
    doc: From pangya_xx.iff/Item.iff. Item ID of prize won.
  - id: item_quantity
    type: u4
    doc: Number of specified items won.
