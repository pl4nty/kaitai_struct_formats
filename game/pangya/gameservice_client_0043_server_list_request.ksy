# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0043.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_0043_server_list_request
  title: GameService Client Server List Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests a server and sub-server list. It has no payload.
  
  The response is [Gameservice Server 0x009F Server
  List](/packets/gameservice/server/009f.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_REQUEST_SERVERS_LIST`
  * `eantoniobr/UGPangya`: `PLAYER_REQUEST_LOBBY_INFO`
