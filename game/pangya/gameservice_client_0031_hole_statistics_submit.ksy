# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/0031.ksy
meta:
  id: gameservice_client_0031_hole_statistics_submit
  title: GameService Client Hole Statistics Submit
  license: ISC
  imports:
    - pstring
    - user_course_result_data
  encoding: ASCII
  endian: le

doc: |
  This packet is sent at the end of most (all?) holes to report the user's
  statistics for that particular match up until that point.
  
  There is no response.
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_HOLE_COMPLETE`
  * `eantoniobr/UGPangya`: `PLAYER_HOLE_COMPLETE`
  
  **See Also:**
  * [GameService Client 0x0006 Match Statistics
    Submit](/packets/gameservice/client/0006.ksy).
  * [GameService Client 0x00AA Match Statistics Submit (Tiki
    Report)](/packets/gameservice/client/00aa.ksy).

seq:
  - id: user_course_result_data
    type: user_course_result_data
    doc: |
      More details can be found in type definition file. Data is cumulative of match
      up until this point.
