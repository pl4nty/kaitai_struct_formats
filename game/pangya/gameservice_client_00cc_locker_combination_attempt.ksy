# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/00cc.ksy
meta:
  id: gameservice_client_00cc_locker_combination_attempt
  title: GameService Client Locker Combination Attempt
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet contains a locker combination attempt.
  
  The response is [Gameservice Server 0x016C Locker Combination
  Response](/packets/gameservice/server/016c.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_REQUEST_LOCKER_ACCESS`
  * `eantoniobr/UGPangya`: `PLAYER_OPEN_LOCKER`

seq:
  - id: locker_combination
    type: pstring
    doc: e.g. "1234".
