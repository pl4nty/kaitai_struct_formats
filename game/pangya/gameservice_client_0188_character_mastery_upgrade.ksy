# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0188.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 0188
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_0188_character_mastery_upgrade
  title: GameService Client Character Mastery Upgrade
  license: ISC
  imports:
    - id_bank
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is to improve the character mastery of a given character.
  
  Its responses are:
  * [GameService Server 0x026F Character Mastery Upgrade
    Response](/packets/gameservice/server/026f.ksy),
  * [GameService Server 0x0216 User Status
    Update](/packets/gameservice/server/0216.ksy),
  * [GameService Server 0x022E Achievement
    Unlocked](/packets/gameservice/server/022e.ksy),
  * [GameService Server 0x0220 Achievement
    Update](/packets/gameservice/server/0220.ksy), and
  * [GameService Server 0x00C8 Pang
    Balance](/packets/gameservice/server/00c8.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_CHAR_MASTERY`
  * `eantoniobr/UGPangya`: `PLAYER_UPGRADE_STATUS`
  
  **See Also:**
  * [GameService Server 0x0187 Character Mastery Slot
    Unlock](/packets/gameservice/client/0187.ksy),
  * [GameService Server 0x0189 Character Mastery
    Downgrade](/packets/gameservice/client/0189.ksy),
  * [GameService Server 0x018A Character Mastery Card
    Apply](/packets/gameservice/client/018a.ksy).
    
seq:
  - id: mastery_type
    type: u4
    doc: Denotes character mastery stat being improved.
  - id: item_id_character
    type: u4
    enum: id_bank::item_id_character
    doc: From pangya_xx.iff/Character.iff. Item ID of relevant character.
  - id: roster_slot_character
    type: u4
    doc: User-specific roster slot for relevant character.
  - id: unknown_gsc0188_a
    size: 4
  - id: item_id_parts
    type: u4
    repeat: expr
    repeat-expr: 24
    doc: From pangya_xx.iff/Part.iff. Equipped parts on character. 24 slots?
  - id: unknown_gsc0188_b
    size: 8
    doc: All 0x00?
  - id: inventory_slot_parts
    type: u4
    repeat: expr
    repeat-expr: 24
    doc: Inventory slots for above equipped parts. 24 slots?
  - id: unknown_gsc0188_c
    size: 244
    doc: All 0x00?
  - id: mastery_power_level
    type: u1
    doc: Existing mastery level, before upgrade
  - id: mastery_control_level
    type: u1
    doc: Existing mastery level, before upgrade
  - id: mastery_impact_level
    type: u1
    doc: Existing mastery level, before upgrade
  - id: mastery_spin_level
    type: u1
    doc: Existing mastery level, before upgrade
  - id: mastery_curve_level
    type: u1
    doc: Existing mastery level, before upgrade
  - id: mastery_slot_bonus_count
    type: u1
    doc: Unconfirmed. Bonuses on second tab of Character Mastery screen.
  - id: unknown_gsc0188_d
    size: 51
    doc: All 0x00?
    
enums:
  masteries:
    0x00000000: power
    0x00000001: control
    0x00000002: impact
    0x00000003: spin
    0x00000004: curve
