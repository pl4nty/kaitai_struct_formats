# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0029.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_0029_room_invite_send
  title: GameService Client Room Invite Send
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is an invitation to another player to join a particular gameroom.
  
  It is sent in tandem with [GameService Client 0x00BA Room Invite
  Send](/packets/gameservice/client/00ba.ksy).
  
  The response is [GameService Server 0x0130 Room Invite Send
  Response](/packets/gameservice/server/0130.ksy).

seq:
  - id: user_id_invitee
    type: u4
