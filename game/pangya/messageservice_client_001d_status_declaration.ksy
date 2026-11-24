# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/client/001d.ksy
meta:
  id: messageservice_client_001d_status_declaration
  title: MessageService Client Status Declaration
  license: ISC
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client to change the activity level of
  the user.
  
  'Idle' is sent by the client after 3 minutes of inactivity.
  
  There is no response.

seq:
  - id: user_status
    type: u1
    enum: user_status
    doc: Local user's status

enums:
  user_status:
    0x00: is_playing
    0x01: is_idle
    0x04: is_online
