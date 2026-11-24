# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0254.ksy
meta:
  id: gameservice_server_0254_event_room_leave_response
  title: GameService Server Event Room Leave Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges the user has left an event room and returned to the
  Grand Prix event lobby.
  
  It is the response to [GameService Client 0x017A Event Room
  Leave](/packets/gameservice/client/017a.ksy).

seq:
  - id: unknown_a
    type: u4
    doc: All examples are 0 (0x00000000).
  - id: room_number
    type: s2
    doc: The new room number, which is always -1 (0xFFFF) for the lobby.
