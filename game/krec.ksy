# Imported from https://github.com/smash64-dev/krec-struct-format/blob/97cdf7e05d89e724cb76ad95d4f5edfd0046195f/krec.ksy
# Licence and copyright: see _community/README.md
meta:
  id: krec
  title: Open Kaillera Recording file
  application: kailleraclient.dll
  file-extension: krec
  license: CC0-1.0
  endian: le
seq:
  - id: header
    type: header
  - id: playback
    type: playback
    repeat: eos
types:
  event_chat:
    seq:
      - id: nickname
        type: strz
        encoding: UTF-8
      - id: message
        type: strz
        encoding: UTF-8
  event_drop:
    seq:
      - id: nickname
        type: strz
        encoding: UTF-8
      - id: player_id
        type: s4le
  event_values:
    seq:
      - id: size
        type: s2
      - id: values
        size: size
        type: values(_root.header.player_count, size)
  header:
    seq:
      - id: magic
        contents: 'KRC0'
      - id: app_name
        size: 128
        type: strz
        encoding: UTF-8
      - id: game_name
        size: 128
        type: strz
        encoding: UTF-8
      - id: time
        type: s4le
      - id: player_id
        type: s4le
      - id: player_count
        type: s4le
  playback:
    seq:
      - id: type
        type: s1
        enum: event
      - id: data
        type:
          switch-on: type
          cases:
            'event::chat': event_chat
            'event::values': event_values
            'event::drop': event_drop
    enums:
      event:
        8: chat
        18: values
        20: drop
  port:
    seq:
      - id: id
        type: s1
      - id: type
        type: s1
      - id: data
        size-eos: true
  values:
    params:
      - id: count
        type: s2
      - id: size
        type: s2
    seq:
      - id: ports
        size: size / count
        type: port
        repeat: eos
