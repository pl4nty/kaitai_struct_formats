# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/00fa.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 00fa
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_00fa_room_bonus_collectables_result
  title: GameService Server Room Bonus Collectables Result
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet details the collectables (coins, spin cubes, tickets, etc.) that
  were obtained throughout a VS round.
  
  It is part of the response to:
  * [Event - Tournament / Match End](/events/match_end.md)

seq:
  - id: user_count
    type: u2
  - id: users
    type: user
    repeat: expr
    repeat-expr: user_count

types:
  user:
    seq:
      - id: connection_id
        type: u4
      - id: unknown_a
        type: u1
      - id: item_count
        type: u2
      - id: item_id
        type: u4
        repeat: expr
        repeat-expr: item_count
        doc: |
          From pangya_xx.iff/Item.iff. Each coin, cube, ticket, etc. is listed
          individually. Coins are awarded with the ID for pang pouches.
