# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/00a7.ksy
meta:
  id: gameservice_server_00a7_lootbox_inventory_update
  title: GameService Server Lootbox Inventory_Update
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet updates the relevant number of lootboxes and keys after having used
  some.
  
  This is one of the responses to [GameService Client 0x00EF Lootbox
  Open](/packets/gameservice/client/00ef.ksy).

seq:
  - id: item_count
    type: u1
  - id: items
    type: item
    repeat: expr
    repeat-expr: item_count
    
types:
  item:
    seq:
      - id: item_id
        type: u4
        doc: From pangya_xx.iff/Item.iff. Lootbox or key item ID.
      - id: inventory_slot
        type: u4
      - id: item_quantity
        type: u2
        doc: New quantity of item.
