# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0156.ksy
meta:
  id: gameservice_server_0156_user_equipment_response
  title: GameService Server User Equipment Response
  license: ISC
  imports:
    - pstring
    - user_equipment_data
  encoding: ASCII
  endian: le

doc: |
  This packet contains details about the requested user's equipment.
  
  This packet is a response to [GameService Client 0x002F User Information
  Request](/packets/gameservice/client/002f.ksy).

seq:
  - id: request_type
    type: u1
    enum: request_type
    doc: Matches request packet. Only 0x05 witnessed.
  - id: user_id
    type: u4
    doc: Matches request packet.
  - id: user_equipment_data
    type: user_equipment_data
    doc: More details can be found in type definition file.

enums:
  request_type:
    0x05: season
