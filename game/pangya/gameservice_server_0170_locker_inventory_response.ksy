# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0170.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0170_locker_inventory_response
  title: GameService Server Locker Inventory Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet (presumably) contains the user's locker's inventory.
  
  Insufficient packets were (as of yet) captured to attempt proper documentation.
  
  This is a response to [GameService Client 0x00D3 Locker Inventory
  Request](/packets/gameservice/client/00d3.ksy).

seq:
  - id: unknown_a
    size: 8
