# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0143.ksy
meta:
  id: gameservice_client_0143_mailbox_request
  title: GameService Client Mailbox Request
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet requests a listing of mail from a page in the user's mailbox.
  
  The response is [Gameservice Server 0x0211 Mailbox
  Response](/packets/gameservice/server/0211.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_REQUEST_INBOX`
  * `eantoniobr/UGPangya`: `PLAYER_OPEN_MAILBOX`

seq:
  - id: page_number
    type: u4
    doc: Counts from 1. Response will contain largest valid page number.
