# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/ssr.ksy
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
# Precise State Space Representation (SSR) corrections format
#
# Automatically generated from spec/yaml/swiftnav/sbp/ssr.yaml with generate.py.
# Do not modify by hand!

meta:
  id: ssr
  title: SBP SSR messages
  license: MIT
  imports: [ gnss ]
  endian: le

types:

  code_biases_content:
    doc: |
      Code biases are to be added to pseudorange. The corrections conform with
      RTCMv3 MT 1059 / 1065.
    seq:
      - id: code
        type: u1
        doc: |
          Signal encoded following RTCM specifications (DF380, DF381, DF382
          and DF467).
      - id: value
        type: s2
        doc: Code bias value
  
  phase_biases_content:
    doc: Phase biases are to be added to carrier phase measurements.
    seq:
      - id: code
        type: u1
        doc: |
          Signal encoded following RTCM specifications (DF380, DF381, DF382
          and DF467)
      - id: integer_indicator
        type: u1
        doc: Indicator for integer property
      - id: widelane_integer_indicator
        type: u1
        doc: Indicator for two groups of Wide-Lane(s) integer property
      - id: discontinuity_counter
        type: u1
        doc: |
          Signal phase discontinuity counter. Increased for every
          discontinuity in phase.
      - id: bias
        type: s4
        doc: Phase bias for specified signal
  
  stec_header:
    doc: |
      A full set of STEC information will likely span multiple SBP messages,
      since SBP message a limited to 255 bytes.  The header is used to tie
      multiple SBP messages into a sequence.
    seq:
      - id: tile_set_id
        type: u2
        doc: Unique identifier of the tile set this tile belongs to.
      - id: tile_id
        type: u2
        doc: Unique identifier of this tile in the tile set.
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction
      - id: num_msgs
        type: u1
        doc: Number of messages in the dataset
      - id: seq_num
        type: u1
        doc: Position of this message in the dataset
      - id: update_interval
        type: u1
        doc: |
          Update interval between consecutive corrections. Encoded following
          RTCM DF391 specification.
      - id: iod_atmo
        type: u1
        doc: IOD of the SSR atmospheric correction
  
  gridded_correction_header:
    doc: |
      The LPP message contains nested variable length arrays which are not
      supported in SBP, so each grid point will be identified by the index.
    seq:
      - id: tile_set_id
        type: u2
        doc: Unique identifier of the tile set this tile belongs to.
      - id: tile_id
        type: u2
        doc: Unique identifier of this tile in the tile set.
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction
      - id: num_msgs
        type: u2
        doc: Number of messages in the dataset
      - id: seq_num
        type: u2
        doc: Position of this message in the dataset
      - id: update_interval
        type: u1
        doc: |
          Update interval between consecutive corrections. Encoded following
          RTCM DF391 specification.
      - id: iod_atmo
        type: u1
        doc: IOD of the SSR atmospheric correction
      - id: tropo_quality_indicator
        type: u1
        doc: |
          Quality of the troposphere data. Encoded following RTCM DF389
          specification in units of m.
  
  stec_sat_element:
    doc: STEC polynomial for the given satellite.
    seq:
      - id: sv_id
        type: gnss::sv_id
        doc: Unique space vehicle identifier
      - id: stec_quality_indicator
        type: u1
        doc: |
          Quality of the STEC data. Encoded following RTCM DF389 specification
          but in units of TECU instead of m.
      - id: stec_coeff
        type: s2
        repeat: expr
        repeat-expr: 4
        doc: |
          Coefficients of the STEC polynomial in the order of C00, C01, C10,
          C11. C00 = 0.05 TECU, C01/C10 = 0.02 TECU/deg, C11 0.02 TECU/deg^2
  
  tropospheric_delay_correction_no_std:
    doc: Troposphere vertical delays at the grid point.
    seq:
      - id: hydro
        type: s2
        doc: Hydrostatic vertical delay
      - id: wet
        type: s1
        doc: Wet vertical delay
  
  tropospheric_delay_correction:
    doc: |
      Troposphere vertical delays (mean and standard deviation) at the grid
      point.
    seq:
      - id: hydro
        type: s2
        doc: Hydrostatic vertical delay. Add 2.3 m to get actual value.
      - id: wet
        type: s1
        doc: Wet vertical delay. Add 0.252 m to get actual value.
      - id: stddev
        type: u1
        doc: |
          Standard deviation encoded using a similar method as RTCM DF389. The
          upper 3 bit are the class, the lower 5 bits are the value. Standard
          deviation [mm] = (3^class * (1 + value/16) - 1)
  
  stec_residual_no_std:
    doc: STEC residual for the given satellite at the grid point.
    seq:
      - id: sv_id
        type: gnss::sv_id
        doc: space vehicle identifier
      - id: residual
        type: s2
        doc: STEC residual
  
  stec_residual:
    doc: |
      STEC residual (mean and standard deviation) for the given satellite at
      the grid point.
    seq:
      - id: sv_id
        type: gnss::sv_id
        doc: space vehicle identifier
      - id: residual
        type: s2
        doc: STEC residual
      - id: stddev
        type: u1
        doc: |
          Standard deviation encoded using a similar method as RTCM DF389. The
          upper 3 bit are the class, the lower 5 bits are the value. Standard
          deviation [TECU] = (3^class * (1 + value/16) - 1) * 0.1
  
  msg_ssr_orbit_clock:
    doc: |
      The precise orbit and clock correction message is to be applied as a
      delta correction to broadcast ephemeris and is an equivalent to the 1060
      /1066 RTCM message types.
    seq:
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier (16 bit)
      - id: update_interval
        type: u1
        doc: |
          Update interval between consecutive corrections. Encoded following
          RTCM DF391 specification.
      - id: iod_ssr
        type: u1
        doc: |
          IOD of the SSR correction. A change of Issue Of Data SSR is used to
          indicate a change in the SSR generating configuration
      - id: iod
        type: u4
        doc: Issue of broadcast ephemeris data or IODCRC (Beidou)
      - id: radial
        type: s4
        doc: Orbit radial delta correction
      - id: along
        type: s4
        doc: Orbit along delta correction
      - id: cross
        type: s4
        doc: Orbit along delta correction
      - id: dot_radial
        type: s4
        doc: Velocity of orbit radial delta correction
      - id: dot_along
        type: s4
        doc: Velocity of orbit along delta correction
      - id: dot_cross
        type: s4
        doc: Velocity of orbit cross delta correction
      - id: c0
        type: s4
        doc: |
          C0 polynomial coefficient for correction of broadcast satellite
          clock
      - id: c1
        type: s4
        doc: |
          C1 polynomial coefficient for correction of broadcast satellite
          clock
      - id: c2
        type: s4
        doc: |
          C2 polynomial coefficient for correction of broadcast satellite
          clock
  
  msg_ssr_code_biases:
    doc: |
      The precise code biases message is to be added to the pseudorange of the
      corresponding signal to get corrected pseudorange. It is an equivalent
      to the 1059 / 1065 RTCM message types.
    seq:
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier (16 bit)
      - id: update_interval
        type: u1
        doc: |
          Update interval between consecutive corrections. Encoded following
          RTCM DF391 specification.
      - id: iod_ssr
        type: u1
        doc: |
          IOD of the SSR correction. A change of Issue Of Data SSR is used to
          indicate a change in the SSR generating configuration
      - id: biases
        type: code_biases_content
        repeat: eos
        doc: Code biases for the different satellite signals
  
  msg_ssr_phase_biases:
    doc: |
      The precise phase biases message contains the biases to be added to the
      carrier phase of the corresponding signal to get corrected carrier phase
      measurement, as well as the satellite yaw angle to be applied to compute
      the phase wind-up correction. It is typically an equivalent to the 1265
      RTCM message types.
    seq:
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier (16 bit)
      - id: update_interval
        type: u1
        doc: |
          Update interval between consecutive corrections. Encoded following
          RTCM DF391 specification.
      - id: iod_ssr
        type: u1
        doc: |
          IOD of the SSR correction. A change of Issue Of Data SSR is used to
          indicate a change in the SSR generating configuration
      - id: dispersive_bias
        type: u1
        doc: Indicator for the dispersive phase biases property.
      - id: mw_consistency
        type: u1
        doc: Consistency indicator for Melbourne-Wubbena linear combinations
      - id: yaw
        type: u2
        doc: Satellite yaw angle
      - id: yaw_rate
        type: s1
        doc: Satellite yaw angle rate
      - id: biases
        type: phase_biases_content
        repeat: eos
        doc: Phase biases corrections for a satellite being tracked.
  
  msg_ssr_stec_correction_dep:
    doc: Deprecated.
    seq:
      - id: header
        type: stec_header
        doc: Header of a STEC polynomial coefficient message.
      - id: stec_sat_list
        type: stec_sat_element
        repeat: eos
        doc: Array of STEC polynomial coefficients for each space vehicle.
  
  bounds_header:
    seq:
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the bound
      - id: num_msgs
        type: u1
        doc: Number of messages in the dataset
      - id: seq_num
        type: u1
        doc: Position of this message in the dataset
      - id: update_interval
        type: u1
        doc: Update interval between consecutive bounds. Similar to RTCM DF391.
      - id: sol_id
        type: u1
        doc: SSR Solution ID.
  
  msg_ssr_stec_correction:
    seq:
      - id: header
        type: bounds_header
        doc: Header of a STEC correction with bounds message.
      - id: ssr_iod_atmo
        type: u1
        doc: IOD of the SSR atmospheric correction
      - id: tile_set_id
        type: u2
        doc: Tile set ID
      - id: tile_id
        type: u2
        doc: Tile ID
      - id: n_sats
        type: u1
        doc: Number of satellites.
      - id: stec_sat_list
        type: stec_sat_element
        repeat: eos
        doc: Array of STEC polynomial coefficients for each space vehicle.
  
  msg_ssr_gridded_correction:
    doc: |
      STEC residuals are per space vehicle, troposphere is not.

      It is typically equivalent to the QZSS CLAS Sub Type 9 messages.
    seq:
      - id: header
        type: gridded_correction_header
        doc: Header of a gridded correction message
      - id: index
        type: u2
        doc: Index of the grid point.
      - id: tropo_delay_correction
        type: tropospheric_delay_correction
        doc: Wet and hydrostatic vertical delays (mean, stddev).
      - id: stec_residuals
        type: stec_residual
        repeat: eos
        doc: STEC residuals for each satellite (mean, stddev).
  
  stec_sat_element_integrity:
    doc: STEC polynomial and bounds for the given satellite.
    seq:
      - id: stec_residual
        type: stec_residual
        doc: STEC residuals (mean, stddev)
      - id: stec_bound_mu
        type: u1
        doc: Error Bound Mean. See Note 1.
      - id: stec_bound_sig
        type: u1
        doc: Error Bound StDev. See Note 1.
      - id: stec_bound_mu_dot
        type: u1
        doc: Error Bound Mean First derivative.
      - id: stec_bound_sig_dot
        type: u1
        doc: Error Bound StDev First derivative.
  
  msg_ssr_gridded_correction_bounds:
    doc: |
      Note 1: Range: 0-17.5 m. i<= 200, mean = 0.01i; 200<i<=230,
      mean=2+0.1(i-200); i>230, mean=5+0.5(i-230).
    seq:
      - id: header
        type: bounds_header
        doc: Header of a bounds message.
      - id: ssr_iod_atmo
        type: u1
        doc: IOD of the correction.
      - id: tile_set_id
        type: u2
        doc: Set this tile belongs to.
      - id: tile_id
        type: u2
        doc: Unique identifier of this tile in the tile set.
      - id: tropo_qi
        type: u1
        doc: Tropo Quality Indicator. Similar to RTCM DF389.
      - id: grid_point_id
        type: u2
        doc: Index of the Grid Point.
      - id: tropo_delay_correction
        type: tropospheric_delay_correction
        doc: Tropospheric delay at grid point.
      - id: tropo_v_hydro_bound_mu
        type: u1
        doc: Vertical Hydrostatic Error Bound Mean.
      - id: tropo_v_hydro_bound_sig
        type: u1
        doc: Vertical Hydrostatic Error Bound StDev.
      - id: tropo_v_wet_bound_mu
        type: u1
        doc: Vertical Wet Error Bound Mean.
      - id: tropo_v_wet_bound_sig
        type: u1
        doc: Vertical Wet Error Bound StDev.
      - id: n_sats
        type: u1
        doc: Number of satellites.
      - id: stec_sat_list
        type: stec_sat_element_integrity
        repeat: eos
        doc: |
          Array of STEC polynomial coefficients and its bounds for each space
          vehicle.
  
  msg_ssr_tile_definition_dep_a:
    doc: Deprecated.
    seq:
      - id: tile_set_id
        type: u2
        doc: Unique identifier of the tile set this tile belongs to.
      - id: tile_id
        type: u2
        doc: |
          Unique identifier of this tile in the tile set.
          See GNSS-SSR-ArrayOfCorrectionPoints field correctionPointSetID.
      - id: corner_nw_lat
        type: s2
        doc: |
          North-West corner correction point latitude.

          The relation between the latitude X in the range [-90, 90] and the
          coded number N is:

          N = floor((X / 90) * 2^14)

          See GNSS-SSR-ArrayOfCorrectionPoints field referencePointLatitude.
      - id: corner_nw_lon
        type: s2
        doc: |
          North-West corner correction point longitude.

          The relation between the longitude X in the range [-180, 180] and
          the coded number N is:

          N = floor((X / 180) * 2^15)

          See GNSS-SSR-ArrayOfCorrectionPoints field referencePointLongitude.
      - id: spacing_lat
        type: u2
        doc: |
          Spacing of the correction points in the latitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field stepOfLatitude.
      - id: spacing_lon
        type: u2
        doc: |
          Spacing of the correction points in the longitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field stepOfLongitude.
      - id: rows
        type: u2
        doc: |
          Number of steps in the latitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field numberOfStepsLatitude.
      - id: cols
        type: u2
        doc: |
          Number of steps in the longitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field numberOfStepsLongitude.
      - id: bitmask
        type: u8
        doc: |
          Specifies the availability of correction data at the correction
          points in the array.

          If a specific bit is enabled (set to 1), the correction is not
          available. Only the first rows * cols bits are used, the remainder
          are set to 0. If there are more then 64 correction points the
          remaining corrections are always available.

          Starting with the northwest corner of the array (top left on a north
          oriented map) the correction points are enumerated with row
          precedence - first row west to east, second row west to east, until
          last row west to east - ending with the southeast corner of the
          array.

          See GNSS-SSR-ArrayOfCorrectionPoints field bitmaskOfGrids but note
          the definition of the bits is inverted.
  
  msg_ssr_tile_definition_dep_b:
    doc: Deprecated.
    seq:
      - id: ssr_sol_id
        type: u1
        doc: SSR Solution ID.
      - id: tile_set_id
        type: u2
        doc: Unique identifier of the tile set this tile belongs to.
      - id: tile_id
        type: u2
        doc: |
          Unique identifier of this tile in the tile set.
          See GNSS-SSR-ArrayOfCorrectionPoints field correctionPointSetID.
      - id: corner_nw_lat
        type: s2
        doc: |
          North-West corner correction point latitude.

          The relation between the latitude X in the range [-90, 90] and the
          coded number N is:

          N = floor((X / 90) * 2^14)

          See GNSS-SSR-ArrayOfCorrectionPoints field referencePointLatitude.
      - id: corner_nw_lon
        type: s2
        doc: |
          North-West corner correction point longitude.

          The relation between the longitude X in the range [-180, 180] and
          the coded number N is:

          N = floor((X / 180) * 2^15)

          See GNSS-SSR-ArrayOfCorrectionPoints field referencePointLongitude.
      - id: spacing_lat
        type: u2
        doc: |
          Spacing of the correction points in the latitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field stepOfLatitude.
      - id: spacing_lon
        type: u2
        doc: |
          Spacing of the correction points in the longitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field stepOfLongitude.
      - id: rows
        type: u2
        doc: |
          Number of steps in the latitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field numberOfStepsLatitude.
      - id: cols
        type: u2
        doc: |
          Number of steps in the longitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field numberOfStepsLongitude.
      - id: bitmask
        type: u8
        doc: |
          Specifies the availability of correction data at the correction
          points in the array.

          If a specific bit is enabled (set to 1), the correction is not
          available. Only the first rows * cols bits are used, the remainder
          are set to 0. If there are more then 64 correction points the
          remaining corrections are always available.

          Starting with the northwest corner of the array (top left on a north
          oriented map) the correction points are enumerated with row
          precedence - first row west to east, second row west to east, until
          last row west to east - ending with the southeast corner of the
          array.

          See GNSS-SSR-ArrayOfCorrectionPoints field bitmaskOfGrids but note
          the definition of the bits is inverted.
  
  msg_ssr_tile_definition:
    doc: |
      Provides the correction point coordinates for the atmospheric correction
      values in the MSG_SSR_STEC_CORRECTION and MSG_SSR_GRIDDED_CORRECTION
      messages.

      Based on ETSI TS 137 355 V16.1.0 (LTE Positioning Protocol) information
      element GNSS-SSR-CorrectionPoints. SBP only supports gridded arrays of
      correction points, not lists of points.
    seq:
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction
      - id: update_interval
        type: u1
        doc: |
          Update interval between consecutive corrections. Encoded following
          RTCM DF391 specification.
      - id: sol_id
        type: u1
        doc: SSR Solution ID. Similar to RTCM DF415.
      - id: iod_atmo
        type: u1
        doc: IOD of the SSR atmospheric correction.
      - id: tile_set_id
        type: u2
        doc: Unique identifier of the tile set this tile belongs to.
      - id: tile_id
        type: u2
        doc: |
          Unique identifier of this tile in the tile set.
          See GNSS-SSR-ArrayOfCorrectionPoints field correctionPointSetID.
      - id: corner_nw_lat
        type: s2
        doc: |
          North-West corner correction point latitude.

          The relation between the latitude X in the range [-90, 90] and the
          coded number N is:  N = floor((X / 90) * 2^14)

          See GNSS-SSR-ArrayOfCorrectionPoints field referencePointLatitude.
      - id: corner_nw_lon
        type: s2
        doc: |
          North-West corner correction point longitude.

          The relation between the longitude X in the range [-180, 180] and
          the coded number N is: N = floor((X / 180) * 2^15)

          See GNSS-SSR-ArrayOfCorrectionPoints field referencePointLongitude.
      - id: spacing_lat
        type: u2
        doc: |
          Spacing of the correction points in the latitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field stepOfLatitude.
      - id: spacing_lon
        type: u2
        doc: |
          Spacing of the correction points in the longitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field stepOfLongitude.
      - id: rows
        type: u2
        doc: |
          Number of steps in the latitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field numberOfStepsLatitude.
      - id: cols
        type: u2
        doc: |
          Number of steps in the longitude direction.

          See GNSS-SSR-ArrayOfCorrectionPoints field numberOfStepsLongitude.
      - id: bitmask
        type: u8
        doc: |
          Specifies the absence of correction data at the correction points in
          the array (grid).

          Only the first rows * cols bits are used, and if a specific bit is
          enabled (set to 1), the correction is not available. If there are
          more than 64 correction points the remaining corrections are always
          available.

          The correction points are packed by rows, starting with the
          northwest corner of the array (top-left on a north oriented map),
          with each row spanning west to east, ending with the southeast
          corner of the array.

          See GNSS-SSR-ArrayOfCorrectionPoints field bitmaskOfGrids but note
          the definition of the bits is inverted.
  
  satellite_apc:
    doc: |
      Contains phase center offset and elevation variation corrections for one
      signal on a satellite.
    seq:
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier (16 bit)
      - id: sat_info
        type: u1
        doc: Additional satellite information
      - id: svn
        type: u2
        doc: |
          Satellite Code, as defined by IGS. Typically the space vehicle
          number.
      - id: pco
        type: s2
        repeat: expr
        repeat-expr: 3
        doc: |
          Mean phase center offset, X Y and Z axes. See IGS ANTEX file format
          description for coordinate system definition.
      - id: pcv
        type: s1
        repeat: expr
        repeat-expr: 21
        doc: |
          Elevation dependent phase center variations. First element is 0
          degrees separation from the Z axis, subsequent elements represent
          elevation variations in 1 degree increments.
  
  msg_ssr_satellite_apc_dep:
    doc: Deprecated.
    seq:
      - id: apc
        type: satellite_apc
        repeat: eos
        doc: Satellite antenna phase center corrections
  
  msg_ssr_satellite_apc:
    seq:
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction
      - id: update_interval
        type: u1
        doc: |
          Update interval between consecutive corrections. Encoded following
          RTCM DF391 specification.
      - id: sol_id
        type: u1
        doc: SSR Solution ID. Similar to RTCM DF415.
      - id: iod_ssr
        type: u1
        doc: |
          IOD of the SSR correction. A change of Issue Of Data SSR is used to
          indicate a change in the SSR generating configuration
      - id: apc
        type: satellite_apc
        repeat: eos
        doc: Satellite antenna phase center corrections
  
  msg_ssr_orbit_clock_dep_a:
    doc: Deprecated.
    seq:
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier (16 bit)
      - id: update_interval
        type: u1
        doc: |
          Update interval between consecutive corrections. Encoded following
          RTCM DF391 specification.
      - id: iod_ssr
        type: u1
        doc: |
          IOD of the SSR correction. A change of Issue Of Data SSR is used to
          indicate a change in the SSR generating configuration
      - id: iod
        type: u1
        doc: Issue of broadcast ephemeris data
      - id: radial
        type: s4
        doc: Orbit radial delta correction
      - id: along
        type: s4
        doc: Orbit along delta correction
      - id: cross
        type: s4
        doc: Orbit along delta correction
      - id: dot_radial
        type: s4
        doc: Velocity of orbit radial delta correction
      - id: dot_along
        type: s4
        doc: Velocity of orbit along delta correction
      - id: dot_cross
        type: s4
        doc: Velocity of orbit cross delta correction
      - id: c0
        type: s4
        doc: |
          C0 polynomial coefficient for correction of broadcast satellite
          clock
      - id: c1
        type: s4
        doc: |
          C1 polynomial coefficient for correction of broadcast satellite
          clock
      - id: c2
        type: s4
        doc: |
          C2 polynomial coefficient for correction of broadcast satellite
          clock
  
  stec_header_dep_a:
    doc: |
      A full set of STEC information will likely span multiple SBP messages,
      since SBP message a limited to 255 bytes.  The header is used to tie
      multiple SBP messages into a sequence.
    seq:
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction
      - id: num_msgs
        type: u1
        doc: Number of messages in the dataset
      - id: seq_num
        type: u1
        doc: Position of this message in the dataset
      - id: update_interval
        type: u1
        doc: |
          Update interval between consecutive corrections. Encoded following
          RTCM DF391 specification.
      - id: iod_atmo
        type: u1
        doc: IOD of the SSR atmospheric correction
  
  gridded_correction_header_dep_a:
    doc: |
      The 3GPP message contains nested variable length arrays which are not
      supported in SBP, so each grid point will be identified by the index.
    seq:
      - id: time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction
      - id: num_msgs
        type: u2
        doc: Number of messages in the dataset
      - id: seq_num
        type: u2
        doc: Position of this message in the dataset
      - id: update_interval
        type: u1
        doc: |
          Update interval between consecutive corrections. Encoded following
          RTCM DF391 specification.
      - id: iod_atmo
        type: u1
        doc: IOD of the SSR atmospheric correction
      - id: tropo_quality_indicator
        type: u1
        doc: |
          Quality of the troposphere data. Encoded following RTCM DF389
          specification in units of m.
  
  grid_definition_header_dep_a:
    doc: |
      Defines the grid for MSG_SSR_GRIDDED_CORRECTION messages. Also includes
      an RLE encoded validity list.
    seq:
      - id: region_size_inverse
        type: u1
        doc: region_size (deg) = 10 / region_size_inverse 0 is an invalid value.
      - id: area_width
        type: u2
        doc: |
          grid height (deg) = grid width (deg) = area_width / region_size 0 is
          an invalid value.
      - id: lat_nw_corner_enc
        type: u2
        doc: |
          North-West corner latitude (deg) = region_size * lat_nw_corner_enc -
          90
      - id: lon_nw_corner_enc
        type: u2
        doc: |
          North-West corner longitude (deg) = region_size * lon_nw_corner_enc
          - 180
      - id: num_msgs
        type: u1
        doc: Number of messages in the dataset
      - id: seq_num
        type: u1
        doc: Position of this message in the dataset
  
  msg_ssr_stec_correction_dep_a:
    doc: Deprecated.
    seq:
      - id: header
        type: stec_header_dep_a
        doc: Header of a STEC message
      - id: stec_sat_list
        type: stec_sat_element
        repeat: eos
        doc: Array of STEC information for each space vehicle
  
  msg_ssr_gridded_correction_no_std_dep_a:
    doc: Deprecated.
    seq:
      - id: header
        type: gridded_correction_header_dep_a
        doc: Header of a Gridded Correction message
      - id: index
        type: u2
        doc: Index of the grid point
      - id: tropo_delay_correction
        type: tropospheric_delay_correction_no_std
        doc: Wet and hydrostatic vertical delays
      - id: stec_residuals
        type: stec_residual_no_std
        repeat: eos
        doc: STEC residuals for each satellite
  
  msg_ssr_gridded_correction_dep_a:
    doc: Deprecated.
    seq:
      - id: header
        type: gridded_correction_header_dep_a
        doc: Header of a Gridded Correction message
      - id: index
        type: u2
        doc: Index of the grid point
      - id: tropo_delay_correction
        type: tropospheric_delay_correction
        doc: Wet and hydrostatic vertical delays (mean, stddev)
      - id: stec_residuals
        type: stec_residual
        repeat: eos
        doc: STEC residuals for each satellite (mean, stddev)
  
  msg_ssr_grid_definition_dep_a:
    doc: Deprecated.
    seq:
      - id: header
        type: grid_definition_header_dep_a
        doc: Header of a Gridded Correction message
      - id: rle_list
        type: u1
        repeat: eos
        doc: |
          Run Length Encode list of quadrants that contain valid data. The
          spec describes the encoding scheme in detail, but essentially the
          index of the quadrants that contain transitions between valid and
          invalid (and vice versa) are encoded as u8 integers.
  
  orbit_clock_bound:
    doc: Orbit and clock bound.
    seq:
      - id: sat_id
        type: u1
        doc: |
          Satellite ID. Similar to either RTCM DF068 (GPS), DF252 (Galileo),
          or DF488 (BDS) depending on the constellation.
      - id: orb_radial_bound_mu
        type: u1
        doc: Mean Radial. See Note 1.
      - id: orb_along_bound_mu
        type: u1
        doc: Mean Along-Track. See Note 1.
      - id: orb_cross_bound_mu
        type: u1
        doc: Mean Cross-Track. See Note 1.
      - id: orb_radial_bound_sig
        type: u1
        doc: Standard Deviation Radial. See Note 2.
      - id: orb_along_bound_sig
        type: u1
        doc: Standard Deviation Along-Track. See Note 2.
      - id: orb_cross_bound_sig
        type: u1
        doc: Standard Deviation Cross-Track. See Note 2.
      - id: clock_bound_mu
        type: u1
        doc: Clock Bound Mean. See Note 1.
      - id: clock_bound_sig
        type: u1
        doc: Clock Bound Standard Deviation. See Note 2.
  
  msg_ssr_orbit_clock_bounds:
    doc: |
      Note 1: Range: 0-17.5 m. i<=200, mean=0.01i; 200<i<=230,
      mean=2+0.1(i-200); i>230, mean=5+0.5(i-230).

      Note 2: Range: 0-17.5 m. i<=200, std=0.01i; 200<i<=230, std=2+0.1(i-200)
      i>230, std=5+0.5(i-230).
    seq:
      - id: header
        type: bounds_header
        doc: Header of a bounds message.
      - id: ssr_iod
        type: u1
        doc: IOD of the SSR bound.
      - id: const_id
        type: u1
        doc: Constellation ID to which the SVs belong.
      - id: n_sats
        type: u1
        doc: Number of satellites.
      - id: orbit_clock_bounds
        type: orbit_clock_bound
        repeat: eos
        doc: Orbit and Clock Bounds per Satellite
  
  code_phase_biases_sat_sig:
    seq:
      - id: sat_id
        type: u1
        doc: |
          Satellite ID. Similar to either RTCM DF068 (GPS), DF252 (Galileo),
          or DF488 (BDS) depending on the constellation.
      - id: signal_id
        type: u1
        doc: |
          Signal and Tracking Mode Identifier. Similar to either RTCM DF380
          (GPS), DF382 (Galileo) or DF467 (BDS) depending on the
          constellation.
      - id: code_bias_bound_mu
        type: u1
        doc: |
          Code Bias Mean. Range: 0-1.275 m
      - id: code_bias_bound_sig
        type: u1
        doc: |
          Code Bias Standard Deviation. Range: 0-1.275 m
      - id: phase_bias_bound_mu
        type: u1
        doc: |
          Phase Bias Mean. Range: 0-1.275 m
      - id: phase_bias_bound_sig
        type: u1
        doc: |
          Phase Bias Standard Deviation. Range: 0-1.275 m
  
  msg_ssr_code_phase_biases_bounds:
    seq:
      - id: header
        type: bounds_header
        doc: Header of a bounds message.
      - id: ssr_iod
        type: u1
        doc: IOD of the SSR bound.
      - id: const_id
        type: u1
        doc: Constellation ID to which the SVs belong.
      - id: n_sats_signals
        type: u1
        doc: Number of satellite-signal couples.
      - id: satellites_signals
        type: code_phase_biases_sat_sig
        repeat: eos
        doc: Code and Phase Biases Bounds per Satellite-Signal couple.
  
  orbit_clock_bound_degradation:
    doc: Orbit and clock bound degradation.
    seq:
      - id: orb_radial_bound_mu_dot
        type: u1
        doc: |
          Orbit Bound Mean Radial First derivative. Range: 0-0.255 m/s
      - id: orb_along_bound_mu_dot
        type: u1
        doc: |
          Orbit Bound Mean Along-Track First derivative. Range: 0-0.255 m/s
      - id: orb_cross_bound_mu_dot
        type: u1
        doc: |
          Orbit Bound Mean Cross-Track First derivative. Range: 0-0.255 m/s
      - id: orb_radial_bound_sig_dot
        type: u1
        doc: |
          Orbit Bound Standard Deviation Radial First derivative. Range:
          0-0.255 m/s
      - id: orb_along_bound_sig_dot
        type: u1
        doc: |
          Orbit Bound Standard Deviation Along-Track First derivative. Range:
          0-0.255 m/s
      - id: orb_cross_bound_sig_dot
        type: u1
        doc: |
          Orbit Bound Standard Deviation Cross-Track First derivative. Range:
          0-0.255 m/s
      - id: clock_bound_mu_dot
        type: u1
        doc: |
          Clock Bound Mean First derivative. Range: 0-0.255 m/s
      - id: clock_bound_sig_dot
        type: u1
        doc: |
          Clock Bound Standard Deviation First derivative. Range: 0-0.255 m/s
  
  msg_ssr_orbit_clock_bounds_degradation:
    seq:
      - id: header
        type: bounds_header
        doc: Header of a bounds message.
      - id: ssr_iod
        type: u1
        doc: IOD of the SSR bound degradation parameter.
      - id: const_id
        type: u1
        doc: Constellation ID to which the SVs belong.
      - id: sat_bitmask
        type: u8
        doc: |
          Satellite Bit Mask. Put 1 for each satellite where the following
          degradation parameters are applicable, 0 otherwise. Encoded
          following RTCM DF394 specification.
      - id: orbit_clock_bounds_degradation
        type: orbit_clock_bound_degradation
        doc: Orbit and Clock Bounds Degradation Parameters
  
