# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/server/0045.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_server_0045_user_statistics
  title: GameService Server User Statistics
  license: ISC
  imports:
    - id_bank
    - pstring
    - user_course_record_data
    - user_statistic_data
    - user_statistic_data_ext
  encoding: ASCII
  endian: le

doc: |
  This packet contains statistics for the current user, which are relayed before
  and after every match.
  
  This is a response to:
  * [GameService Client 0x0006 Match Statistics
    Submit](/packets/gameservice/client/0006.ksy),
  * GameService Client 0x000E Game Start,
  * [GameService Client 0x00AA Match Statistics Submit (Tiki
    Report)](/packets/gameservice/client/00aa.ksy),
  * and possibly others.

seq:
  - id: user_statistics
    type: user_statistic_data
    doc: More details can be found in type definition file.
  - id: user_statistics_ext
    type: user_statistic_data_ext
    doc: More details can be found in type definition file.
  - id: course_stat_slots
    type: course_stat_slot
    repeat: expr
    repeat-expr: 12
    doc: 12 extra data slots. Typically used in response to GSC-0006 only.

types:
  course_stat_slot:
    seq:
      - id: course_id
        type: s1
        enum: id_bank::course_id
        doc: |
          From pangya_xx.iff/Course.iff. Course for match just played. 0xFF (-1) if
          empty/unused.
      - id: user_course_record_data
        type: user_course_record_data
        if: course_id != id_bank::course_id::empty
        doc: Present only if `course_id` is not 0xFF (-1).
