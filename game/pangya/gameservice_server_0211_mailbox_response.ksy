# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0211.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0211_mailbox_response
  title: GameService Server Mailbox Response
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains a page of the user's mailbox.
  
  This packet is a response to [Gameservice Client 0x0143 Mailbox
  Request](/packets/gameservice/client/0143.ksy).

seq:
  - id: unknown_d
    size: 4
  - id: page_number
    type: u4
    doc: Page number requested from the Mailbox.
  - id: page_number_max
    type: u4
    doc: Unconfirmed. Total page count in Mailbox.
  - id: mail_count
    type: u2
  - id: mails
    type: mail
    repeat: expr
    repeat-expr: mail_count

types:
  mail:
    seq:
      - id: mail_id
        type: u4
      - id: mail_sender_user_nickname
        size: 135
        type: strz
      - id: mail_attachment_count
        type: u4
      - id: mail_attachments
        type: mail_attachment
        if: mail_attachment_count != 0
  mail_attachment:
    doc: |
      At most 1 attachment will be listed in the mailbox. Identical to [GameService
      Server 0x0212 Mail Read Response](/packets/gameservice/server/0212.ksy).
    seq:
      - id: unknown_a
        size: 4
      - id: item_id
        type: u4
      - id: unknown_b
        size: 1
      - id: item_quantity
        type: u4
      - id: unknown_c
        size: 42
