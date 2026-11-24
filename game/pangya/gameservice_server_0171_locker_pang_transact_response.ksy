# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0171.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 0171
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_0171_locker_pang_transact_response
  title: GameService Server Locker Pang Transact Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges a change to the user's pang balance within the locker.

  This is one of the responses to [GameService Client 0x00D4 Locker Pang
  Transact](/packets/gameservice/client/00d4.ksy).

seq:
  - id: unknown_a
    size: 4
    doc: All 0x00.
