# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/imu.ksy
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
# Inertial Measurement Unit (IMU) messages.
#
# Automatically generated from spec/yaml/swiftnav/sbp/imu.yaml with generate.py.
# Do not modify by hand!

meta:
  id: imu
  title: SBP IMU messages
  license: MIT
  imports: [  ]
  endian: le

types:

  msg_imu_raw:
    doc: |
      Raw data from the Inertial Measurement Unit, containing accelerometer
      and gyroscope readings. The sense of the measurements are to be aligned
      with the indications on the device itself. Measurement units, which are
      specific to the device hardware and settings, are communicated via the
      MSG_IMU_AUX message. If using "time since startup" local time tags, the
      receiving end will expect either a MSG_GNSS_TIME_OFFSET or MSG_PPS_TIME
      to establish the relationship between IMU time and GNSS time.
      Regardless of the timestamping mode, the timestamp is required to roll
      over to zero when reaching one week (604800 seconds, or 604800000
      milliseconds).
      The time-tagging mode should not change throughout a run.
    seq:
      - id: tow
        type: u4
        doc: Milliseconds since reference epoch and time status.
      - id: tow_f
        type: u1
        doc: Milliseconds since reference epoch, fractional part
      - id: acc_x
        type: s2
        doc: Acceleration in the IMU frame X axis
      - id: acc_y
        type: s2
        doc: Acceleration in the IMU frame Y axis
      - id: acc_z
        type: s2
        doc: Acceleration in the IMU frame Z axis
      - id: gyr_x
        type: s2
        doc: Angular rate around IMU frame X axis
      - id: gyr_y
        type: s2
        doc: Angular rate around IMU frame Y axis
      - id: gyr_z
        type: s2
        doc: Angular rate around IMU frame Z axis
  
  msg_imu_aux:
    doc: |
      Auxiliary data specific to a particular IMU. The `imu_type` field will
      always be consistent but the rest of the payload is device specific and
      depends on the value of `imu_type`.
    seq:
      - id: imu_type
        type: u1
        doc: IMU type
      - id: temp
        type: s2
        doc: Raw IMU temperature
      - id: imu_conf
        type: u1
        doc: IMU configuration
  
  msg_imu_comp:
    doc: |
      Data from the Inertial Measurement Unit, containing accelerometer and
      gyroscope readings compensated for estimated errors and constant
      physical effects. The output is valid for inertially referenced center
      of navigation (IMU body frame) represented in vehicle body frame.
    seq:
      - id: time
        type: u8
        doc: Microseconds since reference epoch
      - id: flags
        type: u2
        doc: |
          Contains the applied compensation parameters and time
          synchronization mode
      - id: acc_comp_x
        type: s4
        doc: Compensated acceleration X axis
      - id: acc_comp_y
        type: s4
        doc: Compensated acceleration Y axis
      - id: acc_comp_z
        type: s4
        doc: Compensated acceleration Z axis
      - id: gyr_comp_x
        type: s4
        doc: Compensated angular rate X axis
      - id: gyr_comp_y
        type: s4
        doc: Compensated angular rate Y axis
      - id: gyr_comp_z
        type: s4
        doc: Compensated angular rate Z axis
  
