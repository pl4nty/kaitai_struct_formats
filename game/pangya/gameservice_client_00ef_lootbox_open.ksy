# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/00ef.ksy
meta:
  id: gameservice_client_00ef_lootbox_open
  title: GameService Client Lootbox Open
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet opens a lootbox ('Spin Cube', 'Attendance Event Box', etc.) that the
  user has in their inventory.
  
  The responses are:
  * [GameService Server 0x00A7 Lootbox Inventory
    Update](/packets/gameservice/server/00a7.ksy) to remove the lootbox and key,
  * [GameService Server 0x00AA Inventory Assign
    Slot](/packets/gameservice/server/00aa.ksy) even if unnecessary,
  * [GameService Server 0x019D Lootbox Open
    Contents](/packets/gameservice/server/019d.ksy) to report the lootbox
    contents,
  * [GameService Server 0x0216 User Status
    Update](/packets/gameservice/server/0216.ksy),
  * [GameService Server 0x022E Achievement
    Unlocked](/packets/gameservice/server/022e.ksy),
  * [GameService Server 0x0220 Achievement
    Update](/packets/gameservice/server/0220.ksy).
  
  **Aliases:**
  * `eantoniobr/UGPangya`: `PLAYER_OPEN_BOX`

seq:
  - id: item_id
    type: u4
    doc: Lootbox's item ID.
