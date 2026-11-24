# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0157.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 0157
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_0157_achievement_status_request
  title: GameService Client Achievement Status Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests the user's current progress for all achievements. This is
  most often called for the local user,
  but can be called for other users as well.
  
  The responses are:
  * [GameService Server 0x022D Achievement Status
    Response](/packets/gameservice/server/022d.ksy), and
  * [GameService Server 0x022C Unknown Achievement-Related
    Response](/packets/gameservice/server/022c.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_REQUEST_ACHIEVEMENTS`
  * `eantoniobr/UGPangya`: `PLAYER_CALL_ACHIEVEMENT`

seq:
  - id: user_id
    type: u4
    doc: Target user's ID.
