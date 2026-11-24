# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/00b7.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_00b7_inventory_open_b
  title: GameService Client Inventory Open B
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is one of two that signals the user has opened the inventory screen.
  
  The responses are [GameService Server 0x012D My Room
  Layout](/packets/gameservice/server/012d.ksy)
  and [GameService Server 0x0168 User
  Information](/packets/gameservice/server/0168.ksy).
  
  **See Also:**
  * [GameService Client 0x00B5 Inventory Open
    A](/packets/gameservice/client/00b5.ksy).
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_ENTER_ROOM_GETINFO`

seq:
  - id: user_id
    type: u4
    doc: Local user's ID
  - id: unknown_a
    size: 1
    doc: All examples show 1 (0x01).
