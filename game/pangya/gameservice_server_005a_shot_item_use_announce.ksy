# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/005a.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_005a_shot_item_use_announce
  title: GameService Server Shot Item Use Announce
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet relays a user's use of a consumable item.
  
  As with all other shot announce packets, it is not relayed during
  tournaments/simultaneous play.
  
  This is a response to [GameService Client 0x0017 Shot Item
  Use](/packets/gameservice/client/0017.ksy).

seq:
  - id: item_id
    type: u4
    doc: From pangya_xx.iff/Item.iff. The item ID of the used consumable.
  - id: unknown_a
    type: u4
  - id: connection_id
    type: u4
    doc: The connection ID of the user who used the consumable item.
