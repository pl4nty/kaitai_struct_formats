# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/client/001e.ksy
# Licence and copyright: see _community/README.md
#pragma.examples messageservice/client 001e
#pragma.parseAs MessageserviceClientPacket
meta:
  id: messageservice_client_001e_send_message
  title: MessageService Client Send Message To User
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client to send a user
  generated message to another user on the friend list
  
  There is no response.

seq:
  - id: user_id
    type: u4
    doc: Remote User's ID
  - id: message_payload
    type: pstring
    doc: Message typed by local user to be sent
