# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0007.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 0007
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_0007_user_status_request
  title: GameService Client User Status Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests status information on a specified user.
  
  The response is [GameService Server 0x00A1 User Status
  Response](/packets/gameservice/server/00a1.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_REQUEST_OFFLINE_PLAYER_INFO`
  * `eantoniobr/UGPangya`: `PLAYER_CHECK_USER_FOR_GIFT`

seq:
  - id: unknown_a
    type: u1
    doc: Known examples show 1 (0x01).
  - id: user_name
    type: pstring
    doc: User's name being requested.
