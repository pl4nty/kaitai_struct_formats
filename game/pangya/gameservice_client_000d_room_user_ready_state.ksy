# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/000d.ksy
meta:
  id: gameservice_client_000d_room_user_ready_state
  title: GameService Client Room User Ready State
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet announces the user's ready state in a game room after clicking the
  'Ready' button.
  
  The response is [Gameservice Server 0x0078 Room User Ready State
  Response](/packets/gameservice/server/0078.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_READY`
  * `eantoniobr/UGPangya`: `PLAYER_PRESS_READY`

seq:
  - id: user_readiness
    type: u1
    enum: user_readiness
    doc: Unconfirmed.

enums:
  user_readiness:
    0x00: ready
    0x01: not_ready_unconfirmed
