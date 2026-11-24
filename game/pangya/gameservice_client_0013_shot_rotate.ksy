# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0013.ksy
meta:
  id: gameservice_client_0013_shot_rotate
  title: GameService Client Shot Rotate/Aim
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet relays how the user has rotated/adjusted the aim of their shot, so
  it can be relayed to all other
  players in the room.
  
  The response is [GameService Server 0x0056 Shot Rotate
  Announce](/packets/gameservice/server/0056.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_ACTION_ROTATE`
  * `eantoniobr/UGPangya`: `PLAYER_GAME_ROTATE`

seq:
  - id: rotation_angle
    type: f4
    doc: Increments counterclockwise.
