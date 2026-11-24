# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0172.ksy
meta:
  id: gameservice_server_0172_locker_pang_balance
  title: GameService Server Locker Pang Balance
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains the user's current pang balance within the locker.

  This is the response to [GameService Client 0x00D5 Locker Pang Balance
  Request](/packets/gameservice/client/00d5.ksy),
  and one of the responses to [GameService Client 0x00D4 Locker Change
  Pang](/packets/gameservice/client/00d4.ksy).

seq:
  - id: pang_balance
    type: u4
  - id: unknown_a
    size: 4
    doc: All 0x00.
