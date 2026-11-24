# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0154.ksy
meta:
  id: gameservice_client_0154_quest_dismiss
  title: GameService Client Quest Dismiss
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet dismisses all incomplete quests.
  
  Its responses are:
  * [GameService Server 0x0216 User Status
    Update](/packets/gameservice/server/0216.ksy), and
  * [GameService Server 0x0228 Quest Dismiss
    Response](/packets/gameservice/server/0227.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_GIVEUP_DAILY_QUEST`

seq:
  - id: quest_count
    type: u4
  - id: quest_status_slot
    type: u4
    repeat: expr
    repeat-expr: quest_count
