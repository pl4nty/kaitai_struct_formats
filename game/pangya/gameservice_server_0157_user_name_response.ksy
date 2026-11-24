# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0157.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0157_user_name_response
  title: GameService Server User Name Response
  license: ISC
  imports:
    - pstring
    - user_name_data
  encoding: ASCII
  endian: le

doc: |
  This packet contains display name and guild information about a requested user.
  
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
  - id: user_name_data
    type: user_name_data
    doc: More details can be found in type definition file.
  - id: unknown_gss0157_a
    size: 4
    doc: All 0x00?

enums:
  request_type:
    0x05: season
