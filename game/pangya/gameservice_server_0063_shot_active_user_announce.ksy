# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0063.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0063_shot_active_user_announce
  title: GameService Server Shot Active User Announce
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet announces which user is currently up to play.
  
  As with all other shot announce packets, it is not relayed during
  tournaments/simultaneous play.
  
  The response (from the appropriate client) is [GameService Client 0x0022 Shot
  Active User Acknowledge](/packets/gameservice/client/0022.ksy).

seq:
  - id: connection_id
    type: u4
    doc: The user's connection ID who is up.
