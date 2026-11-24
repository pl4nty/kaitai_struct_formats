# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/loginservice/client/index.ksy
meta:
  id: loginservice_client_packet
  title: LoginService Client Packets
  license: ISC
  imports:
    - packet_version
    - loginservice_client_0001_login
    - loginservice_client_0003_select_server
    - loginservice_client_0004_ghost
    - loginservice_client_0006_set_nickname
    - loginservice_client_0007_check_nickname
    - loginservice_client_0008_select_character
    - loginservice_client_000b_reconnect
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
        0x0001: loginservice_client_0001_login
        0x0003: loginservice_client_0003_select_server
        0x0004: loginservice_client_0004_ghost
        0x0006: loginservice_client_0006_set_nickname
        0x0007: loginservice_client_0007_check_nickname
        0x0008: loginservice_client_0008_select_character
        0x000b: loginservice_client_000b_reconnect
