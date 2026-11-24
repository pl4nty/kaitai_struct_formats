meta:
  id: asterix_cat_001_catalog
  title: Eurocontrol Asterix Category 001 CAT001 data items catalog. Edition 1.0
  license: GPL-3.0-only
  ks-version: 0.9
  imports:
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

  Category 001 Catalog definition file
  RADAR DATA EXCHANGE Part 2a
  Transmission of Monoradar Data Target Reports

  SUR.ET1.ST05.2000-STD-02a-01

  Edition : 1.2

doc-ref: |
  https://www.eurocontrol.int/publication/cat001-eurocontrol-standard-document-radar-data-exchange-part-2a

params:
  - id: item_ref_num
    type: s2

seq:
  - id: item
    type:
      switch-on: item_ref_num
      cases:
        10:      asterix_fixed("I010",true,2)
        20:   asterix_extended("I020",true,1,1)
        30:   asterix_extended("I030",true,1,1)
        40:      asterix_fixed("I040",true,4)
        42:      asterix_fixed("I042",true,4)
        50:      asterix_fixed("I050",true,2)
        60:      asterix_fixed("I060",true,2)
        70:      asterix_fixed("I070",true,2)
        80:      asterix_fixed("I080",true,2)
        90:      asterix_fixed("I090",true,2)
        100:     asterix_fixed("I100",true,4)
        120:     asterix_fixed("I120",true,1)
        130:  asterix_extended("I130",true,1,1)
        131:     asterix_fixed("I131",true,1)
        141:     asterix_fixed("I141",true,2)
        150:     asterix_fixed("I150",true,1)
        161:     asterix_fixed("I161",true,2)
        170:  asterix_extended("I170",true,1,1)
        200:     asterix_fixed("I200",true,4)
        210:  asterix_extended("I210",true,1,1)
