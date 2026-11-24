# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0185.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 0145
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_0185_shot_assist_activate
  title: GameService Client Shot Assist Activate
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet activates shot assist for a given shot during a match.
  
  The response is [GameService Server 0x026B Shot Assist Activate
  Response](/packets/gameservice/server/026b.ksy).
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_CALL_ASSIST_PUTTING`

seq:
  - id: item_id
    type: u4
    doc: From pangya_xx.iff/Item.iff. The 'Play Assist' item ID (0x1BE00016).
