# Imported from https://github.com/SMSG-decomp/SMSG-decomp/blob/0f0a4cd524e98e9588af819113d756643a8bb25b/docs/highscores.ksy
meta:
  id: simgolf_highscores
  title: High Score Table
  application: Sid Meier's SimGolf
  file-extension: sve
  license: CC0-1.0
  endian: le
doc: |
  The ten best results, kept in `top10.sve` in the game's directory.
  golf.exe reads the whole file as one block of ten records
  (`LoadOrGenerateHighScores`, SpriteAssets.cpp); when the file is missing it
  makes up ten entries instead.

seq:
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: 10
    doc: Best first.

types:
  entry:
    doc: One `HighScore` record (MainLoop.h), 0x9c bytes.
    seq:
      - id: name
        size: 0x40
        type: strz
        encoding: windows-1252
        doc: The player's name.
      - id: course
        size: 0x40
        type: strz
        encoding: windows-1252
        doc: The course's name.
      - id: fun
        type: s4
        doc: The course's fun rating.
      - id: skill
        type: s4
        doc: The course's skill rating.
      - id: cash
        type: s4
        doc: Club cash in units of $100; multiply by 100 for dollars.
      - id: unused
        size: 0xa
      - id: level
        type: s2
        doc: |
          Difficulty index; the ranking score is
          (cash / 10 + skill + fun) * (level + 1), using integer division.
      - id: course_id
        type: s4
        doc: The course's identifier; the table keeps one entry per course.
