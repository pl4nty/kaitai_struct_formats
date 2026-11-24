meta:
  id: asterix_cat_008_catalog
  title: Eurocontrol Asterix Category 008 CAT008 data items catalog. Edition 1.2
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

  Category 008 Catalog definition file

  ASTERIX Part 3 Category 008
  Monoradar Derived Weather Information

  EUROCONTROL-SPEC-0149-3

  Edition : 1.2

doc-ref: |
  https://www.eurocontrol.int/publication/cat008-eurocontrol-specification-surveillance-data-exchange-asterix-part-3-category-008

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
        20:    asterix_extended("I020",true,1,1)
        34:  asterix_repetitive("I034",true,4)
        36:  asterix_repetitive("I036",true,3)
        38:  asterix_repetitive("I038",true,4)
        40:       asterix_fixed("I040",true,2)
        50:  asterix_repetitive("I050",true,2)
        90:       asterix_fixed("I090",true,3)
        100:    asterix_extended("I100",true,3,1)
        110:    asterix_extended("I110",true,1,1)
        120:       asterix_fixed("I120",true,2)


instances:
  category:
    value: '"008"'

  version:
    value: '"1.20"'
