# Imported from https://github.com/izzyreal/mpc2000xl_kaitai/blob/d08b543e1abe96b7ecca74e09173ab8d6055bef7/mpc60.all.v1.ksy
### WIP ###

# Known producers currently evidenced:
# - none

meta:
  id: akai_mpc60_all_v1
  file-extension: all
  license: LicenseRef-All-Rights-Reserved
  imports:
    - mpc60_seq_v1

seq:
  - id: file_id
    contents: [0x04]

  - id: file_format_version
    contents: [0x01]

  - id: total_number_of_bytes_in_all_sequences
    type: u4le

  - id: sequences
    type: mpc60_seq_v1::sequence
    repeat: until
    repeat-until: _io.pos - 6 >= total_number_of_bytes_in_all_sequences

  - id: songs
    type: song
    repeat: until
    # In Roger Linn's v1 song-list format, the terminating byte is the next
    # record's step-count field set to 0.
    repeat-until: _.step_count == 0

types:
  song_step:
    seq:
      - id: sequence_number
        type: u1
      - id: repetition_count
        type: u1

  song:
    seq:
      - id: step_count
        type: u1
      - id: song_number
        type: u1
      - id: end_status
        type: u1
      - id: loop_back_step_number
        type: u1
      - id: steps
        type: song_step
        repeat: expr
        repeat-expr: step_count
