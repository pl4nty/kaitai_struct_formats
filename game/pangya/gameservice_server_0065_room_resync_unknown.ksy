# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0065.ksy
meta:
  id: gameservice_server_0065_room_resync_unknown
  title: GameService Server Room Resync Unknown
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet has an unknown purpose.
  
  It is one of the responses to [GameService Client 0x001C Room
  Resync](/packets/gameservice/client/001c.ksy).

seq:
  - id: connection_id
    type: s4
    doc: |
      Only appears in battle mode. Connection ID of the winner of the hole. -1
      (0xFFFFFFFF) if tied.
