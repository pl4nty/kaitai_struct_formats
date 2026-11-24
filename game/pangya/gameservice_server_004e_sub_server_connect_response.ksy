# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/004e.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 004e
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_004e_sub_server_connect_response
  title: GameService Server Sub-Server Connect Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges a connection to a sub-server.
  
  It is a response to:
  * [GameService Client 0x0004 Sub-Server
    Connect](/packets/gameservice/client/0004.ksy), and
  * [GameService Client 0x0083 Sub-Server Connect (Multiplayer
    Mode)](/packets/gameservice/client/0083.ksy).
  
seq:
  - id: unknown_gss004e
    type: u1
    doc: Only 0x01 witnessed.
