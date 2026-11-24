# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/client/0016.ksy
# Licence and copyright: see _community/README.md
meta:
  id: messageservice_client_0016_goodbye
  title: MessageService Client Goodbye Packet
  license: ISC
  encoding: ASCII
  endian: le

doc: |
  This packet is sent by the PangYa client in order to disconnect from the
  Messaging Server. There is no response, and no traffic follows.
  
  This packet has no payload.
