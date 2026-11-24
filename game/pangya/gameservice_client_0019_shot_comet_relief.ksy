# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0019.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_0019_shot_comet_relief
  title: GameService Client Shot Comet Relief
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet submits the new location the user has selected for
  relocating/relieving their comet.
  
  The response is [Gameservice Server 0x0060 Shot Comet Relief
  Announce](/packets/gameservice/server/0060.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_MOVE_AZTEC`
  * `eantoniobr/UGPangya`: `PLAYER_DROP_BALL`

seq:
  - id: unknown_axis_position_a
    type: f4
  - id: unknown_axis_position_b
    type: f4
  - id: unknown_axis_position_c
    type: f4
