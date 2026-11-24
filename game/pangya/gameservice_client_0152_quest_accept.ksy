# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0152.ksy
meta:
  id: gameservice_client_0152_quest_accept
  title: GameService Client Quest Accept
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet accepts the currently offered lineup of daily quests.
  
  Its response is [GameService Server 0x0226 Quest Accept
  Response](/packets/gameservice/server/0226.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_ACCEPT_DAILY_QUEST`
  * `eantoniobr/UGPangya`: `PLAYER_ACCEPT_QUEST`

seq:
  - id: quest_count
    type: u4
  - id: quest_status_slot
    type: u4
    repeat: expr
    repeat-expr: quest_count
