# Imported from https://github.com/princeminz/rtpmididroid/blob/283e523da35a520fdcc4a8f492e72adb8d326b45/app/src/main/java/com/minz/midi/rtpmidi.ksy
meta:
  id: rtp_midi
  title: rtpmidi
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: rtpmidi
seq:
  - id: sig
    contents: [0xff, 0xff]
  - id: command
    size: 2
  - id: version
    type: u4
  - id: initiatortoken
    type: u4
  - id: ssrc
    type: u4
  - id: name
    type: str
    terminator: 0
    encoding: UTF-8
