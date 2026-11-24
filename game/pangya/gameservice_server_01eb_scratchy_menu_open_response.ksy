# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/01eb.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 010b
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_01eb_scratchy_menu_open_response
  title: GameService Server Scratchy Menu Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges the player has opened the scratchy card menu.
  
  This is a response to [GameService Client 0x012A Scratchy Menu
  Open](/packets/gameservice/client/012a.ksy).

seq:
  - id: unknown_a
    size: 5
    doc: All examples show 0.
