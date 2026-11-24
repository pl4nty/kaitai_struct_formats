# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0065.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_0065_time_booster_activate
  title: GameService Client Time Booster Activate
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet activates a time booster / fast forward.
  
  The response is:
  * [GameService Server 0x00C7 Time Booster
    Announce](/packets/gameservice/server/00c7.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_FAST_FORWARD`
  * `eantoniobr/UGPangya`: `PLAYER_USE_TIMEBOOSTER`

seq:
  - id: item_id
    type: u4
    doc: From pangya_xx.iff/Item.iff. Item ID for the Time Booster used.
