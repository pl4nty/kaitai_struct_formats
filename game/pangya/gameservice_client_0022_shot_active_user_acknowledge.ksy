# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0022.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_0022_shot_active_user_acknowledge
  title: GameService Client Shot Active User Acknowledge
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges that it is the local user's turn to play.
  
  There is no payload.
  
  This is the response to [GameService Server 0x0063 Shot Active User
  Announce](/packets/gameservice/server/0063.ksy).
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_MY_TURN`
