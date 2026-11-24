# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/messageservice/client/index.ksy
# Licence and copyright: see _community/README.md
#pragma.template metapacket
meta:
  id: messageservice_client_packet
  title: MessageService Client Packets
  license: ISC
  imports:
    - packet_version
    - messageservice_client_0012_credential_declaration
    - messageservice_client_0014_hello
    - messageservice_client_0016_goodbye
    - messageservice_client_0017_user_id_lookup
    - messageservice_client_0018_unk_friend_request
    - messageservice_client_001d_status_declaration
    - messageservice_client_001e_send_message
    - messageservice_client_0023_server_declaration
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
        0x0012: messageservice_client_0012_credential_declaration
        0x0014: messageservice_client_0014_hello
        0x0016: messageservice_client_0016_goodbye
        0x0017: messageservice_client_0017_user_id_lookup
        0x0018: messageservice_client_0018_unk_friend_request
        0x001d: messageservice_client_001d_status_declaration
        0x001e: messageservice_client_001e_send_message
        0x0023: messageservice_client_0023_server_declaration
