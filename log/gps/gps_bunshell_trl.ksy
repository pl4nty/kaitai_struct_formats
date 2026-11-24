meta:
  id: gps_bunshell_trl
  title: Bunshell GPS Trail
  application: Bunshell receivers
  file-extension: trl
  license: GPL-2.0-or-later
  endian: le

doc: File format used in Bunshell GPS receivers

doc-ref:
  - https://www.gpsbabel.org/htmldoc-development/fmt_bushnell_trl.html
  - https://github.com/gpsbabel/gpsbabel/blob/master/bushnell_trl.cc

seq:
  - id: name
    size: 20
    type: strz
    encoding: ASCII
    doc: Track name, NUL-padded.
  - id: points
    type: point
    repeat: expr
    repeat-expr: num_points
  - id: trailer
    size-eos: true
    doc: |
      The rest of the 4502 point slots (all zero), a 4-byte zero end
      marker, `num_points` (u2), and a byte that gpsbabel always writes
      as 1.
instances:
  num_points:
    pos: _io.size - 3
    type: u2
types:
  point:
    seq:
      - id: lat
        type: fp
      - id: lon
        type: fp
    types:
      fp:
        seq:
          - id: raw
            type: s4
        instances:
          value:
            value: raw / 10000000.
