# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/00f6.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 00f6
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_00f6_multiplayer_mode_leave_response
  title: GameService Server Multiplayer Mode Leave Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges a user has left multiplayer mode.
  
  It has no payload.
  
  It is a response to [GameService Client 0x0082 Multiplayer Mode
  Leave](/packets/gameservice/client/0082.ksy).
  
  **See Also** [GameService Server 0x00F5 Multiplayer Mode Join
  Response](/packets/gameservice/server/00f5.ksy).
