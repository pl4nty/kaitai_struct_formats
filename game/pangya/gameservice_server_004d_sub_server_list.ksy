# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/004d.ksy
meta:
  id: gameservice_server_004d_sub_server_list
  title: GameService Server Sub-Server List
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet lists all sub-servers on the connected server
  ("Free#1", "Rookie", etc.)
  
  This packet is sent during the response to [GameService Client 0x0002
  Hello](/packets/gameservice/client/0002.ksy).

seq:
  - id: sub_server_count
    type: u1
  - id: sub_server_list
    type: sub_server
    repeat: expr
    repeat-expr: sub_server_count

types:
  sub_server:
    seq:
      - id: sub_server_name
        size: 21
        type: strz
      - id: unknown_a
        size: 47
      - id: sub_server_id
        type: u1
      - id: unknown_b
        size: 8

      
