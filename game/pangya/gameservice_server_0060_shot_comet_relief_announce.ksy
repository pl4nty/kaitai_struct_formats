# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0060.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 0060
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_0060_shot_comet_relief_announce
  title: GameService Server Shot Comet Relief Announce
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet announces the new location for a user's comet after
  relocation/relief.
  
  It is a response to:
  * [GameService Client 0x0019 Shot Comet
    Relief](/packets/gameservice/client/0019.ksy).

seq:
  - id: unknown_axis_position_a
    type: f4
  - id: unknown_axis_position_b
    type: f4
  - id: unknown_axis_position_c
    type: f4
