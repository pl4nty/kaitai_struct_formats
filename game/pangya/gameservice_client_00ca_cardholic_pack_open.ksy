# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/00ca.ksy
meta:
  id: gameservice_client_00ca_cardholic_pack_open
  title: GameService Client Cardholic Pack Open
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet opens a card pack ('Gold Card Ticket', etc.)
  
  The response is [GameService Server 0x0154 Cardholic Pack Open
  Response](/packets/gameservice/server/0154.ksy).
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_OPEN_CARD`

seq:
  - id: item_id
    type: u4
    doc: From pangya_xx.iff/Card.iff. Item ID of card pack opened.
  - id: unknown_id
    type: u4
    doc: Possibly an inventory id of some kind? Reappears in response.
