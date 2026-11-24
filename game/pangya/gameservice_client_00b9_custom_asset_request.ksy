# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/00b9.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 00b9
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_00b9_custom_asset_request
  title: GameService Client Custom Asset Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests information for a custom asset (i.e. user designed
  clothing).
  
  The response is:
  * [GameService Server 0x012E Custom Asset
    Response](/packets/gameservice/server/012e.ksy).
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_AFTER_UPLOAD_UCC`
  
seq:
  - id: unknown_gsc00b9_a
    type: u1
    doc: Always 0x01?
  - id: inventory_slot
    type: u4
    doc: Unconfirmed.
  - id: unknown_gsc00b9_b
    type: u1
    doc: Always 0x00?
