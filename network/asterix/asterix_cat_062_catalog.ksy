meta:
  id: asterix_cat_062_catalog
  title: ASTERIX category 062 data item catalog
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

  Category 062 Catalog definition file

  ASTERIX Part 9 Category 062 SDPS Track Messages
  EUROCONTROL-SPEC-0149-9

  Edition Number : 1.18

doc-ref: |
  https://www.eurocontrol.int/publication/cat062-eurocontrol-specification-surveillance-data-exchange-asterix-part-9-category-062


params:
  - id: item_ref_num
    type: s2

seq:
  - id: item
    type:
      switch-on: item_ref_num
      cases:
        10:     asterix_fixed("I010",true,2)
        15:     asterix_fixed("I015",true,1)
        40:     asterix_fixed("I040",true,2)
        60:     asterix_fixed("I060",true,2)
        70:     asterix_fixed("I070",true,3)
        80:  asterix_extended("I080",true,1,1)
        100:     asterix_fixed("I100",true,6)
        105:     asterix_fixed("I105",true,8)
        110:  asterix_compound("I110","FFFFFFF",[1,4,6,2,2,1,1],[0,0,0,0,0,0,0])
        120:     asterix_fixed("I120",true,2)
        130:     asterix_fixed("I130",true,2)
        135:     asterix_fixed("I135",true,2)
        136:     asterix_fixed("I136",true,2)
        185:     asterix_fixed("I185",true,4)
        200:     asterix_fixed("I200",true,1)
        210:     asterix_fixed("I210",true,2)
        220:     asterix_fixed("I220",true,2)
        245:     asterix_fixed("I245",true,7)
        270:  asterix_extended("I270",true,1,1)
        290:  asterix_compound("I290","FFFFFFF"+"FFF",[1,1,1,1,2,1,1,1,1,1],[0,0,0,0,0,0,0,0,0,0])
        295:  asterix_compound("I295","FFFFFFF"+"FFFFFFF"+"FFFFFFF"+"FFFFFFF"+"FFF",[1,1,1,1,1,1,1,  1, 1,1,1,1,1,1,  1,1,1,1,1,1,1,  1,1,1,1,1,1,1,  1,1,1],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        300:     asterix_fixed("I300",true,1)
        340:  asterix_compound("I340","FFFFFF",[2,4,2,2,2,1],[0,0,0,0,0,0])
        380:  asterix_compound("I380","FFFFFFF"+"FRFFFFF"+"FFFFFFF"+"FFFRFFF",      [3,6,2,2,2,2,2,  1,15,2,2,7,2,2,  2,2,2,2,1,8,1,  6,2,1,8,2,2,2],        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
        390:  asterix_compound("I390","FFFFFFF"+"FFFFRFF"+"FFFF", [2,7,4,1,4,1,4,  4,3,2,2,4,6,1,  7,7,2,7],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,])
        500:  asterix_compound("I500","FFFFFFF"+"F",[4,2,4,1,1,2,2,  1],[0,0,0,0,0,0,0,0])
        510:  asterix_extended("I510",true,3,3)






instances:
  category:
    value: '"062"'

  version:
    value: '"1.00"'
