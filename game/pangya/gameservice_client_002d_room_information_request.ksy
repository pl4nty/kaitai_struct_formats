# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/002d.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_002d_room_information_request
  title: GameService Client Room Information Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests information on a game room. There is client-side protection
  against
  sending this packet for private rooms.
  
  The response is [Gameservice Server 0x0086 Room Information
  Response](/packets/gameservice/server/0086.ksy).
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_REQUEST_GAMEINFO`

seq:
  - id: room_number
    type: u2
    doc: |
      From [Gameservice Server 0x0047 Room
      List](/packets/gameservice/server/0047.ksy).
