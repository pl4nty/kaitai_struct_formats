# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/index.ksy
meta:
  id: pangya_packet
  title: PangYa Packet
  license: ISC
  imports:
    - loginservice_packet
    - gameservice_packet
    - messageservice_packet
    - packet_origin
    - packet_version
  endian: le

doc: This is the root definition of all PangYa packets.

params:
  - id: type
    type: u1
    enum: service
  - id: origin
    type: u1
    enum: packet_origin::origin
  - id: version
    type: u1
    enum: packet_version::version

seq:
  - id: packet
    type:
      switch-on: type
      cases:
        service::loginservice: loginservice_packet(origin, version)
        service::gameservice: gameservice_packet(origin, version)
        service::messageservice: messageservice_packet(origin, version)

enums:
  service:
    0: loginservice
    1: gameservice
    2: messageservice
