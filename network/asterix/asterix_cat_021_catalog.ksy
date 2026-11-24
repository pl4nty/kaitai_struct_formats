meta:
  id: asterix_cat_021_catalog
  title: ASTERIX category 021 data item catalog
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

  Category 021 Catalog definition file

  ASTERIX Part 12 Category 21 ADS-B Target Reports
  NOT backwards compatible to category 021 edition 2.1 or earlier
  EUROCONTROL-SPEC-0149-12

  Edition Number: 2.4

doc-ref: |
  https://www.eurocontrol.int/publication/cat021-eurocontrol-specification-surveillance-data-exchange-asterix-part-12-category-21

params:
  - id: item_ref_num
    type: s2

seq:
  - id: item
    type:
      switch-on: item_ref_num
      cases:
        8:      asterix_fixed("I008",true,1)
        10:      asterix_fixed("I010",true,2)
        15:      asterix_fixed("I015",true,1)
        16:      asterix_fixed("I016",true,1)
        20:      asterix_fixed("I020",true,1)
        40:   asterix_extended("I040",true,1,1)
        70:      asterix_fixed("I070",true,2)
        71:      asterix_fixed("I071",true,3)
        72:      asterix_fixed("I072",true,3)
        73:      asterix_fixed("I073",true,3)
        74:      asterix_fixed("I074",true,4)
        75:      asterix_fixed("I075",true,3)
        76:      asterix_fixed("I076",true,4)
        77:      asterix_fixed("I077",true,3)
        80:      asterix_fixed("I080",true,3)
        90:   asterix_extended("I090",true,1,1)
        110:   asterix_compound("I110","ERZZ"+"ZZZ",[1,15,0,0,0,0,0],[1,0,0,0,0,0,0])
        130:      asterix_fixed("I130",true,6)
        131:      asterix_fixed("I131",true,8)
        132:      asterix_fixed("I132",true,1)
        140:      asterix_fixed("I140",true,2)
        145:      asterix_fixed("I145",true,2)
        146:      asterix_fixed("I146",true,2)
        148:      asterix_fixed("I148",true,2)
        150:      asterix_fixed("I150",true,2)
        151:      asterix_fixed("I151",true,2)
        152:      asterix_fixed("I152",true,2)
        155:      asterix_fixed("I155",true,2)
        157:      asterix_fixed("I157",true,2)
        160:      asterix_fixed("I160",true,4)
        161:      asterix_fixed("I161",true,2)
        165:      asterix_fixed("I165",true,2)
        170:      asterix_fixed("I170",true,6)
        200:      asterix_fixed("I200",true,1)
        210:      asterix_fixed("I210",true,1)
        220:   asterix_compound("I220","FFFF"+"ZZZ",[2,2,2,1,0,0,0],[0,0,0,0,0,0,0])
        230:      asterix_fixed("I230",true,2)
        250: asterix_repetitive("I250",true,8)
        260:      asterix_fixed("I260",true,7)
        271:   asterix_extended("I271",true,1,1)
        295:   asterix_compound("I295","FFFF"+"FFF"+"FFFF"+"FFF"+"FFFF"+"FFF"+"FF",[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        400:      asterix_fixed("I400",true,1)
