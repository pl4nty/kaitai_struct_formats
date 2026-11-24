# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/00e7.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 00e7
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_00e7_user_shop_leave_response
  title: GameService Server User Shop Leave Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges a user has stopped browsing a shop.
  
  It is the response to [GameService Client 0x0078 User Shop
  Leave](/packets/gameservice/client/0078.ksy).

seq:
  - id: unknown_a
    type: u4
    doc: All examples show 1 (0x00000001)
