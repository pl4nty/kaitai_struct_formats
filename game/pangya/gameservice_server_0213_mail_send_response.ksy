# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0213.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/server 0213
#pragma.parseAs GameserviceServerPacket
meta:
  id: gameservice_server_0213_mail_send_response
  title: GameService Server Mail Send Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges mail being sent by the client.
  
  This is a response to [GameService Client 0x0145 Mail
  Send](/packets/gameservice/client/0145.ksy).

seq:
  - id: unknown_status
    type: u4
    doc: |
      Possibly an status or error code. Only example shows 0, presumably success.
      (0x00000000)
