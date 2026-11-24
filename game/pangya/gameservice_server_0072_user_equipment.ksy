# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0072.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0072_user_equipment
  title: GameService Server User Equipment
  license: ISC
  imports:
    - pstring
    - user_equipment_data
  encoding: ASCII
  endian: le

doc: |
  This packet lists current equipped consumables, and potentially other things.
  
  This packet is sent during the response to [GameService Client 0x0002
  Hello](/packets/gameservice/client/0002.ksy).

seq:
  - id: user_equipment_data
    type: user_equipment_data
    doc: More details can be found in type definition file.
