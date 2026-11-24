# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/00c7.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 00c7
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_00c7_time_booster_announce
  title: GameService Server Time Booster Announce
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet announces the use of a time booster / fast forward.
  
  It is a response to:
  * [GameService Client 0x0065 Time Booster
    Activate](/packets/gameservice/client/0065.ksy).
  
seq:
  - id: item_id
    type: u4
    doc: From pangya_xx.iff/Item.iff. Item ID of the Time Booster used.
  - id: connection_id
    type: u4
    doc: Connection ID of the user that used the Time Booster.
