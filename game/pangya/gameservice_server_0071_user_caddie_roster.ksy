# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0071.ksy
meta:
  id: gameservice_server_0071_user_caddie_roster
  title: GameService Server User Caddie Roster
  license: ISC
  imports:
    - pstring
    - user_caddie_data
  encoding: ASCII
  endian: le

doc: |
  This packet contains the caddie roster for the user.
  
  It is one of the responses to [GameService Client 0x0002 Hello /
  Login](/packets/gameservice/client/0002.ksy).

seq:
  - id: caddie_count_a
    type: u2
    doc: Unconfirmed. Max be count or max.
  - id: caddie_count_b
    type: u2
    doc: Unconfirmed. May be count or max.
  - id: caddies
    type: user_caddie_data
    repeat: expr
    repeat-expr: caddie_count_b
