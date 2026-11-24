# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/loginservice/server/index.ksy
# Licence and copyright: see _community/README.md
meta:
  id: loginservice_server_packet
  title: LoginService Server Packets
  license: ISC
  imports:
    - packet_version
    - loginservice_server_0001_login
    - loginservice_server_0002_game_server_list
    - loginservice_server_0003_session_key
    - loginservice_server_0006_chat_macro_list
    - loginservice_server_0009_message_server_list
    - loginservice_server_0010_login_key
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
        0x0001: loginservice_server_0001_login
        0x0002: loginservice_server_0002_game_server_list
        0x0003: loginservice_server_0003_session_key
        0x0006: loginservice_server_0006_chat_macro_list
        0x0009: loginservice_server_0009_message_server_list
        0x0010: loginservice_server_0010_login_key
