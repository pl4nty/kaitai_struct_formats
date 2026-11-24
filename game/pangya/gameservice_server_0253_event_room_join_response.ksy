# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0253.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 0253
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_0253_event_room_join_response
  title: GameService Server Event Room Join Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges the user has joined an event room.
  
  It is one of the responses to [GameService Client 0x0179 Event Room
  Join](/packets/gameservice/client/0179.ksy).

seq:
  - id: unknown_a
    type: u4
    doc: All examples are 0 (0x00000000).
