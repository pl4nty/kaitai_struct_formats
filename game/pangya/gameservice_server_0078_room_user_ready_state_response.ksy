# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0078.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 0078
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_0078_room_user_ready_state_response
  title: GameService Server Room User Ready State Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This relays each user's ready state.
  
  This packet is a response to [Gameservice Client 0x000D Room User Ready
  State](/packets/gameservice/client/000d.ksy).

seq:
  - id: connection_id
    type: u4
    doc: |
      As per [Gameservice Server 0x0046 User
      Census](/packets/gameservice/server/0046.ksy).
  - id: user_readiness
    type: u1
    enum: user_readiness
    doc: |
      As per [Gameservice Client 0x000D User Ready
      State](/packets/gameservice/client/000d.ksy).

enums:
  user_readiness:
    0x00: ready
    0x01: not_ready_unconfirmed
