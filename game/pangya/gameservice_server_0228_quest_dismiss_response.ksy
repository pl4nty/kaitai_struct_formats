# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0228.ksy
meta:
  id: gameservice_server_0228_quest_dismiss_response
  title: GameService Server Quest Dismiss Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges dismissing quests.
  
  This is one of the responses to [GameService Client 0x0154 Quest
  Dismiss](/packets/gameservice/client/0154.ksy).

seq:
  - id: unknown_a
    type: u4
  - id: quest_count
    type: u4
  - id: quest_status_slot
    type: u4
    repeat: expr
    repeat-expr: quest_count
