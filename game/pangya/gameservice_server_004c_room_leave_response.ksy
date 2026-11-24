# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/004c.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_004c_room_leave_response
  title: GameService Server Room Leave Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges the user has left a room and returned to the
  multiplayer lobby.
  
  It is a response to:
  * [GameService Client 0x000F Room Leave](/packets/gameservice/client/000f.ksy).
  * [GameService Client 0x00AA Match Statistics Submit (Tiki
    Report)](/packets/gameservice/client/00aa.ksy).

seq:
  - id: room_number
    type: s2
    doc: The new room number, which is always -1 (0xFFFF) for the lobby.
