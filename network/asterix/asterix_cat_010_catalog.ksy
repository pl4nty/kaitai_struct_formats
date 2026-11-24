meta:
  id: asterix_cat_010_catalog
  title: ASTERIX category 010 data item catalog
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

  Category 010 Catalog definition file

  Part 7 : Category 010
  Transmission of Monosensor Surface Movement Data

  SUR.ET1.ST05.2000-STD-07-01
  Edition : 1.1

doc-ref: |
  https://www.eurocontrol.int/publication/cat010-eurocontrol-specification-surveillance-data-exchange-part-7-category-010


params:
  - id: item_ref_num
    type: s2

seq:
  - id: item
    type:
      switch-on: item_ref_num
      cases:
        0:      asterix_fixed("I000",true,1)
        10:      asterix_fixed("I010",true,2)
        20:   asterix_extended("I020",true,1,1)
        40:      asterix_fixed("I040",true,4)
        41:      asterix_fixed("I041",true,8)
        42:      asterix_fixed("I042",true,4)
        60:      asterix_fixed("I060",true,2)
        90:      asterix_fixed("I090",true,2)
        91:      asterix_fixed("I091",true,2)
        131:      asterix_fixed("I131",true,1)
        140:      asterix_fixed("I140",true,3)
        161:      asterix_fixed("I161",true,2)
        170:   asterix_extended("I170",true,1,1)
        200:      asterix_fixed("I200",true,4)
        202:      asterix_fixed("I202",true,4)
        210:      asterix_fixed("I210",true,2)
        220:      asterix_fixed("I220",true,3)
        245:      asterix_fixed("I245",true,7)
        250: asterix_repetitive("I250",true,8)
        270:   asterix_extended("I270",true,1,1)
        280: asterix_repetitive("I280",true,2)
        300:      asterix_fixed("I300",true,1)
        310:      asterix_fixed("I310",true,1)
        500:      asterix_fixed("I500",true,4)
        550:      asterix_fixed("I550",true,1)


instances:
  category:
    value: '"010"'

  version:
    value: '"1.10"'
