# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/gnss.ksy
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
# Various structs shared between modules
#
# Automatically generated from spec/yaml/swiftnav/sbp/gnss.yaml with generate.py.
# Do not modify by hand!

meta:
  id: gnss
  title: SBP common GNSS types
  license: MIT
  imports: [  ]
  endian: le

types:

  gnss_signal:
    doc: |
      Signal identifier containing constellation, band, and satellite
      identifier.
    seq:
      - id: sat
        type: u1
        doc: |
          Constellation-specific satellite id. For GLO can either be (100+FCN)
          where FCN is in [-7,+6] or the Slot ID in [1,28].
      - id: code
        type: u1
        doc: Signal constellation, band and code
  
  sv_id:
    doc: |
      A (Constellation ID, satellite ID) tuple that uniquely identifies a
      space vehicle.
    seq:
      - id: sat_id
        type: u1
        doc: |
          Constellation-specific satellite id. For GLO can either be (100+FCN)
          where FCN is in [-7,+6] or the Slot ID in [1,28].
      - id: constellation
        type: u1
        doc: Constellation ID to which the SV belongs
  
  gnss_signal_dep:
    doc: Deprecated.
    seq:
      - id: sat
        type: u2
        doc: |
          Constellation-specific satellite identifier.

          Note: unlike GnssSignal, GPS satellites are encoded as (PRN - 1).
          Other constellations do not have this offset.
      - id: code
        type: u1
        doc: Signal constellation, band and code
      - id: reserved
        type: u1
        doc: Reserved
  
  gps_time_dep:
    doc: |
      A wire-appropriate GPS time, defined as the number of milliseconds since
      beginning of the week on the Saturday/Sunday transition.
    seq:
      - id: tow
        type: u4
        doc: Milliseconds since start of GPS week
      - id: wn
        type: u2
        doc: GPS week number
  
  gps_time_sec:
    doc: |
      A GPS time, defined as the number of seconds since beginning of the week
      on the Saturday/Sunday transition.
    seq:
      - id: tow
        type: u4
        doc: Seconds since start of GPS week
      - id: wn
        type: u2
        doc: GPS week number
  
  gps_time:
    doc: |
      A wire-appropriate receiver clock time, defined as the time since the
      beginning of the week on the Saturday/Sunday transition. In most cases,
      observations are epoch aligned so ns field will be 0.
    seq:
      - id: tow
        type: u4
        doc: Milliseconds since start of GPS week
      - id: ns_residual
        type: s4
        doc: |
          Nanosecond residual of millisecond-rounded TOW (ranges from -500000
          to 500000)
      - id: wn
        type: u2
        doc: GPS week number
  
  carrier_phase:
    doc: |
      Carrier phase measurement in cycles represented as a 40-bit fixed point
      number with Q32.8 layout, i.e. 32-bits of whole cycles and 8-bits of
      fractional cycles. This phase has the same sign as the pseudorange.
    seq:
      - id: i
        type: s4
        doc: Carrier phase whole cycles
      - id: f
        type: u1
        doc: Carrier phase fractional part
  
