# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/00ce.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 00ce
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_00ce_tournament_item_winnings
  title: GameService Server Tournament Item Winnings
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains the item winnings from a tournament. These are listed at
  the bottom
  of the results screen.
  
  If a user has won multiple of the same item, duplicates are used to match the
  number won.
  
  It is part of the response to:
  * [Event - Tournament / Match End](/events/match_end.md)

seq:
  - id: unknown_a
    type: u1
  - id: item_count
    type: u1
  - id: item_list
    type: item
    repeat: expr
    repeat-expr: item_count

types:
  item:
    seq:
      - id: item_id
        type: u4
        doc: From pangya_xx.iff/Item.iff
