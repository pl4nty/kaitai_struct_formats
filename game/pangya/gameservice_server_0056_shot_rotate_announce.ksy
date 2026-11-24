# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0056.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 0056
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_0056_shot_rotate_announce
  title: GameService Server Shot Rotate/Aim Announce
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet relays the user's new rotation value to all players.
  
  As with all other shot announce packets, it is not relayed during
  tournaments/simultaneous play.
  
  This is a response to [GameService Client 0x0013 Shot
  Rotate/Aim](/packets/gameservice/client/0013.ksy).

seq:
  - id: connection_id
    type: u4
    doc: The user's connection ID who has rotated their shot.
  - id: rotation_angle
    type: f4
    doc: Increments counterclockwise.
