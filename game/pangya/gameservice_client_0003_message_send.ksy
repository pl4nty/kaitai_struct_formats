# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0003.ksy
meta:
  id: gameservice_client_0003_message_send
  title: GameService Client Message Send
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet sends a message to be displayed through the public chat area of the
  lobby or a game room.
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_MESSAGE`
  * `eantoniobr/UGPangya`: `PLAYER_CHAT`

seq:
  - id: padding_a
    size: 4
    doc: Likely padding.
  - id: user_nickname
    type: pstring
    doc: Local user's nickname
  - id: chat_message
    type: pstring
    doc: |
      Message to send. $13 = apostrophes. Censoring is done client-side with $A8
      (PangyaTH).
