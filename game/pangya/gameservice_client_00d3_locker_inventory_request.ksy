# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/00d3.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_00d3_locker_inventory_request
  title: GameService Client Locker Inventory Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests the inventory of the user's locker. It is sent on the first
  inventory screen opening per login,
  as well as before every locker combination attempt thereafter.
  
  There is no payload.
  
  The response is [GameService Server 0x0170 Locker
  Inventory](/packets/gameservice/server/0170.ksy).
  
  **See Also** [GameService Client 0x00CC Locker Combination
  Attempt](/packets/gameservice/client/00cc.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_REQUEST_LOCKER`
  * `eantoniobr/UGPangya`: `PLAYER_ENTER_TO_LOCKER`
