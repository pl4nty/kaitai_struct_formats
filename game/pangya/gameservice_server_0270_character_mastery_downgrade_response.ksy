# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0270.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0270_character_mastery_downgrade_response
  title: GameService Server Character Mastery Downgrade Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges a character's mastery level being downgraded.
  
  It is a response to:
  * [GameService Client 0x0189 Character Mastery
    Downgrade](/packets/gameservice/client/0189.ksy).
  
seq:
  - id: unknown_gss0270
    size: 4
    doc: All 0x00?
  - id: mastery_type
    type: u4
    enum: masteries
    doc: Selects which stat has been downgraded.

enums:
  masteries:
    0x00000000: power
    0x00000001: control
    0x00000002: impact
    0x00000003: spin
    0x00000004: curve
