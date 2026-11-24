meta:
  id: asterix_cat_002_catalog
  title: ASTERIX category 002 data item catalog
  license: GPL-3.0-only
  ks-version: 0.9
  imports:
#    - bit_map
    - asterix_fixed
    - asterix_explicit
    - asterix_extended
    - asterix_repetitive
    - asterix_compound
  endian: be

doc: |
  Implementation of ASTERIX format.

  From Eurocontrol Asterix web page at
  https://www.eurocontrol.int/asterix

  Category 002 Catalog definition file
  Radar Data Exchange Part 2b
  Transmission of Monoradar Service Messages
  SUR.ET1.ST05.2000-STD-02b-01
  Edition : 1.0

doc-ref: |
  https://www.eurocontrol.int/publication/cat002-eurocontrol-standard-document-radar-data-exchange-part-2b

params:
  - id: item_ref_num
    type: s2

seq:
  - id: item
    type:
      switch-on: item_ref_num
      cases:
        0:        asterix_fixed("I000",true,1)
        10:       asterix_fixed("I010",true,2)
        20:       asterix_fixed("I020",true,1)
        30:       asterix_fixed("I030",true,3)
        41:       asterix_fixed("I041",true,2)
        50:    asterix_extended("I050",true,1,1)
        60:    asterix_extended("I060",true,1,1)
        70:  asterix_repetitive("I070",true,2)
        80:    asterix_extended("I080",true,1,1)
        90:       asterix_fixed("I090",true,2)
        100:      asterix_fixed("I100",true,8)
