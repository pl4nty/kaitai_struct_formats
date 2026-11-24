# Imported from https://github.com/pschmitt/Gadgetbridge/blob/7e6cbc79ac04ce4c896b9ff4cc914c804c1061be/app/src/main/ksy/duml_general.ksy
# Licence and copyright: see _community/README.md
meta:
  id: duml_general
  title: DUML General command set
  license: AGPL-3.0-only
  endian: le
  -duml-cmdset: 0x00

doc: Commands under cmdSet=GENERAL(0x00).

types:
  file_list_request:
    doc: Requests one page of the file list.
    seq:
      - id: magic
        type: u1
        doc: Always 0x4a.
      - id: msg_type
        type: u1
        doc: 0x00 for a list request.
      - id: length_flags
        type: u2
        doc: Bits 0-11 are the payload length. Bits 12-15 are 1.
      - id: transfer_id
        type: u2
      - id: fragment_index
        type: u4
      - id: cursor
        type: u4
        doc: 1 for the newest file, or the File Id of the last record of the previous Page.
      - id: max_records
        type: u2
      - id: unknown1
        type: u2
        doc: Meaning unknown. The app sends 0x010d.
      - id: favorites_only
        type: u1
      - id: video_filter
        type: u4
        doc: 0xffffffff for no filter, 0x80000000 to include videos, 0 to exclude them.
      - id: photo_filter
        type: u4
        doc: 0xffffffff for no filter, 0x80000000 to include photos, 0 to exclude them.
      - id: unknown2
        type: u2
        doc: Meaning unknown. The app sends 0x0100.
      - id: reserved
        size: 13

  file_transfer_ack:
    doc: The 0x26 payload that confirms the end of a transfer.
    seq:
      - id: magic
        type: u1
        doc: Always 0x4a.
      - id: msg_type
        type: u1
        doc: 0x04 for a transfer ack.
      - id: length_flags
        type: u2
        doc: Bits 0-11 are the payload length. Bits 12-15 are 1.
      - id: transfer_id
        type: u2
      - id: fragment_index
        type: u4
      - id: status
        type: u4
        doc: The app sends 1.

  file_transfer_response:
    meta:
      -duml-cmd: 0x26
    seq:
      - id: status
        type: u1

  file_transfer_data_request:
    meta:
      -duml-cmd: 0x27
    doc: One message of a file list transfer from the camera.
    seq:
      - id: magic
        type: u1
        doc: Always 0x4a.
      - id: msg_type
        type: u1
        doc: 0x01 for a data fragment, 0x03 for the end of the transfer.
      - id: length_flags
        type: u2
      - id: transfer_id
        type: u2
      - id: fragment_index
        type: u4
      - id: data
        size-eos: true

  file_transfer_delete_request:
    meta:
      -duml-cmd: 0x28
    seq:
      - id: num_file_ids
        type: u1
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

  file_transfer_delete_response:
    meta:
      -duml-cmd: 0x28
    seq:
      - id: status
        type: u1
