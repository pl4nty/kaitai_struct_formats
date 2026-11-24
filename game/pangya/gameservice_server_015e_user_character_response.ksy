# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/015e.ksy
meta:
  id: gameservice_server_015e_user_character_response
  title: GameService Server User Character Response
  license: ISC
  imports:
    - pstring
    - user_character_data
  encoding: ASCII
  endian: le

doc: |
  This packet details a user's character and equipment.

  This is one of the responses to [GameService Client 0x002F User Information
  Request](/packets/gameservice/client/002f.ksy).

seq:
  - id: user_id
    type: u4
  - id: user_character
    type: user_character_data
