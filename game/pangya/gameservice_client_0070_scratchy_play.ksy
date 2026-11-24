# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0070.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 0070
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_0070_scratchy_play
  title: GameService Client Scratchy Play
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet uses a scratchy card to reveal a prize.
  
  This packet has no payload.
  
  The responses are:
  * [GameService Server 0x0216 User Status
    Update](/packets/gameservice/server/0216.ksy) to award prizes and deduct a
    card, and
  * [GameService Server 0x00DD Scratchy Play
    Result](/packets/gameservice/server/00dd.ksy) to acknowledge the play.
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_PLAY_SCRATCHCARD`
