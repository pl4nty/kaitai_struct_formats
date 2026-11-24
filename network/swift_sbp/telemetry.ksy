# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/telemetry.ksy
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
# Telemetry messages reported by Starling engine. The messages include various
# byproducts of state estimation and other logic across Starling and are aimed at
# efficient issue diagnostics.
#
# Automatically generated from spec/yaml/swiftnav/sbp/telemetry.yaml with generate.py.
# Do not modify by hand!

meta:
  id: telemetry
  title: SBP telemetry messages
  license: MIT
  imports: [ gnss ]
  endian: le

types:

  telemetry_sv:
    seq:
      - id: az
        type: u1
        doc: Azimuth angle (range 0..179)
      - id: el
        type: s1
        doc: Elevation angle (range -90..90)
      - id: availability_flags
        type: u1
        doc: Observation availability at filter update
      - id: pseudorange_residual
        type: s2
        doc: Pseudorange observation residual
      - id: phase_residual
        type: s2
        doc: Carrier-phase or carrier-phase-derived observation residual
      - id: outlier_flags
        type: u1
        doc: |
          Reports if observation is marked as an outlier and is excluded from
          the update
      - id: ephemeris_flags
        type: u1
        doc: Ephemeris metadata
      - id: correction_flags
        type: u1
        doc: Reserved
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier (16 bit)
  
  msg_tel_sv:
    doc: |
      This message includes telemetry pertinent to satellite signals available
      to Starling.
    seq:
      - id: wn
        type: u2
        doc: GPS week number
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: n_obs
        type: u1
        doc: |
          Total number of observations. First nibble is the size of the
          sequence (n), second nibble is the zero-indexed counter (ith packet
          of n)
      - id: origin_flags
        type: u1
        doc: |
          Flags to identify the filter type from which the telemetry is
          reported from
      - id: sv_tel
        type: telemetry_sv
        repeat: eos
        doc: Array of per-signal telemetry entries
  
