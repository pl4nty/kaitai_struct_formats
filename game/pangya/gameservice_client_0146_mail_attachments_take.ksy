# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0146.ksy
meta:
  id: gameservice_client_0146_mail_attachments_take
  title: GameService Client Mail Attachments Take
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests the attachments of a piece of mail be moved to the user's
  inventory.
  
  The response are:
  * [Gameservice Server 0x0216 User Status
    Update](/packets/gameservice/server/0216.ksy) (for the items), and
  * [Gameservice Server 0x0214 Mail Attachments Take
    Response](/packets/gameservice/server/0214.ksy) (for acknowledgement).
  
  Client will then send [Gameservice Client 0x0143 Mailbox
  Response](/packets/gameservice/client/0143.ksy) to refresh.
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_MOVE_INBOX_GIFT`

seq:
  - id: mail_id
    type: u4
    doc: |
      From [Gameservice Server 0x0211 Mailbox
      Response](/packets/gameservice/server/0211.ksy).
