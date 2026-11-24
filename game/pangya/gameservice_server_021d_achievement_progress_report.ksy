# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/021d.ksy
meta:
  id: gameservice_server_021d_achievement_progress_report
  title: GameService Server Achievement Progress Report
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet reports a list of all achievement progress.
  
  **Important**: This packet is segmented into 300-entry lists. When more than
  300 entries exist, multiple of this packet will be sent consecutively. The
  'pending' integer in each is the total count of entries in the current packet
  plus all future packets in the series.
  
  This packet is sent during the response to [GameService Client 0x0002
  Hello](/packets/gameservice/client/0002.ksy).

seq:
  - id: unknown_a
    size: 4
  - id: achievements_pending
    type: u4
  - id: achievement_count
    type: u4
  - id: achievements
    type: achievement
    repeat: expr
    repeat-expr: achievement_count

types:
  achievement:
    seq:
      - id: unknown_b
        type: u1
      - id: achievement_status_id
        type: u4
      - id: achievement_status_slot
        type: u4
      - id: achievement_value
        type: u4
        doc: Progress value. Treated like a 'quantity', to be added and subtracted as needed.
