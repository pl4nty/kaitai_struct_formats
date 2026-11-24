# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/00fc.ksy

meta:
  id: gameservice_server_00fc_message_server_list
  title: GameService Server Message Server List
  license: ISC
  imports:
    - message_server
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet is a response to client request messenger list.  It lists the
  messenger servers
  along with their IP addresses.
  
  It is a response to:
  * [GameService Client 0x008b](/packets/gameservice/client/008b.ksy)

seq:
  - id: count
    type: u1
    doc: Number of servers in the response.
  - id: servers
    type: message_server
    repeat: expr
    repeat-expr: count
