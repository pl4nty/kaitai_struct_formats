# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0177.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 0177
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_0177_event_mode_leave
  title: GameService Client Event Mode Leave
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet announces the client has left Grand Prix event mode.
  
  The response is [GameService Server 0x0251 Event Mode Leave
  Response](/packets/gameservice/server/0251.ksy).
  
  **See Also:**
  * [GameService Client 0x0081 Multiplayer Mode
    Join](/packets/gameservice/client/0081.ksy)
  * [GameService Client 0x0082 Multiplayer Mode
    Leave](/packets/gameservice/client/0082.ksy)
  * [GameService Client 0x0176 Event Mode
    Join](/packets/gameservice/client/0176.ksy)
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_LEAVE_GRAND_PRIX`
  * `eantoniobr/UGPangya`: `PLAYER_LEAVE_MULTIGAME_GRANDPRIX`
