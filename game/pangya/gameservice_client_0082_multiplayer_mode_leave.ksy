# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0082.ksy
meta:
  id: gameservice_client_0082_multiplayer_mode_leave
  title: GameService Client Multiplayer Mode Leave
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet announces the client has left multiplayer mode.
  This mode gets set when the client opens the multiplayer lobby / game room
  directory,
  remains set while the client is in any multiplayer room, and only becomes unset
  once the client leaves all rooms and the directory.
  
  There is no payload.
  
  The response is [GameService Server 0x00F6 Multiplayer Mode Leave
  Response](/packets/gameservice/server/00f6.ksy).
  
  **See Also:**
  * [GameService Client 0x0081 Multiplayer Mode
    Join](/packets/gameservice/client/0081.ksy)
  * [GameService Client 0x0176 Event Mode
    Join](/packets/gameservice/client/0176.ksy)
  * [GameService Client 0x0177 Event Mode
    Leave](/packets/gameservice/client/0177.ksy)
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_LEAVE_MULTIPLAYER_GAME_LIST`
  * `eantoniobr/UGPangya`: `PLAYER_LEAVE_MULTIGAME_LIST`
