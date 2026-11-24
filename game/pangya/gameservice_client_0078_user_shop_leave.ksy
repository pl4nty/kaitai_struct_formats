# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0078.ksy
meta:
  id: gameservice_client_0078_user_shop_leave
  title: GameService Client User Shop Leave
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet notes that a user has stopped browsing a user shop.
  
  The response is [GameService Server 0x00E7 User Shop Leave
  Response](/packets/gameservice/server/00e7.ksy).
  
  **See Also:** [GameService Client 0x0077 User Shop Inventory
  Request](/packets/gameservice/client/0077.ksy), to start browsing.

seq:
  - id: user_id
    type: u4
    doc: Seller's user ID.
