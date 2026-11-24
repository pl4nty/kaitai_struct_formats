# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0138.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0138_user_cardholic_inventory
  title: GameService Server User Cardholic Inventory
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet details the user's cardholic collection.

  This is one of the responses to [GameService Client 0x0002 Hello /
  Login](/packets/gameservice/client/0002.ksy).

seq:
  - id: unknown_a
    size: 4
    doc: Always 0x00.
  - id: card_count
    type: u2
  - id: cards
    type: card
    repeat: expr
    repeat-expr: card_count

types:
  card:
    seq:
      - id: inventory_slot_card
        type: u4
      - id: item_id_card
        type: u4
        doc: From pangya_xx.iff/Card.iff.
      - id: unknown_b
        size: 12
        doc: All 0x00.
      - id: item_quantity_card
        type: u4
      - id: unknown_c
        size: 32
        doc: All 0x00.
      - id: unknown_d
        type: u2
        doc: All examples 1 (0x0001).
