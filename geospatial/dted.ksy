meta:
  id: dted
  title: DIGITAL TERRAIN ELEVATION DATA (DTED)
  file-extension:
    - dt0
    - dt1
    - dt2
  license: MIT
  ks-version: 0.8
  encoding: ASCII
  endian: be
doc: |
  PERFORMANCE SPECIFICATION DIGITAL TERRAIN ELEVATION DATA (DTED). |
  MIL-PRF-89020B (23 May 2000) |
  https://dds.cr.usgs.gov/srtm/version2_1/Documentation/MIL-PDF-89020B.pdf
seq:
  - id: uhl
    type: uhl_header
    doc: User Header Label (UHL)
  - id: dsi
    type: dsi_header
  - id: acc
    type: acc_header
  - id: records
    type: data_record
    repeat: expr
    repeat-expr: uhl.number_of_longitude_lines.value
types:
  uhl_header:
    doc: |
      User Header Label (UHL). The UHL is used for magnetic tape and CD-ROM. |
      Fixed Length = 80 ASCII Characters
    seq:
      - id: recognition_sentinel
        contents: UHL
        doc: Recognition sentinel ("UHL")
      - id: fixed_by_standard
        contents: "1"
        doc: Fixed by standard ("1")
      - id: longitude_of_origin
        type: angle(3,0)
        doc: |
          Longitude of origin (lower left corner of data set; full degree | 
          value; leading zero(s) for all subfields: degrees, minutes and |
          seconds). H is the Hemisphere of the data.
      - id: latitude_of_origin
        type: angle(3,0)
        doc: |
          Latitude of origin (lower left corner of data set; full degree |
          value; leading zero(s) for all sub fields: (degrees, minutes and |
          seconds). H is the Hemisphere of the data.
      - id: longitude_interval_seconds
        type: ascii_int
        doc: Longitude data interval in tenths of seconds.
      - id: latitude_interval_seconds
        type: ascii_int
        doc: Latitude data interval in tenths of seconds.
      - id: absolute_vertical_accuracy
        size: 4
        type: str
        doc: |
          Absolute Vertical Accuracy in Meters. (With 90% assurance that |
          the linear errors will not exceed this value relative to mean sea |
          level (Right justified)).
      - id: security_code
        size: 3
        type: str
        doc: Security code. (Left Justified)
      - id: unique_reference
        size: 12
        type: str
        doc: Unique reference number
      - id: number_of_longitude_lines
        type: ascii_int
        doc: |
          Count of the number of longitude (profiles) lines for a full |
          one-degree cell. Count is based on the Level of DTED and the |
          latitude zone of the cell. (See Table I, II and III).
      - id: number_of_latitude_points
        type: ascii_int
        doc: |
          Count of the number of latitude points per longitude line for |
          a full one-degree cell. ( e.g. 1201 for DTED1, 3601.for DTED2).
      - id: multiple_accuracy
        type: u1
        enum: multiple_accuracy
        doc: Whether the cell has a single or multiple accuracy.
      - id: reserved
        size: 24
        type: str
        doc: Unused portion for future use.
  dsi_header:
    doc: |
      Data Set Identification (DSI) Record. The DSI is used for magnetic |
      tape and CD-ROM. Fixed Length = 648 ASCII Characters |
      Note: *These fields, to be defined by producer, may be left blank.
    seq:
      - id: recognition_sentinel
        contents: DSI
        doc: Recognition Sentinel ("DSI").
      - id: security_classification_code
        type: u1
        enum: security_classification_enum
        doc: Security Classification Code
      - id: security_control_and_release_markings
        size: 2
        type: str
        doc: Security Control and Release Markings. For DoD use only.
      - id: security_handling_description
        size: 27
        type: str
        doc: |
          Security Handling Description. Other security description. (Free |
          text or blank filled).
      - id: reserved_for_future_use1
        size: 26
        type: str
        doc: Reserved for future use. (Blank filled).
      - id: nima_series_designator_for_product_level
        size: 5
        type: str
        doc: |
          NIMA Series Designator for or DTED2 product level (DTED0, DTED1 or |
          DTED2).
      - id: unique_reference_number
        size: 15
        type: str
        doc: |
          *Unique reference number. (For producing nations own use (free |
          text or zero filled)).
      - id: reserved_for_future_use2
        size: 8
        type: str
        doc: Reserved for future use. (Blank filled).
      - id: data_edition_number
        size: 2
        type: str
        doc: Data Edition Number (01-99).
      - id: match_merge_version
        size: 1
        type: str
        doc: Match/Merge Version (A-Z).
      - id: maintenance_date
        type: date
        doc: Match/Merge Date. Zero filled until used. (YYMM)
      - id: match_merge_date
        type: date
        doc: Match/Merge Date. Zero filled until used. (YYMM)
      - id: maintenance_description
        size: 4
        type: str
        doc: Maintenance Description Code. Zero filled until used. (0000 or ANNN)
      - id: producer_code
        size: 8
        type: str
        doc: |
          Producer Code.(Country - Free Text) (FIPS 10-4 Country Codes used 
          for first 2 characters) (CCAAABBB).
      - id: reserved_for_future_use3
        size: 16
        type: str
        doc: Reserved for future use. (Blank filled).
      - id: product_specification
        size: 9
        type: str
        doc: Product Specification. (Alphanumeric field) (AAAAAAAAA)
      - id:  product_specification_number
        size: 2
        type: str
        doc: |
          First digit is Product Specification Amendment Number and second |
          digit is the Change Number.
      - id:  product_specification_date
        type: date
        doc: Date of Product Specification.
      - id:  vertical_datum
        size: 3
        type: str
        doc: Vertical Datum (MSL, E96)
      - id:  horizontal_datum_code
        size: 5
        type: str
        doc: Horizontal Datum Code (Current Version World Geodetic System) (WGS84).
      - id:  digitizing_collection_system
        size: 10
        type: str
        doc: Digitizing/Collection System. (Free text).
      - id:  compilation_date
        type: date
        doc: Compilation Date. (Most descriptive year/month) (YYMM).
      - id:  reserved_for_future_use4
        size: 22
        type: str
        doc: Reserved for future use. (Blank filled).
      - id: latitude_of_origin
        type: angle(2,1)
        doc: |
          Latitude of origin of data— leading zero for values less than 10; H |
          is the hemisphere of the data. (DDMMSS.SH)
      - id: longitude_of_origin
        type: angle(3,1)
        doc: |
          Longitude of origin of data— leading zeroes for values less than |
          100; H is the hemisphere of the data. (DDDMMSS.SH)
      - id: latitude_of_sw_corner
        type: angle(2,0)
        doc: |
          Latitude of SW corner of data, bounding rectangle— leading zero for |
          values less than 10; H is the hemisphere of the data. (DDMMSSH)
      - id: longitude_of_sw_corner
        type: angle(3,0)
        doc: |
          Longitude of SW corner of data, bounding rectangle— leading zeroes |
          for values less than 100; H is the hemisphere of the data. (DDDMMSSH)
      - id: latitude_of_nw_corner
        type: angle(2,0)
        doc: |
          Latitude of NW corner of data, bounding rectangle— leading zero for |
          values less than 10; H is the hemisphere of the data. (DDMMSSH)
      - id: longitude_of_nw_corner
        type: angle(3,0)
        doc: |
          Longitude of NW corner of data, bounding rectangle— leading zeroes |
          for values less than 100; H is the hemisphere of the data. (DDDMMSSH)
      - id: latitude_of_ne_corner
        type: angle(2,0)
        doc: |
          Latitude of NE corner of data, bounding rectangle— leading zero for |
          values less than 10; H is the hemisphere of the data. (DDMMSSH)
      - id: longitude_of_ne_corner
        type: angle(3,0)
        doc: |
          Longitude of NE corner of data, bounding rectangle— leading zeroes |
          for values less than 100; H is the hemisphere of the data. (DDDMMSSH)
      - id: latitude_of_se_corner
        type: angle(2,0)
        doc: |
          Latitude of SE corner of data, bounding rectangle— leading zero for |
          values less than 10; H is the hemisphere of the data. (DDMMSSH)
      - id: longitude_of_se_corner
        type: angle(3,0)
        doc: |
          Longitude of SE corner of data, bounding rectangle— leading zeroes |
          for values less than 100; H is the hemisphere of the data. (DDDMMSSH)
      - id:  clockwise_orientation_angle
        type: angle(3,1)
        doc: |
          Clockwise orientation angle of data with respect to true North. |
          (Will usually be all zeros.)
      - id:  latitude_interval
        type: ascii_int
        doc: |
          Latitude interval in tenths of seconds between rows of elevation |
          values (SSSS).
      - id:  longitude_interval
        type: ascii_int
        doc: |
          Longitude interval in tenths of seconds between columns of elevation |
          values (SSSS).
      - id:  number_of_latitude_lines
        type: ascii_int
        doc: |
          Number of Latitude lines. For magnetic tape, this is the actual |
          count of the number of latitude points (rows that contain data). |
          For CD-ROM, this is the count of the number of latitude points in |
          a full one-degree cell. (e.g. 1201 for DTED1, 3601 for DTED2) |
          (0000-9999).
      - id:  number_of_longitude_lines
        type: ascii_int
        doc: |
          Number of Longitude lines. For magnetic tape, this is the actual |
          count of the number of longitude points (columns that contain data). |
          For CD-ROM, this is the count of the number of longitude points in a |
          full one-degree cell. The count is based on the level of DTED and |
          the latitude zone of the cell. (See Table II and III) (0000-9999). 
      - id:  partial_cell_indicator_text
        size: 2
        type: str
        doc: |
          Partial Cell Indicator 
          00 = Complete 1° cell 
          01-99 = % of data coverage.
      - id:  reserved_for_nima_use_only
        size: 101
        type: str
        doc: Reserved for NIMA use only. (Free text or Blank filled.)
      - id:  reserved_for_producing_nation_use_only
        size: 100
        type: str
        doc: Reserved for producing nation use only. (Free text or blank filled.)
      - id:  reserved_for_free_text_comments
        size: 155
        type: str
        doc: Reserved for free text comments. (Free text or Blank filled.)
    instances:
      partial_cell_indicator:
        value: '(partial_cell_indicator_text.to_i == 0) ? 100 : partial_cell_indicator_text.to_i'
        doc: Partial Cell Indicator (% of data coverage)
  acc_header:
    doc: |
      Accuracy Description (ACC) Record. The ACC is used for magnetic tape and |
      CD-ROM. Fixed Length = 2700 ASCII Characters |
      Note: *If Product has subregional accuracies, the overall accuracy of |
      the product will be the worst accuracy.
    seq:
      - id: recognition_sentinel
        contents: ACC
        doc: Recognition Sentinel ("ACC").
      - id: absolute_horizontal_accuracy
        type: ascii_int_maybe
        doc: |
          *Absolute Horizontal Accuracy of Product in meters (0000-9999 or Not |
          Available (NA))
      - id: absolute_vertical_accuracy
        type: ascii_int_maybe
        doc: |
          *Absolute Vertical Accuracy of Product in meters (0000-9999 or Not |
          Available (NA))
      - id: relative_horizontal_accuracy_of_product_in_meters
        type: ascii_int_maybe
        doc: |
          *Relative (Point-to-Point) Horizontal Accuracy of Product in meters. |
          (0000-9999 or Not Available (NA))
      - id: relative_vertical_accuracy_or_product_in_meters
        type: ascii_int_maybe
        doc: |
          *Relative (Point-to-Point) Vertical Accuracy of Product in meters. |
          (0000-9999 or Not Available (NA))
      - id: reserved_for_future_use1
        size: 4
        type: str
        doc: Reserved for future use. (Blank filled.)
      - id: reserved_for_nima_use_only1
        size: 1
        type: str
        doc: Reserved for NIMA use only.
      - id: reserved_for_future_use2
        size: 31
        type: str
        doc: Reserved for future use. (Blank filled.)
      - id: multiple_accuracy_outline_flag
        size: 2
        type: str
        doc: |
          Multiple Accuracy Outline Flag. |
          00 = No accuracy subregions provided. |
          02-09 = Number of accuracy subregions per 1° cell (maximum 9).
      - id: subregion
        type: acc_subregion
        repeat: expr
        repeat-expr: num_subregions
        doc: Populated accuracy subregions.
      - id: unused_subregions
        size: (9 - num_subregions) * 284
        doc: Blank-filled space for the unused accuracy subregions.
      - id: reserved_for_nima_use_only2
        size: 18
        type: str
        doc: Reserved for NIMA use only.
      - id: reserved_for_future_use3
        size: 69
        type: str
        doc: Reserved for future use.
    instances:
      num_subregions:
        value: 'multiple_accuracy_outline_flag == "  " ? 0 : multiple_accuracy_outline_flag.to_i'
        doc: Number of populated accuracy subregions (0 or 2 to 9).
  acc_subregion:
    doc: |
      Start of Accuracy Sub region Description. Repeat to maximum of nine |
      times. Only the number of subregions defined in the Multiple Accuracy |
      Outline Flag are populated. Blank fill all unused coordinate pairs |
      within a subregion. (1 Sub region = 284 ASCII Characters). Refer |
      to 3.13.5.1 for accuracy subregion description.
    seq:
      - id: absolute_horizontal_accuracy_or_subregion_in_meters
        type: ascii_int_maybe
        doc: |
          Absolute Horizontal Accuracy of Sub region in meters (0000-9999 or |
          Not Available (NA) )
      - id: absolute_vertical_accuracy_or_subregion_in_meters
        type: ascii_int_maybe
        doc: |
          Absolute Vertical Accuracy of Sub region in meters (0000-9999 or |
          Not Available (NA) )
      - id: relative_horizontal_accuracy_of_subregion_in_meters
        type: ascii_int_maybe
        doc: |
          Relative (Point-to-Point) Horizontal Accuracy of Sub region in |
          meters. (0000-9999 or Not Available (NA))
      - id: relative_vertical_accuracy_of_subregion_in_meters
        type: ascii_int_maybe
        doc: |
          Relative (Point-to-Point) Vertical Accuracy of Subregion in meters. |
          (0000-9999 or Not Available (NA))
      - id: number_of_coordinates_in_accuracy_subregion_outline
        size: 2
        type: str
        doc: |
          Number of coordinates in accuracy sub region outline. (Maximum of |
          14 coordinate pairs. The first coordinate is the most southwestern. |
          Coordinates are input clockwise. Implied closing from last to first |
          coordinate pairs.) (03-14)
      - id: coordinate_pair
        type: coordinate_pair
        repeat: expr
        repeat-expr: num_coordinates
        doc: |
          Start of Coordinate Pair Description. Repeat to maximum of fourteen |
          times to outline subregion. Blank fill all unused accuracy |
          subregions and unused portions of subregions.
      - id: unused_coordinate_pairs
        size: (14 - num_coordinates) * 19
        doc: Blank-filled space for the unused coordinate pairs.
    instances:
      num_coordinates:
        value: number_of_coordinates_in_accuracy_subregion_outline.to_i
        doc: Number of coordinate pairs in the subregion outline (3 to 14).
  data_record:
    doc: |
      Data Record Description. The Data Record is used for magnetic tape and |
      CD-ROM. |
      Each elevation is a true value as determined by the Earth Gravity |
      Model (EGM) 1996 recorded to the nearest meter. The horizontal position |
      is referenced to precise longitude-latitude locations in terms of the |
      current World Geodetic System (WGS), determined for each file by |
      reference to the origin at the southwest corner. The elevations are |
      evenly spaced in latitude and longitude at the interval designated in |
      the user header label in South to North profile sequence.
    seq:
      - id: recognition_sentinal
        contents: [0xAA]
        doc: Recognition Sentinel.
      - id: data_block_count
        type: b24
        doc: |
          Sequential count of the block within the file, starting with zero |
          for the first block (Fixed Binary). (Data block count)
      - id: logitude_count
        type: fixed_binary
        doc: |
          Count of the meridian. True longitude = longitude count x data |
          interval + origin (Offset from the SW corner longitude) |
          (Fixed Binary).
      - id: latitude_count
        type: fixed_binary
        doc: |
          Count of the parallel. True latitude = latitude count x data |
          interval + origin (Offset from the SW corner latitude) |
          (Fixed Binary).
      - id: elevations
        type: fixed_binary
        repeat: expr
        repeat-expr: _parent.uhl.number_of_latitude_points.value
        doc: True elevation value of point N of meridian in meters (Fixed Binary).
      - id: checksum
        type: s4
        doc: |
          Algebraic addition of contents of block. Sum is computed as an 
          integer summation of 8-bit values (Fixed Binary).
  fixed_binary:
    doc: Fixed Binary denotes signed magnitude, right-justified binary integers.
    seq:
      - id: is_negative
        type: b1
      - id: value
        type: b15
    instances:
      meters:
        value: 'value * (is_negative? -1 : 1)'
  ascii_int:
    seq:
      - id: text
        size: 4
        type: str
    instances:
      value:
        value: text.to_i
  ascii_int_maybe:
    seq:
      - id: text
        size: 4
        type: str
    instances:
      has_value:
        value: text != "    " and text != "  NA" and text.substring(0, 2) != "NA"
        doc: False for blank fields and for "NA" (not available), left- or right-justified.
      value:
        value: text.to_i
        if: has_value
  coordinate_pair:
    doc: |
      Typed used group 2 angles to form a coordinate.  It is accurate to the |
      tenth of a second.
    seq:
      - id: latitude
        type: angle(2,1)
        doc: |
          Latitude—leading zero for values less than 10; H is the hemisphere |
          of the data. (DDMMSS.SH)
      - id: longitude
        type: angle(3,1)
        doc: |
          Longitude—leading zero for values less than 100; H is the hemisphere |
          of the data. (DDDMMSS.SH)
  angle:
    params:
      - id: len_degrees
        type: u1
      - id: has_decimal_point
        type: u1
    seq:
      - id: degrees
        size: len_degrees
        type: str
      - id: minutes
        size: 2
        type: str
      - id: seconds
        size: 2
        type: str
      - id: decimal_point
        size: 1
        type: str
        if: has_decimal_point == 1
      - id: tenths_of_seconds
        size: 1
        type: str
        if: has_decimal_point == 1
      - id: hemisphere
        size: 1
        type: str
    instances:
      has_value:
        value: minutes != "  "
        doc: |
          Some angles are for completly blank ascii strings so we need to |
          check for that
      value:
        value: '(degrees.to_i + minutes.to_i/60.0 + seconds.to_i/3600.0 + (has_decimal_point==1?tenths_of_seconds.to_i/36000.0 : 0)) * (hemisphere == "S" or hemisphere == "W" ? -1 : 1)'
        if: has_value
        doc: Degree decimal floating point representation
  date:
    seq:
      - id: year_text
        size: 2
        type: str
      - id: month_text
        size: 2
        type: str
    instances:
      year:
        value: year_text.to_i
      month:
        value: month_text.to_i
enums:
  multiple_accuracy:
    0x30: single  # '0'
    0x31: multiple  # '1'
  security_classification_enum:
    83: secret
    67: confidential
    85: unclassified
    82: restricted
