meta:
  id: f12le
  title: numpy f12 (based on IEEE 754, effectively f10)
  xref:
    iso: 60559:2011
    wikidata: Q5421900
  license: Unlicense
  imports:
    - ./f10le
  endian: be
doc: see the doc for `ieee754_float`.
seq:
  - id: f10
    type: f10le
  - id: garbage
    type: u2
