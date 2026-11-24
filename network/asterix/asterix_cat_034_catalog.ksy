meta:
  id: asterix_cat_034_catalog
  title: ASTERIX category 034 data item catalog
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

  Category 034 Catalog definition file

  ASTERIX Part 2b Category 34
  Transmission of Monoradar Service Messages

  SUR.ET1.ST05.2000-STD-02b-01

  Edition Number: 1.27

doc-ref: |
  https://www.eurocontrol.int/publication/cat034-eurocontrol-specification-surveillance-data-exchange-part-2b

params:
  - id: item_ref_num
    type: s2

seq:
  - id: item
    type:
      switch-on: item_ref_num
      cases:
        0:       asterix_fixed("I000",true,1)
        10:       asterix_fixed("I010",true,2)
        20:       asterix_fixed("I020",true,1)
        30:       asterix_fixed("I030",true,3)
        41:       asterix_fixed("I041",true,2)
        50:    asterix_compound("I050","FZZF"+"FFZ",[1,0,0,1,1,2,0],[0,0,0,0,0,0,0])
        60:    asterix_compound("I060","FZZF"+"FFZ",[1,0,0,1,1,1,0],[0,0,0,0,0,0,0])
        70:  asterix_repetitive("I070",true,2)
        90:       asterix_fixed("I090",true,2)
        100:       asterix_fixed("I100",true,8)
        110:       asterix_fixed("I110",true,1)
        120:       asterix_fixed("I120",true,8)
