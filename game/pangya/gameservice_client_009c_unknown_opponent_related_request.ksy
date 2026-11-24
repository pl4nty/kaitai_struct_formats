# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/009c.ksy
meta:
  id: gameservice_client_009c_unknown_opponent_related_request
  title: GameService Client 009C Unknown Request (VS Mode Opponent Related)
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is sent at the beginning of each hole in VS rooms, presumably to
  information about the opponent(s).
  
  This packet has no payload.

  The response is [Gameservice Server 0x010E Unknown Response (VS Mode Opponent
  Related)](/packets/gameservice/server/010e.ksy).
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_MATCH_HISTORY`
