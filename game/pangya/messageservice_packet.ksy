# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/index.ksy
# Licence and copyright: see _community/README.md
meta:
  id: messageservice_packet
  title: MessageService Packets
  license: ISC
  imports:
    - packet_origin
    - packet_version
    - messageservice_client_packet
    - messageservice_server_packet
  encoding: ASCII
  endian: le

params:
  - id: origin
    type: u1
    enum: packet_origin::origin
  - id: version
    type: u1
    enum: packet_version::version

seq:
  - id: message_packet
    type:
      switch-on: origin
      cases:
        packet_origin::origin::client: messageservice_client_packet(version)
        packet_origin::origin::server: messageservice_server_packet(version)
