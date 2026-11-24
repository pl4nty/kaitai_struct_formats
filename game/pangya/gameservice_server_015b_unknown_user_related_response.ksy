# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/015b.ksy
meta:
  id: gameservice_server_015b_unknown_user_related_response
  title: GameService Server 015B Unknown Response (User Information Related)
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This is one of the responses to [GameService Client 0x002F User Information
  Request](/packets/gameservice/client/002f.ksy).

seq:
  - id: request_type
    type: u1
    enum: request_type
    doc: Matches request packet.
  - id: user_id
    type: u4
    doc: Matches request packet.
  - id: unknown_gss015b_a
    type: u2
    doc: All 0x00? Probably a count for entries.

enums:
  request_type:
    0x00: total
    0x05: season
