# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/client/0014.ksy
# Licence and copyright: see _community/README.md
meta:
  id: messageservice_client_0014_hello
  title: MessageService Client Hello Packet
  license: ISC
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client after declarating the user's
  credentials in
  [MessageService Client 0x0012 Credential Declaration
  Response](/packets/messageservice/client/0012.ksy)
  and connected Game Server in
  [MessageService Client 0x0023 Server
  Declaration](/packets/messageservice/client/0023.ksy).
  
  This packet has no payload.
