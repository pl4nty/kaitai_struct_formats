# Imported from https://github.com/oruponu/ZeroIchi/blob/050337694c8a127164e176d22d1aabff58a590d5/src/ZeroIchi.Core/Formats/media/mp3.ksy
# Licence and copyright: see _community/README.md
meta:
  id: mp3
  title: MP3 file with an ID3v2 tag
  file-extension: mp3
  -zeroichi-magic: 49 44 33
  license: MIT
  imports:
    - id3v2_2
    - /media/id3v2_3
    - /media/id3v2_4
seq:
  - id: tag
    size: '10 + header.size.value + (header.version_major == 4 and header.flags.flag_footer ? 10 : 0)'
    type:
      switch-on: header.version_major
      cases:
        2: id3v2_2::tag
        3: id3v2_3::tag
        4: id3v2_4::tag
  - id: audio_data
    size-eos: true
instances:
  header:
    pos: 0
    type: id3v2_4::header
