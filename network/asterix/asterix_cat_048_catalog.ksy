meta:
  id: asterix_cat_048_catalog
  title: ASTERIX category 048 data item catalog
  license: GPL-3.0-only
  ks-version: 0.9
  imports:
#    - field
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

  Category 048 Catalog definition file

  ASTERIX Part 4 Category 048 Monoradar Target Reports
  Edition: 1.25
  Edition date: 08/08/2019
  Reference nr: EUROCONTROL-SPEC-0149-4

doc-ref: |
  https://www.eurocontrol.int/publication/cat048-eurocontrol-specification-surveillance-data-exchange-asterix-part4


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
        30:   asterix_extended("I030",true,1,1)
        40:      asterix_fixed("I040",true,4)
        42:      asterix_fixed("I042",true,4)
        50:      asterix_fixed("I050",true,2)
        55:      asterix_fixed("I055",true,1)
        60:      asterix_fixed("I060",true,2)
        65:      asterix_fixed("I065",true,1)
        70:      asterix_fixed("I070",true,2)
        80:      asterix_fixed("I080",true,2)
        90:      asterix_fixed("I090",true,2)
        100:      asterix_fixed("I100",true,4)
        110:      asterix_fixed("I110",true,2)
        120:   asterix_compound("I120","FFFF"+"FFF",[1,7,0,0,0,0,0],[0,0,0,0,0,0,0])
        130:   asterix_compound("I130","FFFF"+"FFF",[1,1,1,1,1,1,1],[0,0,0,0,0,0,0])
        140:      asterix_fixed("I140",true,3)
        161:      asterix_fixed("I161",true,2)
        170:   asterix_extended("I170",true,1,1)
        200:      asterix_fixed("I200",true,4)
        210:      asterix_fixed("I210",true,4)
        220:      asterix_fixed("I220",true,3)
        240:      asterix_fixed("I240",true,6)
        250: asterix_repetitive("I250",true,8)
        230:      asterix_fixed("I230",true,2)
        260:      asterix_fixed("I260",true,7)


        #i048_010 #,"F","2","Data Source Identifier","N.A."),
        #i048_140 #,"F","3","Time of Day","1/128 s"),
        #i048_020 #,"X","1+1","Target Report Descriptor","N.A."),
        #i048_040 #,"F","4","Measured Position in Slant Polar Co-ordinates","RHO: 1/256 NM, THETA: 360/(2 16)"),
        #i048_070 #,"F","2","Mode-3/A Code in Octal Representation","N.A."),
        #i048_090 #,"F","2","Flight Level in Binary Representation","1/4 FL"),
        #i048_130 #,"C","1+F:1,F:1,F:1,F:1,F:1,F:1,F:1,F:0","Radar Plot Characteristics","N.A."),
        #i048_220 #,"F","3","Aircraft Address","N.A."),
        #i048_240 #,"F","6","Aircraft Identification","N.A."),
        #i048_250 #,"R","1+8","Mode S MB Data","N.A."),
        #i048_161 #,"F","2","Track/Plot Number","N.A."),
        #i048_042 #,"F","4","Calculated Position in Cartesian Co-ordinates","X, Y: 1/128 NM"),
        #i048_200 #,"F","4","Calculated Track Velocity in Polar Representation","Speed: (2-14) NM/s Heading:360/(2 16)"),
        #i048_170 #,"X","1+1","Track Status","N.A."),
        #i048_210 #,"F","4","Track Quality","N.A."),
        #i048_030 #,"X","1+1","Warning/Error Conditions","N.A."),
        #i048_080 #,"F","2","Mode-3/A Code Confidence Indicator","N.A."),
        #i048_100 #,"F","4","Mode-C Code and Confidence Indicator","N.A."),
        #i048_110 #,"F","2","Height Measured by a 3D Radar","25 ft"),
        #i048_120 #,"C","1+F:1,F:7,F:0,F:0,F:0,F:0,F:0,F:0","Radial Doppler Speed","(2-14) NM/s"),
        #i048_230 #,"F","2","Communications / ACAS Capability and Flight Status","N.A."),
        #i048_260 #,"F","7","ACAS Resolution Advisory Report","N.A."),
        #i048_055 #,"F","1","Mode-1 Code in Octal Representation","N.A."),
        #i048_050 #,"F","2","Mode-2 Code in Octal Representation","N.A."),
        #i048_065 #,"F","1","Mode 1 Code Confidence Indicator","N.A."),
        #i048_060 #,"F","2","Mode-2 Code Confidence Indicator","N.A."),
        #i048_sp #,"E","1","Special Purpose Field","N.A."),
        #i048_re #,"E","1","Reserved Expansion Field","N.A."),  #

enums:
  c048:
    0: i000
    10: i010
    20: i020
    30: i030
    40: i040
    42: i042
    50: i050
    55: i055
    60: i060
    65: i065
    70: i070
    80: i080
    90: i090
    100: i100
    110: i110
    120: i120
    130: i130
    140: i140
    161: i161
    170: i170
    200: i200
    210: i210
    220: i220
    240: i240
    250: i250
    230: i230
    260: i260
