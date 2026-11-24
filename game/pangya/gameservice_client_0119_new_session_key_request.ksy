# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0119.ksy
meta:
  id: gameservice_client_0119_new_session_key_request
  title: GameService Client New Session Key Request / Switch Server Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests a new session key to allow switching to a different server.
  
  The response is [Gameservice Server 0x01D4 New Session
  Key](/packets/gameservice/server/01d4.ksy).
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_CHANGE_SERVER`

seq:
  - id: server_id
    type: u4
    doc: ID of the new server for which the requested session key is valid.
