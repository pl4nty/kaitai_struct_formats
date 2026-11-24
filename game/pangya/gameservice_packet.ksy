# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/index.ksy
# Licence and copyright: see _community/README.md
#pragma.template service
meta:
  id: gameservice_packet
  title: GameService Packets
  license: ISC
  imports:
    - packet_origin
    - packet_version
    - gameservice_client_packet
    - gameservice_server_packet
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
  - id: game_packet
    type:
      switch-on: origin
      cases:
        packet_origin::origin::client: gameservice_client_packet(version)
        packet_origin::origin::server: gameservice_server_packet(version)
