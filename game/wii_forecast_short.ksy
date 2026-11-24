# Imported from https://github.com/RiiConnect24/Kaitai-Files/blob/86568af7c4f29040c178ab627c68be707a829829/Kaitais/forecast_file_short.ksy
meta:
  id: wii_forecast_short
  application: Forecast Channel
  license: AGPL-3.0-only
  endian: be
seq:
  - id: version
    type: u4
    doc: Always 0.
  - id: filesize
    type: u4
    doc: Size of the whole file, after decompressing.
  - id: crc32
    type: u4
    doc: CRC-32 checksum of everything after this field.
  - id: opening_timestamp
    type: u4
    doc: Timestamp is minutes since 2000.
  - id: closing_timestamp
    type: u4
    doc: Timestamp is minutes since 2000.
  - id: country_code
    type: u1
    enum: country_code
    doc: The country this file is for.
  - id: unknown_1
    type: u1
    repeat: expr
    repeat-expr: 3
    doc: Padding. Never read.
  - id: language_code
    type: u1
    enum: language_code
    doc: |
      Language of the file. Must match the console's language. Only the seven
      languages in the enum are supported; any other console language counts
      as English.
  - id: unknown_2
    type: u1
    doc: |
      Same spot as region_flag in forecast.bin, but nothing checks or uses it
      here.
  - id: unknown_3
    type: u1
    doc: Nothing checks or uses it.
  - id: padding
    type: u1
  - id: current_forecast_entry_number
    type: u4
  - id: current_forecast_table_offset
    type: u4
instances:
  opening_unix:
    value: (opening_timestamp + 15778080) * 60
    doc: The time the file was made as a normal Unix time (seconds since 1970).
  closing_unix:
    value: (closing_timestamp + 15778080) * 60
    doc: The time the file expires as a normal Unix time (seconds since 1970).
  current_forecast_table:
    pos: current_forecast_table_offset
    type: current_forecast_table
    repeat: expr
    repeat-expr: current_forecast_entry_number
types:
  current_forecast_table:
    seq:
      - id: country_code
        type: u1
        enum: country_code
      - id: region_code
        type: u1
      - id: location_code
        type: u2
      - id: opening_timestamp
        type: u4
        doc: |
          When this was measured, in the city's local time (minutes since
          2000). Shown as "As of ..." on the Wii Menu. The channel counts 6am
          to 6pm local time as daytime and picks its day or night look from
          it.
      - id: closing_timestamp
        type: u4
        doc: The same moment in UTC (minutes since 2000). Nothing uses it.
      - id: current_forecast
        type: u2
        doc: |
          Weather code, looked up in forecast.bin's
          weather_condition_codes_table. 0xFFFF means unused. If it is unused
          (or not found), the channel treats the whole entry as empty: no
          "now" page, and `--` instead of the temperature on the globe label.
      - id: unknown
        type: u1
        doc: |
          0 to 99, or 0xFF for unused. Checked but nothing uses it. (It is not
          padding, and not the same as precipitation, which goes up to 100.)
      - id: current_temperature_celsius
        type: s1
        doc: Temperature in Celsius. -128 means unused (the channel shows `--`).
      - id: current_temperature_fahrenheit
        type: s1
        doc: |
          Temperature in Fahrenheit. -128 means unused (the channel shows
          `--`).
      - id: current_wind_direction
        type: u1
        enum: wind_direction
        doc: |
          Which way the wind blows. `calm` is no wind, `unused` hides the wind
          line on the channel's "now" page.
      - id: current_wind_speed_kilometers_per_hour
        type: u1
        doc: Wind speed in km/h. Shown on the "now" page if the user chose km/h.
      - id: current_wind_speed_miles_per_hour
        type: u1
        doc: Wind speed in mph. Shown on the "now" page if the user chose mph.
      - id: unknown_1
        type: u2
        doc: Never checked, never read.
      - id: unknown_2
        type: u2
        doc: Never checked, never read. WiiLink writes 0xFFFF (unused).
    instances:
      utc_offset_minutes:
        value: opening_timestamp - closing_timestamp
        doc: How far the city's clock is from UTC, in minutes (-300 means UTC-5).
      current_forecast_is_unused:
        value: current_forecast == 0xffff
        doc: True when `current_forecast` is the "no data" marker.
enums:
  country_code:
    1: japan
    8: anguilla
    9: antigua_and_barbuda
    10: argentina
    11: aruba
    12: bahamas
    13: barbados
    14: belize
    15: bolivia
    16: brazil
    17: british_virgin_islands
    18: canada
    19: cayman_islands
    20: chile
    21: colombia
    22: costa_rica
    23: dominica
    24: dominican_republic
    25: ecuador
    26: el_salvador
    27: french_guiana
    28: grenada
    29: guadeloupe
    30: guatemala
    31: guyana
    32: haiti
    33: honduras
    34: jamaica
    35: martinique
    36: mexico
    37: monsterrat
    38: netherlands_antilles
    39: nicaragua
    40: panama
    41: paraguay
    42: peru
    43: st_kitts_and_nevis
    44: st_lucia
    45: st_vincent_and_the_grenadines
    46: suriname
    47: trinidad_and_tobago
    48: turks_and_caicos_islands
    49: united_states
    50: uruguay
    51: us_virgin_islands
    52: venezuela
    64: albania
    65: australia
    66: austria
    67: belgium
    68: bosnia_and_herzegovina
    69: botswana
    70: bulgaria
    71: croatia
    72: cyprus
    73: czech_republic
    74: denmark
    75: estonia
    76: finland
    77: france
    78: germany
    79: greece
    80: hungary
    81: iceland
    82: ireland
    83: italy
    84: latvia
    85: lesotho
    86: lichtenstein
    87: lithuania
    88: luxembourg
    89: fyr_of_macedonia
    90: malta
    91: montenegro
    92: mozambique
    93: namibia
    94: netherlands
    95: new_zealand
    96: norway
    97: poland
    98: portugal
    99: romania
    100: russia
    101: serbia
    102: slovakia
    103: slovenia
    104: south_africa
    105: spain
    106: swaziland
    107: sweden
    108: switzerland
    109: turkey
    110: united_kingdom
    111: zambia
    112: zimbabwe
    113: azerbaijan
    114: mauritania
    115: mali
    116: niger
    117: chad
    118: sudan
    119: eritrea
    120: dijibouti
    121: somalia
    128: taiwan
    136: south_korea
    144: hong_kong
    145: macao
    152: indonesia
    153: singapore
    154: thailand
    155: philippines
    156: malaysia
    160: china
    168: uae
    169: india
    170: egypt
    171: oman
    172: qatar
    173: kuwait
    174: saudi_arabia
    175: syria
    176: bahrain
    177: jordan
    254: other
  language_code:
    0: japanese
    1: english
    2: german
    3: french
    4: spanish
    5: italian
    6: dutch
  wind_direction:
    0: none
    1: nne
    2: ne
    3: ene
    4: e
    5: ese
    6: se
    7: sse
    8: s
    9: ssw
    10: sw
    11: wsw
    12: w
    13: wnw
    14: nw
    15: nnw
    16: n
