# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/026e.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_026e_character_mastery_slot_unlock_response
  title: GameService Server Character Mastery Slot Unlock Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges a slot being unlocked in the 2nd character's mastery
  tab.
  
  It is a response to:
  * [GameService Client 0x0187 Character Mastery Slot
    Unlock](/packets/gameservice/client/0187.ksy).
  
seq:
  - id: unknown_gss026e
    size: 4
    doc: All 0x00?
