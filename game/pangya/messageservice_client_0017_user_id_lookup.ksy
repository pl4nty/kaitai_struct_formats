# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/client/0017.ksy
meta:
  id: messageservice_client_0017_user_id_lookup
  title: MessageService Client User ID Lookup Packet
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client to request user details that would
  permit the client to send messages or friend requests to said user.
  
  Response is Server 0x0030, subtype 0x0117.
  
  **See Also**: [MessageService Server 0x0030 Status
  Packet](/packets/messageservice/server/0030.ksy)

seq:
  - id: user_nickname
    type: pstring
    doc: Target user's nickname
