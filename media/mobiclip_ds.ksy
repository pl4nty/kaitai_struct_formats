# Imported from https://github.com/RiiConnect24/Kaitai-Files/blob/86568af7c4f29040c178ab627c68be707a829829/Kaitais/mobiclip_ds.ksy
meta:
  id: mobiclip_ds
  file-extension: mods
  license: AGPL-3.0-only
  endian: le
doc: |
  Nintendo DS Mobiclip video (.mods). A 0x30-byte header (magic `MODSN3`,
  video codec, frame count, dimensions, frame rate, audio parameters and
  the keyframe index location) is followed by an `HE` end-of-header tag
  and the frame data. `mobiclip_mods` models the header with the full
  6-byte magic.
seq:
  - id: magic
    contents: "MODS"
  - id: tag_id
    type: u2
    doc: Bytes 'N3' (0x334e); the full magic is 'MODSN3'.
  - id: tag_id_size_dword
    type: u2
    doc: Video codec, 0x000a for MobiClip.
  - id: frame_count
    type: u4
  - id: width
    type: u4
  - id: height
    type: u4
  - id: fps
    type: u4
    doc: |
      Frame rate as 8.24 fixed point; divide by 0x1000000 to get frames per
      second.
  - id: audio_codec
    type: u2
    doc: 0 = none, 1 = SX codebook, 2 = FastAudio, 3 = IMA ADPCM, 4 = PCM16.
  - id: nb_channel
    type: u2
  - id: frequency
    type: u4
  - id: biggest_frame
    type: u4
  - id: audio_offset
    type: u4
    doc: Offset of the audio data.
  - id: keyframe_index_offset
    type: u4
    doc: Offset of the keyframe index table.
  - id: keyframe_count
    type: u4
instances:
  keyframe_table:
    pos: keyframe_index_offset
    type: keyframe_table
    repeat: expr
    repeat-expr: keyframe_count
types:
  keyframe_table:
    seq:
      - id: frame_number
        type: u4
      - id: data_offset
        type: u4
