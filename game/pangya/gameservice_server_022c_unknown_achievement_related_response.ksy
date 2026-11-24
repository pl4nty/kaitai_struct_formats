# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/022c.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 022c
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_022c_unknown_achievement_related_response
  title: GameService Server Unknown Achievement-Related Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le
    
doc: |
  This packet's purpose is currently unknown.
  
  This is one of the responses to [GameService Client 0x0157 Achievement Status
  Update](/packets/gameservice/client/0157.ksy).

seq:
  - id: unknown_a
    size: 4
    doc: Always appears to be 0.
