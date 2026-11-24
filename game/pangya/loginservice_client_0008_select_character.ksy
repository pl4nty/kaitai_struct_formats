# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/loginservice/client/0008.ksy
# Licence and copyright: see _community/README.md
meta:
  id: loginservice_client_0008_select_character
  title: LoginService Client Select Character
  license: ISC
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client during first login to select a
  character.
  
  In `hsreina/pangya-server`, the packet ID is `TCLPID.PLAYER_SELECT_CHARCTER`.

seq:
  - id: character_id
    type: u4
    doc: ID of selected character.
  - id: hair_color
    type: u2
    doc: ID of selected hair color for character.
