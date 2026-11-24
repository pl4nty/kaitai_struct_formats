# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0147.ksy
meta:
  id: gameservice_client_0147_mail_delete
  title: GameService Client Mail Delete
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests a piece of mail be deleted.
  
  The response is [Gameservice Server 0x0215 Mail Delete
  Response](/packets/gameservice/server/0215.ksy),
  which provides a new mailbox listing to display.
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_DELETE_MAIL`
  * `eantoniobr/UGPangya`: `PLAYER_DELETE_MAIL`

seq:
  - id: unknown_a
    type: u4
    doc: Always seems to be 1 (0x00000001)
  - id: mail_id
    type: u4
    doc: |
      From [Gameservice Server 0x0211 Mailbox
      Response](/packets/gameservice/server/0211.ksy).
  - id: unknown_b
    type: u4
    doc: Always seems to be 1 (0x00000001)
