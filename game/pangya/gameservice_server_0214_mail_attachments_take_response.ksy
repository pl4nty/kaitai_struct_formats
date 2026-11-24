# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0214.ksy
meta:
  id: gameservice_server_0214_mail_attachments_take_response
  title: GameService Server Mail Attachments Take Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet acknowledges attachments have been taken from a piece of mail.
  
  It is a response to [Gameservice Client 0x0146 Mail Attachments
  Take](/packets/gameservice/client/0146.ksy).

seq:
  - id: unknown_a
    size: 4
    doc: All 0x00.
