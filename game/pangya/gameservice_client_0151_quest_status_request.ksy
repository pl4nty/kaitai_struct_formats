# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0151.ksy
meta:
  id: gameservice_client_0151_quest_status_request
  title: GameService Client Quest Status Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests the user's active quests.
  
  It has no payload.
  
  Its responses are:
  * [GameService Server 0x0216 User Status
    Update](/packets/gameservice/server/0216.ksy), and
  * [GameService Server 0x0225 Quest Status
    Response](/packets/gameservice/server/0225.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_REQUEST_DAILY_QUEST`
  * `eantoniobr/UGPangya`: `PLAYER_LOAD_QUEST`
