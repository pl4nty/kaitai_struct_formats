# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/005b.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 005b
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_005b_room_resync_unknown
  title: GameService Server Room Resync Unknown
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is of unknown use.

  This is one of the responses to [GameService Client 0x001C Room
  Resync](/packets/gameservice/client/001c.ksy).

seq:
  - id: unknown_a
    type: u2
    doc: Appears to remain consistent throughout a single hole for all players.
  - id: unknown_b
    type: u2
  - id: unknown_c
    type: u1
    doc: All examples 1 (0x01).
