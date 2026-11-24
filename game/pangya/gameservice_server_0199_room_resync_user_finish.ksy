# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0199.ksy
meta:
  id: gameservice_server_0199_room_resync_user_finish
  title: GameService Server 0199 Room Resync User Finish
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet denotes that the player who most recent shot holed-out on the last
  hole of the match.
  
  It has no payload.
  
  Its one of the responses to [GameService Client 0x001C Room
  Resync](/packets/gameservice/client/001c.ksy).
