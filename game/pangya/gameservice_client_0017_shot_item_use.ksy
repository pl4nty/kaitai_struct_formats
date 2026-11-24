# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0017.ksy
meta:
  id: gameservice_client_0017_shot_item_use
  title: GameService Client Shot Item Use
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet signals the use of a consumable item during a match.
  
  The response is [GameServer Service 0x005A Shot Item Use
  Announce](/packets/gameservice/server/005a.ksy)
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_USE_ITEM`
  * `eantoniobr/UGPangya`: `PLAYER_USE_ITEM`

seq:
  - id: item_id
    type: u4
    doc: From pangya_xx.iff/Item.iff. Consumable item to be used.
