# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/server/index.ksy
# Licence and copyright: see _community/README.md
#pragma.template metapacket
meta:
  id: messageservice_server_packet
  title: MessageService Server Packets
  license: ISC
  imports:
    - packet_version
    - messageservice_server_002f_credential_declaration_response
    - messageservice_server_0030_status_packet
  encoding: ASCII
  endian: le

params:
  - id: version
    type: u1
    enum: packet_version::version

seq:
  - id: packet_id
    type: u2
  - id: data
    type:
      switch-on: packet_id
      cases:
        0x002f: messageservice_server_002f_credential_declaration_response
        0x0030: messageservice_server_0030_status_packet
