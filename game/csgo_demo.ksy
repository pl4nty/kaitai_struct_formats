# Imported from https://github.com/ZetaTwo/csgo_demo_parser/blob/265212ce4a1821c8f870a8c0af835941f0d35c6f/csgodem.ksy
# Licence and copyright: see _community/README.md
meta:
  id: csgo_demo
  file-extension: dem
  license: MIT
  imports:
    - frame
  endian: le

seq:
  - id: header
    type: header
  - id: frames
    type: frame
    repeat: eos

types:
  header:
    seq:
      - id: magic
        contents: [HL2DEMO, 0]
      - id: demo_version
        type: s4
      - id: network_version
        type: s4
      - id: server_name
        size: 260
        type: strz
        encoding: ASCII
      - id: client_name
        size: 260
        type: strz
        encoding: ASCII
      - id: map_name
        size: 260
        type: strz
        encoding: ASCII
      - id: game_directory
        size: 260
        type: strz
        encoding: ASCII
      - id: playback_time
        type: f4
      - id: ticks
        type: s4
      - id: frames
        type: s4
      - id: signon_length
        type: s4
    instances:
      tickrate:
        value: ticks / playback_time
