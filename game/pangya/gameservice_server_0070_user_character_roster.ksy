# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0070.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 0070
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_0070_user_character_roster
  title: GameService Server User Character Roster
  license: ISC
  imports:
    - pstring
    - user_character_data
  encoding: ASCII
  endian: le

doc: |
  This packet contains the character roster for the user.
  
  It is one of the responses to [GameService Client 0x0002 Hello /
  Login](/packets/gameservice/client/0002.ksy).

seq:
  - id: character_count_a
    type: u2
    doc: Unconfirmed. Max be count or max.
  - id: character_count_b
    type: u2
    doc: Unconfirmed. May be count or max.
  - id: characters
    type: user_character_data
    repeat: expr
    repeat-expr: character_count_b
