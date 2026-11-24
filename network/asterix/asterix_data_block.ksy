meta:
  id: asterix_data_block
  file-extension: ast
  license: GPL-3.0-only
  ks-version: 0.9
  imports:
    - asterix_record

  endian: be

doc: |
  Implementantion of ASTERIX format.

  From Eurocontrol Asterix web page at

  Asterix Data Block, consisting in a Category and lengh, and a list of sequential
  records as defined by Asterix.

doc-ref: |
  https://www.eurocontrol.int/publication/eurocontrol-specification-surveillance-data-exchange-part-i


seq:
  - id: cat
    type: u1
  - id: len
    type: u2
  - id: data_records
    size: len - 3
    type: asterix_record(cat)


instances:
  records:
    value: data_records.records.as<asterix_record[]>
