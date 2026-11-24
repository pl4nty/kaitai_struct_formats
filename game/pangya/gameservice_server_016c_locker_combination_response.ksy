# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/016c.ksy
meta:
  id: gameservice_server_016c_locker_combination_response
  title: GameService Server Locker Combination Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet reports if a locker combination attempt was valid or not.
  
  This packet is a response to [GameService Client 0x00CC Locker Combination
  Attempt](/packets/gameservice/client/00cc.ksy).

seq:
  - id: result
    type: u4
    enum: results

enums:
  results:
    0x00000000: locker_combination_valid
    0x00000075: locker_combination_invalid
