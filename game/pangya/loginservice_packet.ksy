# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/loginservice/index.ksy
meta:
  id: loginservice_packet
  title: LoginService Packets
  license: ISC
  imports:
    - packet_origin
    - packet_version
    - loginservice_client_packet
    - loginservice_server_packet
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
  - id: login_packet
    type:
      switch-on: origin
      cases:
        packet_origin::origin::client: loginservice_client_packet(version)
        packet_origin::origin::server: loginservice_server_packet(version)
