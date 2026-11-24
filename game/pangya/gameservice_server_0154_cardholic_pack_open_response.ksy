# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0154.ksy
meta:
  id: gameservice_server_0154_cardholic_pack_open_response
  title: GameService Server Cardholic Pack Open Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet reports the received items from the opening of a card pack.
  
  It is a response to [GameService Client 0x00CA Cardholic Pack
  Open](/packets/gameservice/client/00ca.ksy).
  
seq:
  - id: unknown_a
    size: 4
    doc: Possibly padding?
  - id: pack_unknown_id
    type: u4
    doc: From request. Possibly inventory id of opened pack.
  - id: pack_item_id
    type: u4
    doc: From pangya_xx.iff/Card.iff. Item ID of opened pack.
  - id: unknown_b
    size: 51
  - id: card_unknown_id
    type: u4
    doc: Similar to pack's unknown id.
  - id: card_item_id
    type: u4
    doc: From pangya_xx.iff/Card.iff. Item ID of new card.
  - id: unknown_c
    size: 54
