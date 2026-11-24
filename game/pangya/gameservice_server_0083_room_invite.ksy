# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0083.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0083_room_invite
  title: GameService Server Room Invite
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains an invitation to join a gameroom.
  
  This is one of the responses to [GameService Client 0x00BA Room Invite
  Send](/packets/gameservice/client/00ba.ksy).

seq:
  - id: unknown_a
    size: 2
  - id: server_id
    type: u4
  - id: sub_server_id
    type: u1
  - id: room_id
    type: u2
  - id: user_id_inviter
    type: u4
  - id: user_nickname_inviter
    type: pstring
  - id: user_id_invitee
    type: u4
