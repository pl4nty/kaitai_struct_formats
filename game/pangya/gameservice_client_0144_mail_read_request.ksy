# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0144.ksy
# Licence and copyright: see _community/README.md
#pragma.examples gameservice/client 0144
#pragma.parseAs GameserviceClientPacket
meta:
  id: gameservice_client_0144_mail_read_request
  title: GameService Client Mail Read Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests the contents of a piece of mail.
  
  The response is [Gameservice Server 0x0212 Mail Read
  Response](/packets/gameservice/server/0212.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_REQUEST_INBOX_DETAILS`
  * `eantoniobr/UGPangya`: `PLAYER_READ_MAIL`

seq:
  - id: mail_id
    type: u4
    doc: |
      From [Gameservice Server 0x0211 Mailbox
      Response](/packets/gameservice/server/0211.ksy).
