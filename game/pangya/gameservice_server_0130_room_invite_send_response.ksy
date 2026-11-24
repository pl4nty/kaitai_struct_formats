# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0130.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0130_room_invite_send_response
  title: GameService Server Room Invite Send Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges an invitation has been sent.
  
  This is the response to [GameService Client 0x0029 Room Invite
  Send](/packets/gameservice/client/0029.ksy).

seq:
  - id: user_id_invitee
    type: u4
