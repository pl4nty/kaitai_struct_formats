# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/00c8.ksy
meta:
  id: gameservice_server_00c8_pang_balance
  title: GameService Server Pang Balance
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains the user's pang balance.
  
  It is part of the response to:
  * [Event - Tournament / Match End](/events/match_end.md), and
  * many other events and packets.

seq:
  - id: pang_balance
    type: u4
  - id: unknown_a
    size: 12
    doc: All 0x00.
