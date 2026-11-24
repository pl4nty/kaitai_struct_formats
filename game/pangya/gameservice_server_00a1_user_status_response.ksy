# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/00a1.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 00a1
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_00a1_user_status_response
  title: GameService Server User Status Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet (presumably) returns the status of the user requested.
  
  This is a response to [GameServer Client 0x0007 User Status
  Request](/packets/gameservice/client/0007.ksy).

seq:
  - id: unknown_a
    type: u1
    doc: Known examples show 2 (0x02).
