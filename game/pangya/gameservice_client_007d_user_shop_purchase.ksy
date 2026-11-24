# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/007d.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_007d_user_shop_purchase
  title: GameService Client User Shop Purchase
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is sent when the user buys an item from a user shop in a lounge.
  
  Its responses are:
  * [GameService Server 0x00EC Item
    Transact](/packets/gameservice/server/00ec.ksy), and
  * [GameService Server 0x00ED User Shop Purchase
    Announce](/packets/gameservice/server/00ed.ksy)
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_BUY_SHOP_ITEM`

seq:
  - id: remote_user_id
    type: u4
    doc: Seller's user ID
  - id: unknown_a
    size: 4
  - id: remote_item_id
    type: u4
    doc: From pangya_xx.iff/Item.iff. Seller's item ID for purchased item.
  - id: remote_inventory_id
    type: u4
    doc: Seller's inventory ID for the purchased item.
  - id: item_quantity
    type: u4
  - id: unknown_b
    size: 3
  - id: item_cost
    type: u4
    doc: The pang cost of each purchased item.
  - id: unknown_c
    size: 20
  - id: guild_emblem_id
    size: 9
    type: strz
    doc: Possibly garbage data?
  - id: unknown_d
    size: 121
