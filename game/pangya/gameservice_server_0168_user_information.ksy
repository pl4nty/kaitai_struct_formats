# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0168.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0168_user_information
  title: GameService Server User Information
  license: ISC
  imports:
    - pstring
    - user_character_data
  encoding: ASCII
  endian: le

doc: |
  This packet includes a large amount of information about the local user. It's
  possible that, since the other
  response is My Room related, this packet might exist to help render the user in
  the My Room environment.
  
  It is one of the responses to [GameService Client 0x00B7 Open Inventory
  B](/packets/gameservice/client/00b7.ksy).

seq:
  - id: connection_id
    type: u4
  - id: user_nickname
    size: 43
    type: strz
  - id: unknown_a
    size: 13
  - id: user_background
    type: u4
    doc: From pangya_xx.iff/Skin.iff. Background image for portrait card.
  - id: unknown_i
    size: 4
  - id: user_skin
    type: u4
    doc: From pangya_xx.iff/Skin.iff.
  - id: unknown_b
    size: 21
  - id: guild_emblem_id
    size: 13
    type: strz
  - id: user_id
    type: u4
  - id: unknown_c
    size: 10
  - id: unknown_id_a
    type: u4
    doc: Some sort of ID?
  - id: unknown_id_b
    type: u4
    doc: Some sort of ID?
  - id: unknown_id_c
    type: u4
    doc: Some sort of ID?
  - id: unknown_d
    size: 78
  - id: username_atnt
    size: 128
    type: strz
  - id: unknown_e
    size: 8
  - id: user_character
    type: user_character_data
