# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0257.ksy
meta:
  id: gameservice_server_0257_user_gp_trophy_response
  title: GameService Server User Grand Prix Trophy Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains a count of the user's grand prix trophies. This does not
  include standard tournament trophies.
  
  This is one of the responses to [GameService Client 0x002F User Information
  Request](/packets/gameservice/client/002f.ksy).
  
  **See Also:**
  * [GameService Client 0x0159 User Trophies
    Response](/packets/gameservice/server/0159.ksy).

seq:
  - id: request_type
    type: u1
    enum: request_type
    doc: Matches request packet.
  - id: user_id
    type: u4
    doc: Matches request packet.
  - id: user_gp_trophy_count
    type: u2
  - id: user_gp_trophy_data
    type: user_gp_trophy_data
    repeat: expr
    repeat-expr: user_gp_trophy_count

types:
  user_gp_trophy_data:
    seq:
      - id: trophy_slot
        type: u4
        doc: Unconfirmed. User-specific trophy slot for trophy.
      - id: item_id
        type: u4
        doc: From pangya_xx.iff/GrandPrixRankReward.iff.
      - id: item_count
        type: u4
        doc: Number of a given trophy.

enums:
  request_type:
    0x00: total
    0x05: season
