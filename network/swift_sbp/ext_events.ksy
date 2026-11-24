# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/ext_events.ksy
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
# Messages reporting accurately-timestamped external events, e.g. camera shutter
# time.
#
# Automatically generated from spec/yaml/swiftnav/sbp/ext_events.yaml with generate.py.
# Do not modify by hand!

meta:
  id: ext_events
  title: SBP external event messages
  license: MIT
  imports: [  ]
  endian: le

types:

  msg_ext_event:
    doc: |
      Reports detection of an external event, the GPS time it occurred, which
      pin it was and whether it was rising or falling.
    seq:
      - id: wn
        type: u2
        doc: GPS week number
      - id: tow
        type: u4
        doc: GPS time of week rounded to the nearest millisecond
      - id: ns_residual
        type: s4
        doc: |
          Nanosecond residual of millisecond-rounded TOW (ranges from -500000
          to 500000)
      - id: flags
        type: u1
        doc: Flags
      - id: pin
        type: u1
        doc: Pin number.  0..9 = DEBUG0..9.
  
