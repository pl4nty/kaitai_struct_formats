meta:
  id: asterix_cat_020_catalog
  title: ASTERIX category 020 data item catalog
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

  Category 020 Catalog definition file

  ASTERIX Part 14 Category 20 Multilateration Target Reports
  EUROCONTROL-SPEC-0149-14

  Edition Number: 1.9

doc-ref: |
  https://www.eurocontrol.int/publication/cat020-eurocontrol-specification-surveillance-data-exchange-asterix-part-14-category-20

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
        41:      asterix_fixed("I041",true,8)
        42:      asterix_fixed("I042",true,6)
        50:      asterix_fixed("I050",true,2)
        55:      asterix_fixed("I055",true,1)
        70:      asterix_fixed("I070",true,2)
        90:      asterix_fixed("I090",true,2)
        100:      asterix_fixed("I100",true,4)
        105:      asterix_fixed("I105",true,2)
        110:      asterix_fixed("I110",true,2)
        140:      asterix_fixed("I140",true,3)
        161:      asterix_fixed("I161",true,2)
        170:   asterix_extended("I170",true,1,1)
        202:      asterix_fixed("I202",true,2)
        210:      asterix_fixed("I210",true,2)
        220:      asterix_fixed("I220",true,3)
        230:      asterix_fixed("I230",true,2)
        245:      asterix_fixed("I245",true,7)
        250: asterix_repetitive("I250",true,8)
        260:      asterix_fixed("I260",true,7)
        300:      asterix_fixed("I300",true,1)
        310:      asterix_fixed("I310",true,1)
        400: asterix_repetitive("I400",true,1)
        500:   asterix_compound("I500","FFF",[6,6,2],[0,0,0])
