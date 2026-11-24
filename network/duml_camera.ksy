# Imported from https://github.com/pschmitt/Gadgetbridge/blob/7e6cbc79ac04ce4c896b9ff4cc914c804c1061be/app/src/main/ksy/duml_camera.ksy
meta:
  id: duml_camera
  title: DUML Camera command set
  license: AGPL-3.0-only
  endian: le
  -duml-cmdset: 0x02

doc: Commands under cmdSet=CAMERA(0x02).

types:
  file_star_flag_set_request:
    meta:
      -duml-cmd: 0xbf
    seq:
      - id: num_file_ids
        type: u1
      - id: favorite
        type: u1
        doc: 1 to set the Favorite flag, 0 to clear it.
      - id: file_ids
        type: u4
        repeat: expr
        repeat-expr: num_file_ids
      - id: request_counter
        type: u4
        doc: Incremented for each favorite and delete command.
      - id: reserved
        type: u1
      - id: num_file_ids_again
        type: u4

  file_star_flag_set_response:
    meta:
      -duml-cmd: 0xbf
    seq:
      - id: status
        type: u1
