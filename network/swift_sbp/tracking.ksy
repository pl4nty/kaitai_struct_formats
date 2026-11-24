# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/tracking.ksy
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
# Satellite code and carrier-phase tracking messages from the device.
#
# Automatically generated from spec/yaml/swiftnav/sbp/tracking.yaml with generate.py.
# Do not modify by hand!

meta:
  id: tracking
  title: SBP tracking messages
  license: MIT
  imports: [ gnss ]
  endian: le

types:

  msg_tracking_state_detailed_dep_a:
    doc: |
      The tracking message returns a set tracking channel parameters for a
      single tracking channel useful for debugging issues.
    seq:
      - id: recv_time
        type: u8
        doc: Receiver clock time.
      - id: tot
        type: gnss::gps_time
        doc: |
          Time of transmission of signal from satellite. TOW only valid when
          TOW status is decoded or propagated. WN only valid when week number
          valid flag is set.
      - id: p
        type: u4
        doc: |
          Pseudorange observation. Valid only when pseudorange valid flag is
          set.
      - id: p_std
        type: u2
        doc: |
          Pseudorange observation standard deviation. Valid only when
          pseudorange valid flag is set.
      - id: l
        type: gnss::carrier_phase
        doc: |
          Carrier phase observation with typical sign convention. Valid only
          when PLL pessimistic lock is achieved.
      - id: cn0
        type: u1
        doc: Carrier-to-Noise density
      - id: lock
        type: u2
        doc: |
          Lock time. It is encoded according to DF402 from the RTCM 10403.2
          Amendment 2 specification. Valid values range from 0 to 15.
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier.
      - id: doppler
        type: s4
        doc: Carrier Doppler frequency.
      - id: doppler_std
        type: u2
        doc: Carrier Doppler frequency standard deviation.
      - id: uptime
        type: u4
        doc: |
          Number of seconds of continuous tracking. Specifies how much time
          signal is in continuous track.
      - id: clock_offset
        type: s2
        doc: TCXO clock offset. Valid only when valid clock valid flag is set.
      - id: clock_drift
        type: s2
        doc: TCXO clock drift. Valid only when valid clock valid flag is set.
      - id: corr_spacing
        type: u2
        doc: Early-Prompt (EP) and Prompt-Late (PL) correlators spacing.
      - id: acceleration
        type: s1
        doc: Acceleration. Valid only when acceleration valid flag is set.
      - id: sync_flags
        type: u1
        doc: Synchronization status flags.
      - id: tow_flags
        type: u1
        doc: TOW status flags.
      - id: track_flags
        type: u1
        doc: Tracking loop status flags.
      - id: nav_flags
        type: u1
        doc: Navigation data status flags.
      - id: pset_flags
        type: u1
        doc: Parameters sets flags.
      - id: misc_flags
        type: u1
        doc: Miscellaneous flags.
  
  msg_tracking_state_detailed_dep:
    doc: Deprecated.
    seq:
      - id: recv_time
        type: u8
        doc: Receiver clock time.
      - id: tot
        type: gnss::gps_time_dep
        doc: |
          Time of transmission of signal from satellite. TOW only valid when
          TOW status is decoded or propagated. WN only valid when week number
          valid flag is set.
      - id: p
        type: u4
        doc: |
          Pseudorange observation. Valid only when pseudorange valid flag is
          set.
      - id: p_std
        type: u2
        doc: |
          Pseudorange observation standard deviation. Valid only when
          pseudorange valid flag is set.
      - id: l
        type: gnss::carrier_phase
        doc: |
          Carrier phase observation with typical sign convention. Valid only
          when PLL pessimistic lock is achieved.
      - id: cn0
        type: u1
        doc: Carrier-to-Noise density
      - id: lock
        type: u2
        doc: |
          Lock time. It is encoded according to DF402 from the RTCM 10403.2
          Amendment 2 specification. Valid values range from 0 to 15.
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal identifier.
      - id: doppler
        type: s4
        doc: Carrier Doppler frequency.
      - id: doppler_std
        type: u2
        doc: Carrier Doppler frequency standard deviation.
      - id: uptime
        type: u4
        doc: |
          Number of seconds of continuous tracking. Specifies how much time
          signal is in continuous track.
      - id: clock_offset
        type: s2
        doc: TCXO clock offset. Valid only when valid clock valid flag is set.
      - id: clock_drift
        type: s2
        doc: TCXO clock drift. Valid only when valid clock valid flag is set.
      - id: corr_spacing
        type: u2
        doc: Early-Prompt (EP) and Prompt-Late (PL) correlators spacing.
      - id: acceleration
        type: s1
        doc: Acceleration. Valid only when acceleration valid flag is set.
      - id: sync_flags
        type: u1
        doc: Synchronization status flags.
      - id: tow_flags
        type: u1
        doc: TOW status flags.
      - id: track_flags
        type: u1
        doc: Tracking loop status flags.
      - id: nav_flags
        type: u1
        doc: Navigation data status flags.
      - id: pset_flags
        type: u1
        doc: Parameters sets flags.
      - id: misc_flags
        type: u1
        doc: Miscellaneous flags.
  
  tracking_channel_state:
    doc: |
      Tracking channel state for a specific satellite signal and measured
      signal power.
    seq:
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal being tracked
      - id: fcn
        type: u1
        doc: Frequency channel number (GLONASS only)
      - id: cn0
        type: u1
        doc: Carrier-to-Noise density.  Zero implies invalid cn0.
  
  msg_tracking_state:
    doc: |
      The tracking message returns a variable-length array of tracking channel
      states. It reports status and carrier-to-noise density measurements for
      all tracked satellites.
    seq:
      - id: states
        type: tracking_channel_state
        repeat: eos
        doc: Signal tracking channel state
  
  measurement_state:
    doc: |
      Measurement Engine tracking channel state for a specific satellite
      signal and measured signal power. The mesid field for Glonass can either
      carry the FCN as 100 + FCN where FCN is in [-7, +6] or the Slot ID (from
      1 to 28).
    seq:
      - id: mesid
        type: gnss::gnss_signal
        doc: |
          Measurement Engine GNSS signal being tracked (carries either Glonass
          FCN or SLOT)
      - id: cn0
        type: u1
        doc: Carrier-to-Noise density.  Zero implies invalid cn0.
  
  msg_measurement_state:
    doc: |
      The tracking message returns a variable-length array of tracking channel
      states. It reports status and carrier-to-noise density measurements for
      all tracked satellites.
    seq:
      - id: states
        type: measurement_state
        repeat: eos
        doc: ME signal tracking channel state
  
  tracking_channel_correlation:
    doc: Structure containing in-phase and quadrature correlation components.
    seq:
      - id: i
        type: s2
        doc: In-phase correlation
      - id: q
        type: s2
        doc: Quadrature correlation
  
  msg_tracking_iq:
    doc: |
      When enabled, a tracking channel can output the correlations at each
      update interval.
    seq:
      - id: channel
        type: u1
        doc: Tracking channel of origin
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier
      - id: corrs
        type: tracking_channel_correlation
        repeat: expr
        repeat-expr: 3
        doc: Early, Prompt and Late correlations
  
  tracking_channel_correlation_dep:
    doc: Structure containing in-phase and quadrature correlation components.
    seq:
      - id: i
        type: s4
        doc: In-phase correlation
      - id: q
        type: s4
        doc: Quadrature correlation
  
  msg_tracking_iq_dep_b:
    doc: Deprecated.
    seq:
      - id: channel
        type: u1
        doc: Tracking channel of origin
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier
      - id: corrs
        type: tracking_channel_correlation_dep
        repeat: expr
        repeat-expr: 3
        doc: Early, Prompt and Late correlations
  
  msg_tracking_iq_dep_a:
    doc: Deprecated.
    seq:
      - id: channel
        type: u1
        doc: Tracking channel of origin
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal identifier
      - id: corrs
        type: tracking_channel_correlation_dep
        repeat: expr
        repeat-expr: 3
        doc: Early, Prompt and Late correlations
  
  tracking_channel_state_dep_a:
    doc: Deprecated.
    seq:
      - id: state
        type: u1
        doc: Status of tracking channel
      - id: prn
        type: u1
        doc: PRN-1 being tracked
      - id: cn0
        type: f4
        doc: Carrier-to-noise density
  
  msg_tracking_state_dep_a:
    doc: Deprecated.
    seq:
      - id: states
        type: tracking_channel_state_dep_a
        repeat: eos
        doc: Satellite tracking channel state
  
  tracking_channel_state_dep_b:
    doc: Deprecated.
    seq:
      - id: state
        type: u1
        doc: Status of tracking channel
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal being tracked
      - id: cn0
        type: f4
        doc: Carrier-to-noise density
  
  msg_tracking_state_dep_b:
    doc: Deprecated.
    seq:
      - id: states
        type: tracking_channel_state_dep_b
        repeat: eos
        doc: Signal tracking channel state
  
