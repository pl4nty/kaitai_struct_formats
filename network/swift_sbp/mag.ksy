# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/mag.ksy
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
# Magnetometer (mag) messages.
#
# Automatically generated from spec/yaml/swiftnav/sbp/mag.yaml with generate.py.
# Do not modify by hand!

meta:
  id: mag
  title: SBP magnetometer messages
  license: MIT
  imports: [  ]
  endian: le

types:

  msg_mag_raw:
    doc: Raw data from the magnetometer.
    seq:
      - id: tow
        type: u4
        doc: |
          Milliseconds since start of GPS week. If the high bit is set, the
          time is unknown or invalid.
      - id: tow_f
        type: u1
        doc: Milliseconds since start of GPS week, fractional part
      - id: mag_x
        type: s2
        doc: Magnetic field in the body frame X axis
      - id: mag_y
        type: s2
        doc: Magnetic field in the body frame Y axis
      - id: mag_z
        type: s2
        doc: Magnetic field in the body frame Z axis
  
