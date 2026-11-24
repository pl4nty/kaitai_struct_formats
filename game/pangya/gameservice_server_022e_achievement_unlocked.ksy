# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/022e.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_022e_achievement_unlocked
  title: GameService Server Achievement Unlocked
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le
    
doc: |
  This packet is sent when the user earns an achievement. It is usually paired
  with [GameService Server 0x0220 Achievement
  List](/packets/gameservice/server/0220.ksy).
  
  It is part of the response to:
  * [Event - Tournament / Match End](/events/match_end.md)

seq:
  - id: achievement_count
    type: u4
  - id: achievements
    type: achievement
    repeat: expr
    repeat-expr: achievement_count

types:
  achievement:
    seq:
      - id: achievement_group_id
        type: u4
        doc: From pangya_xx.iff/Achievement.iff
      - id: achievement_id
        type: u4
