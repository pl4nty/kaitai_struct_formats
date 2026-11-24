# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/01d4.ksy
meta:
  id: gameservice_server_01d4_new_session_key
  title: GameService Server New Session Key
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains a new session key on the new server during a
  server switch.
  
  This packet is a response to [GameService Client 0x0119 Switch
  Server](/packets/gameservice/client/0119.ksy).

seq:
  - id: unknown_a
    size: 4
  - id: session_key
    type: pstring
    doc: Session Key for the destination server.
