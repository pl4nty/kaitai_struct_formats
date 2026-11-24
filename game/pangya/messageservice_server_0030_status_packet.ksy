# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/server/0030.ksy
meta:
  id: messageservice_server_0030_status_packet
  title: MessageService Server Status Packet
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet appears to serve many of the Messaging Server's duties, in terms
  of providing status updates and responses to interactions with the service.
  
  **See Also**:
  [MessageService Client 0x0017 User ID
  Lookup](/packets/messageservice/client/0017.ksy)
  [MessageService Client 0x0018 Friend
  Request](/packets/messageservice/client/0018.ksy)

seq:
  - id: subtype
    type: u2
    enum: subtype
    doc: Type of status update.
  - id: response
    type:
      switch-on: subtype
      cases:
        subtype::unconf_pending_friend_requests: s0102_unk_pending_friend_requests
        subtype::friend_request_response: s0104_friend_request_response
        subtype::unknown_0115: s0115_unk
        subtype::user_id_lookup_response: s0117_user_id_lookup_response

types:
  s0102_unk_pending_friend_requests:
    doc: Sent after Client 0x0014 Hello (2/2).
    seq:
      - id: unknown
        type: u1
        doc: Unknown
      - id: unk_pending_entries
        type: u2
        doc: Unknown, likely a 'pending entries' for multi-packet splitting.
      - id: unk_entry_count
        type: u4
        doc: Unknown, likely a entry count.
      - id: entries
        type: s0102_entry
        repeat: expr
        repeat-expr: unk_entry_count
  s0102_entry:
    doc: This appears in both Server 0x0102 and Server 0x0104.
    seq:
      - id: user_nickname
        size: 22
        type: strz
        doc: Target user's nickname.
      - id: string_friend
        size: 25
        type: strz
        doc: Says 'Friend'. May be indication of different kinds of entries?
      - id: user_id
        type: u4
        doc: Target user's ID
      - id: unknown_a
        size: 99
        doc: Just $00 and $FF
      - id: unknown_b
        size: 2
      - id: unknown_c
        size: 1
        doc: Increments as time passes since friend request was made.
      - id: unknown_d
        size: 2
  s0104_friend_request_response:
    seq:
      - id: unknown_e
        size: 4
      - id: friend_request
        type: s0102_entry
  s0115_unk:
    doc: Sent after Client 0x0014 Hello (1/2).
    seq:
      - id: user_id
        type: u4
        doc: Local user's ID
      - id: unknown_f
        size: 11
      - id: server_id
        type: u4
        doc: Current server's ID
      - id: unknown_g
        size: 1
      - id: unknown_h
        size: 64
        doc: Might be padding.
  s0117_user_id_lookup_response:
    doc: Appears in response to Client 0x0017 User ID Lookup.
    seq:
      - id: unknown_i
        size: 4
      - id: user_nickname
        type: pstring
        doc: Target user's nickname
      - id: user_id
        type: u4
        doc: Target user's ID

enums:
  subtype:
    0x0102: unconf_pending_friend_requests
    0x0104: friend_request_response
    0x0115: unknown_0115
    0x0117: user_id_lookup_response
