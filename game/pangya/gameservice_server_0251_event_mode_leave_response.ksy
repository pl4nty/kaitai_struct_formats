# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0251.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0251_event_mode_leave_response
  title: GameService Server Event Mode Leave Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges a user has left Grand Prix event mode.
  
  It is a response to [GameService Client 0x0177 Event Mode
  Leave](/packets/gameservice/client/0177.ksy).

seq:
  - id: unknown_a
    type: u4
    doc: All examples show 0 (0x00000000).
