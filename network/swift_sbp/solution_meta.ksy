# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/solution_meta.ksy
# Licence and copyright: see _community/README.md
# Copyright (C) 2015-2023 Swift Navigation Inc.
# Contact: https://support.swiftnav.com
#
# This source is subject to the license found in the file 'LICENSE' which must
# be distributed together with this source. All other rights reserved.
#
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
#
# Standardized Metadata messages for Fuzed Solution from Swift Navigation devices.
#
# Automatically generated from spec/yaml/swiftnav/sbp/solution_meta.yaml with generate.py.
# Do not modify by hand!

meta:
  id: solution_meta
  title: SBP solution metadata messages
  license: MIT
  imports: [  ]
  endian: le

types:

  solution_input_type:
    doc: |
      Metadata describing which sensors were involved in the solution. The
      structure is fixed no matter what the actual sensor type is. The
      sensor_type field tells you which sensor we are talking about. It also
      tells you whether the sensor data was actually used or not. The flags
      field, always a u8, contains the sensor-specific data. The content of
      flags, for each sensor type, is described in the relevant structures in
      this section.
    seq:
      - id: sensor_type
        type: u1
        doc: The type of sensor
      - id: flags
        type: u1
        doc: Refer to each InputType description
  
  msg_soln_meta_dep_a:
    doc: Deprecated.
    seq:
      - id: pdop
        type: u2
        doc: |
          Position Dilution of Precision as per last available DOPS from PVT
          engine (0xFFFF indicates invalid)
      - id: hdop
        type: u2
        doc: |
          Horizontal Dilution of Precision as per last available DOPS from PVT
          engine (0xFFFF indicates invalid)
      - id: vdop
        type: u2
        doc: |
          Vertical Dilution of Precision as per last available DOPS from PVT
          engine (0xFFFF indicates invalid)
      - id: n_sats
        type: u1
        doc: Number of satellites as per last available solution from PVT engine
      - id: age_corrections
        type: u2
        doc: |
          Age of corrections as per last available AGE_CORRECTIONS from PVT
          engine (0xFFFF indicates invalid)
      - id: alignment_status
        type: u1
        doc: |
          State of alignment and the status and receipt of the alignment
          inputs
      - id: last_used_gnss_pos_tow
        type: u4
        doc: Tow of last-used GNSS position measurement
      - id: last_used_gnss_vel_tow
        type: u4
        doc: Tow of last-used GNSS velocity measurement
      - id: sol_in
        type: solution_input_type
        repeat: eos
        doc: |
          Array of Metadata describing the sensors potentially involved in the
          solution. Each element in the array represents a single sensor type
          and consists of flags containing (meta)data pertaining to that
          specific single sensor. Refer to each (XX)InputType descriptor in
          the present doc.
  
  msg_soln_meta:
    doc: |
      This message contains all metadata about the sensors received and/or
      used in computing the sensorfusion solution. It focuses primarily, but
      not only, on GNSS metadata. Regarding the age of the last received valid
      GNSS solution, the highest two bits are time status, indicating whether
      age gnss can or can not be used to retrieve time of measurement (noted
      TOM, also known as time of validity) If it can, subtract 'age gnss' from
      'tow' in navigation messages to get TOM. Can be used before alignment is
      complete in the Fusion Engine, when output solution is the last received
      valid GNSS solution and its tow is not a TOM.
    seq:
      - id: tow
        type: u4
        doc: GPS time of week rounded to the nearest millisecond
      - id: pdop
        type: u2
        doc: |
          Position Dilution of Precision as per last available DOPS from PVT
          engine (0xFFFF indicates invalid)
      - id: hdop
        type: u2
        doc: |
          Horizontal Dilution of Precision as per last available DOPS from PVT
          engine (0xFFFF indicates invalid)
      - id: vdop
        type: u2
        doc: |
          Vertical Dilution of Precision as per last available DOPS from PVT
          engine (0xFFFF indicates invalid)
      - id: age_corrections
        type: u2
        doc: |
          Age of corrections as per last available AGE_CORRECTIONS from PVT
          engine (0xFFFF indicates invalid)
      - id: age_gnss
        type: u4
        doc: Age and Time Status of the last received valid GNSS solution.
      - id: sol_in
        type: solution_input_type
        repeat: eos
        doc: |
          Array of Metadata describing the sensors potentially involved in the
          solution. Each element in the array represents a single sensor type
          and consists of flags containing (meta)data pertaining to that
          specific single sensor. Refer to each (XX)InputType descriptor in
          the present doc.
  
  gnss_input_type:
    doc: |
      Metadata around the GNSS sensors involved in the fuzed solution.
      Accessible through sol_in[N].flags in a MSG_SOLN_META.
    seq:
      - id: flags
        type: u1
        doc: flags that store all relevant info specific to this sensor type.
  
  imu_input_type:
    doc: |
      Metadata around the IMU sensors involved in the fuzed solution.
      Accessible through sol_in[N].flags in a MSG_SOLN_META.
    seq:
      - id: flags
        type: u1
        doc: Instrument time, grade, and architecture for a sensor.
  
  odo_input_type:
    doc: |
      Metadata around the Odometry sensors involved in the fuzed solution.
      Accessible through sol_in[N].flags in a MSG_SOLN_META.
    seq:
      - id: flags
        type: u1
        doc: Instrument ODO rate, grade, and quality.
  
