# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0229.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0229_tiki_shop_card_exchange_response_a
  title: GameService Server Tiki Shop Card Exchange Response A
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges converting cards in the Card Exchange section of Tiki's
  Shop.
  
  This is one of the responses to [GameService Client 0x0155 Tiki Shop Card
  Exchange](/packets/gameservice/client/0155.ksy).

seq:
  - id: unknown_a
    size: 4
    doc: All 0x00?
