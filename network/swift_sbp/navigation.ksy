# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/navigation.ksy
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
# Geodetic navigation messages reporting GPS time, position, velocity, and
# baseline position solutions. For position solutions, these messages define
# several different position solutions: single-point (SPP), RTK, and pseudo-
# absolute position solutions.  The SPP is the standalone, absolute GPS position
# solution using only a single receiver. The RTK solution is the differential GPS
# solution, which can use either a fixed/integer or floating carrier phase
# ambiguity. The pseudo-absolute position solution uses a user-provided, well-
# surveyed base station position (if available) and the RTK solution in tandem.
# When the inertial navigation mode indicates that the IMU is used, all messages
# are reported in the vehicle body frame as defined by device settings.  By
# default, the vehicle body frame is configured to be coincident with the antenna
# phase center.  When there is no inertial navigation, the solution will be
# reported at the phase center of the antenna. There is no inertial navigation
# capability on Piksi Multi or Duro.  The tow field, when valid, is most often the
# Time of Measurement. When this is the case, the 5th bit of flags is set to the
# default value of 0. When this is not the case, the tow may be a time of arrival
# or a local system timestamp, irrespective of the time reference (GPS Week or
# else), but not a Time of Measurement.
#
# Automatically generated from spec/yaml/swiftnav/sbp/navigation.yaml with generate.py.
# Do not modify by hand!

meta:
  id: navigation
  title: SBP navigation messages
  license: MIT
  imports: [  ]
  endian: le

types:

  msg_gps_time:
    doc: |
      This message reports the GPS time, representing the time since the GPS
      epoch began on midnight January 6, 1980 UTC. GPS time counts the weeks
      and seconds of the week. The weeks begin at the Saturday/Sunday
      transition. GPS week 0 began at the beginning of the GPS time scale.

      Within each week number, the GPS time of the week is between between 0
      and 604800 seconds (=60*60*24*7). Note that GPS time does not accumulate
      leap seconds, and as of now, has a small offset from UTC. In a message
      stream, this message precedes a set of other navigation messages
      referenced to the same time (but lacking the ns field) and indicates a
      more precise time of these messages.

      The values in this message are from GNSS measurements fused with
      inertial measurements. To get values from GNSS measurements only use
      MSG_GPS_TIME_GNSS.
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
        doc: Status flags (reserved)
  
  msg_gps_time_gnss:
    doc: |
      This message reports the GPS time, representing the time since the GPS
      epoch began on midnight January 6, 1980 UTC. GPS time counts the weeks
      and seconds of the week. The weeks begin at the Saturday/Sunday
      transition. GPS week 0 began at the beginning of the GPS time scale.

      Within each week number, the GPS time of the week is between between 0
      and 604800 seconds (=60*60*24*7). Note that GPS time does not accumulate
      leap seconds, and as of now, has a small offset from UTC. In a message
      stream, this message precedes a set of other navigation messages
      referenced to the same time (but lacking the ns field) and indicates a
      more precise time of these messages.

      The values in this message are from GNSS measurements only. To get
      values fused with inertial measurements use MSG_GPS_TIME.
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
        doc: Status flags (reserved)
  
  msg_utc_time:
    doc: |
      This message reports the Universal Coordinated Time (UTC).  Note the
      flags which indicate the source of the UTC offset value and source of
      the time fix.

      The values in this message are from GNSS measurements fused with
      inertial measurements. To get values from GNSS measurements only use
      MSG_UTC_TIME_GNSS.
    seq:
      - id: flags
        type: u1
        doc: Indicates source and time validity
      - id: tow
        type: u4
        doc: GPS time of week rounded to the nearest millisecond
      - id: year
        type: u2
        doc: Year
      - id: month
        type: u1
        doc: Month (range 1 .. 12)
      - id: day
        type: u1
        doc: days in the month (range 1-31)
      - id: hours
        type: u1
        doc: hours of day (range 0-23)
      - id: minutes
        type: u1
        doc: minutes of hour (range 0-59)
      - id: seconds
        type: u1
        doc: seconds of minute (range 0-60) rounded down
      - id: ns
        type: u4
        doc: nanoseconds of second (range 0-999999999)
  
  msg_utc_time_gnss:
    doc: |
      This message reports the Universal Coordinated Time (UTC).  Note the
      flags which indicate the source of the UTC offset value and source of
      the time fix.

      The values in this message are from GNSS measurements only. To get
      values fused with inertial measurements use MSG_UTC_TIME.
    seq:
      - id: flags
        type: u1
        doc: Indicates source and time validity
      - id: tow
        type: u4
        doc: GPS time of week rounded to the nearest millisecond
      - id: year
        type: u2
        doc: Year
      - id: month
        type: u1
        doc: Month (range 1 .. 12)
      - id: day
        type: u1
        doc: days in the month (range 1-31)
      - id: hours
        type: u1
        doc: hours of day (range 0-23)
      - id: minutes
        type: u1
        doc: minutes of hour (range 0-59)
      - id: seconds
        type: u1
        doc: seconds of minute (range 0-60) rounded down
      - id: ns
        type: u4
        doc: nanoseconds of second (range 0-999999999)
  
  msg_dops:
    doc: |
      This dilution of precision (DOP) message describes the effect of
      navigation satellite geometry on positional measurement precision.  The
      flags field indicated whether the DOP reported corresponds to
      differential or SPP solution.

      The values in this message are from GNSS measurements only.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: gdop
        type: u2
        doc: Geometric Dilution of Precision
      - id: pdop
        type: u2
        doc: Position Dilution of Precision
      - id: tdop
        type: u2
        doc: Time Dilution of Precision
      - id: hdop
        type: u2
        doc: Horizontal Dilution of Precision
      - id: vdop
        type: u2
        doc: Vertical Dilution of Precision
      - id: flags
        type: u1
        doc: |
          Indicates the position solution with which the DOPS message
          corresponds
  
  msg_pos_ecef:
    doc: |
      The position solution message reports absolute Earth Centered Earth
      Fixed (ECEF) coordinates and the status (single point vs pseudo-absolute
      RTK) of the position solution. If the rover receiver knows the surveyed
      position of the base station and has an RTK solution, this reports a
      pseudo-absolute position solution using the base station position and
      the rover's RTK baseline vector. The full GPS time is given by the
      preceding MSG_GPS_TIME with the matching time-of-week (tow).

      The values in this message are from GNSS measurements fused with
      inertial measurements. To get values from GNSS measurements only use
      MSG_POS_ECEF_GNSS.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: f8
        doc: ECEF X coordinate
      - id: y
        type: f8
        doc: ECEF Y coordinate
      - id: z
        type: f8
        doc: ECEF Z coordinate
      - id: accuracy
        type: u2
        doc: Position estimated standard deviation
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_pos_ecef_cov:
    doc: |
      The position solution message reports absolute Earth Centered Earth
      Fixed (ECEF) coordinates and the status (single point vs pseudo-absolute
      RTK) of the position solution. The message also reports the upper
      triangular portion of the 3x3 covariance matrix. If the receiver knows
      the surveyed position of the base station and has an RTK solution, this
      reports a pseudo-absolute position solution using the base station
      position and the rover's RTK baseline vector. The full GPS time is given
      by the preceding MSG_GPS_TIME with the matching time-of-week (tow).

      The values in this message are from GNSS measurements fused with
      inertial measurements. To get values from GNSS measurements only use
      MSG_POS_ECEF_COV_GNSS.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: f8
        doc: ECEF X coordinate
      - id: y
        type: f8
        doc: ECEF Y coordinate
      - id: z
        type: f8
        doc: ECEF Z coordinate
      - id: cov_x_x
        type: f4
        doc: Estimated variance of x
      - id: cov_x_y
        type: f4
        doc: Estimated covariance of x and y
      - id: cov_x_z
        type: f4
        doc: Estimated covariance of x and z
      - id: cov_y_y
        type: f4
        doc: Estimated variance of y
      - id: cov_y_z
        type: f4
        doc: Estimated covariance of y and z
      - id: cov_z_z
        type: f4
        doc: Estimated variance of z
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_pos_llh:
    doc: |
      This position solution message reports the absolute geodetic coordinates
      and the status (single point vs pseudo-absolute RTK) of the position
      solution. If the rover receiver knows the surveyed position of the base
      station and has an RTK solution, this reports a pseudo-absolute position
      solution using the base station position and the rover's RTK baseline
      vector. The full GPS time is given by the preceding MSG_GPS_TIME with
      the matching time-of-week (tow).

      The values in this message are from GNSS measurements fused with
      inertial measurements. To get values from GNSS measurements only use
      MSG_POS_LLH_GNSS.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: lat
        type: f8
        doc: Latitude
      - id: lon
        type: f8
        doc: Longitude
      - id: height
        type: f8
        doc: Height above WGS84 ellipsoid
      - id: h_accuracy
        type: u2
        doc: Horizontal position estimated standard deviation
      - id: v_accuracy
        type: u2
        doc: Vertical position estimated standard deviation
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution.
      - id: flags
        type: u1
        doc: Status flags
  
  msg_pos_llh_cov:
    doc: |
      This position solution message reports the absolute geodetic coordinates
      and the status (single point vs pseudo-absolute RTK) of the position
      solution as well as the upper triangle of the 3x3 covariance matrix.
      The position information and Fix Mode flags follow the MSG_POS_LLH
      message.  Since the covariance matrix is computed in the local-level
      North, East, Down frame, the covariance terms follow that convention.
      Thus, covariances are reported against the "downward" measurement and
      care should be taken with the sign convention.

      The values in this message are from GNSS measurements fused with
      inertial measurements. To get values from GNSS measurements only use
      MSG_POS_LLH_COV_GNSS.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: lat
        type: f8
        doc: Latitude
      - id: lon
        type: f8
        doc: Longitude
      - id: height
        type: f8
        doc: Height above WGS84 ellipsoid
      - id: cov_n_n
        type: f4
        doc: Estimated variance of northing
      - id: cov_n_e
        type: f4
        doc: Covariance of northing and easting
      - id: cov_n_d
        type: f4
        doc: Covariance of northing and downward measurement
      - id: cov_e_e
        type: f4
        doc: Estimated variance of easting
      - id: cov_e_d
        type: f4
        doc: Covariance of easting and downward measurement
      - id: cov_d_d
        type: f4
        doc: Estimated variance of downward measurement
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution.
      - id: flags
        type: u1
        doc: Status flags
  
  estimated_horizontal_error_ellipse:
    seq:
      - id: semi_major
        type: f4
        doc: |
          The semi major axis of the estimated horizontal error ellipse at the
          user-configured confidence level; zero implies invalid.
      - id: semi_minor
        type: f4
        doc: |
          The semi minor axis of the estimated horizontal error ellipse at the
          user-configured confidence level; zero implies invalid.
      - id: orientation
        type: f4
        doc: |
          The orientation of the semi major axis of the estimated horizontal
          error ellipse with respect to North.
  
  msg_pos_llh_acc:
    doc: |
      This position solution message reports the absolute geodetic coordinates
      and the status (single point vs pseudo-absolute RTK) of the position
      solution as well as the estimated horizontal, vertical, cross-track and
      along-track errors.  The position information and Fix Mode flags  follow
      the MSG_POS_LLH message. Since the covariance matrix is computed in the
      local-level North, East, Down frame, the estimated error terms follow
      that convention.

      The estimated errors are reported at a user-configurable confidence
      level. The user-configured percentile is encoded in the percentile
      field.

      The values in this message are from GNSS measurements fused with
      inertial measurements.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: lat
        type: f8
        doc: Latitude
      - id: lon
        type: f8
        doc: Longitude
      - id: height
        type: f8
        doc: Height above WGS84 ellipsoid
      - id: orthometric_height
        type: f8
        doc: |
          Height above the geoid (i.e. height above mean sea level). See
          confidence_and_geoid for geoid model used.
      - id: h_accuracy
        type: f4
        doc: |
          Estimated horizontal error at the user-configured confidence level;
          zero implies invalid.
      - id: v_accuracy
        type: f4
        doc: |
          Estimated vertical error at the user-configured confidence level;
          zero implies invalid.
      - id: ct_accuracy
        type: f4
        doc: |
          Estimated cross-track error at the user-configured confidence level;
          zero implies invalid.
      - id: at_accuracy
        type: f4
        doc: |
          Estimated along-track error at the user-configured confidence level;
          zero implies invalid.
      - id: h_ellipse
        type: estimated_horizontal_error_ellipse
        doc: |
          The estimated horizontal error ellipse at the user-configured
          confidence level.
      - id: confidence_and_geoid
        type: u1
        doc: |
          The lower bits describe the configured confidence level for the
          estimated position error. The middle bits describe the geoid model
          used to calculate the orthometric height.
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution.
      - id: flags
        type: u1
        doc: Status flags
  
  msg_baseline_ecef:
    doc: |
      This message reports the baseline solution in Earth Centered Earth Fixed
      (ECEF) coordinates. This baseline is the relative vector distance from
      the base station to the rover receiver. The full GPS time is given by
      the preceding MSG_GPS_TIME with the matching time-of-week (tow).

      The values in this message are from GNSS measurements only.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: s4
        doc: Baseline ECEF X coordinate
      - id: y
        type: s4
        doc: Baseline ECEF Y coordinate
      - id: z
        type: s4
        doc: Baseline ECEF Z coordinate
      - id: accuracy
        type: u2
        doc: Position estimated standard deviation
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_baseline_ned:
    doc: |
      This message reports the baseline solution in North East Down (NED)
      coordinates. This baseline is the relative vector distance from the base
      station to the rover receiver, and NED coordinate system is defined at
      the local WGS84 tangent plane centered at the base station position.
      The full GPS time is given by the preceding MSG_GPS_TIME with the
      matching time-of-week (tow).

      The values in this message are from GNSS measurements only.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: n
        type: s4
        doc: Baseline North coordinate
      - id: e
        type: s4
        doc: Baseline East coordinate
      - id: d
        type: s4
        doc: Baseline Down coordinate
      - id: h_accuracy
        type: u2
        doc: Horizontal position estimated standard deviation
      - id: v_accuracy
        type: u2
        doc: Vertical position estimated standard deviation
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_ecef:
    doc: |
      This message reports the velocity in Earth Centered Earth Fixed (ECEF)
      coordinates. The full GPS time is given by the preceding MSG_GPS_TIME
      with the matching time-of-week (tow).

      The values in this message are from GNSS measurements fused with
      inertial measurements. To get values from GNSS measurements only use
      MSG_VEL_ECEF_GNSS.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: s4
        doc: Velocity ECEF X coordinate
      - id: y
        type: s4
        doc: Velocity ECEF Y coordinate
      - id: z
        type: s4
        doc: Velocity ECEF Z coordinate
      - id: accuracy
        type: u2
        doc: Velocity estimated standard deviation
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_ecef_cov:
    doc: |
      This message reports the velocity in Earth Centered Earth Fixed (ECEF)
      coordinates. The full GPS time is given by the preceding MSG_GPS_TIME
      with the matching time-of-week (tow).

      The values in this message are from GNSS measurements fused with
      inertial measurements. To get values from GNSS measurements only use
      MSG_VEL_ECEF_COV_GNSS.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: s4
        doc: Velocity ECEF X coordinate
      - id: y
        type: s4
        doc: Velocity ECEF Y coordinate
      - id: z
        type: s4
        doc: Velocity ECEF Z coordinate
      - id: cov_x_x
        type: f4
        doc: Estimated variance of x
      - id: cov_x_y
        type: f4
        doc: Estimated covariance of x and y
      - id: cov_x_z
        type: f4
        doc: Estimated covariance of x and z
      - id: cov_y_y
        type: f4
        doc: Estimated variance of y
      - id: cov_y_z
        type: f4
        doc: Estimated covariance of y and z
      - id: cov_z_z
        type: f4
        doc: Estimated variance of z
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_ned:
    doc: |
      This message reports the velocity in local North East Down (NED)
      coordinates. The NED coordinate system is defined as the local WGS84
      tangent plane centered at the current position. The full GPS time is
      given by the preceding MSG_GPS_TIME with the matching time-of-week
      (tow).

      The values in this message are from GNSS measurements fused with
      inertial measurements. To get values from GNSS measurements only use
      MSG_VEL_NED_GNSS.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: n
        type: s4
        doc: Velocity North coordinate
      - id: e
        type: s4
        doc: Velocity East coordinate
      - id: d
        type: s4
        doc: Velocity Down coordinate
      - id: h_accuracy
        type: u2
        doc: Horizontal velocity estimated standard deviation
      - id: v_accuracy
        type: u2
        doc: Vertical velocity estimated standard deviation
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_ned_cov:
    doc: |
      This message reports the velocity in local North East Down (NED)
      coordinates. The NED coordinate system is defined as the local WGS84
      tangent plane centered at the current position. The full GPS time is
      given by the preceding MSG_GPS_TIME with the matching time-of-week
      (tow). This message is similar to the MSG_VEL_NED, but it includes the
      upper triangular portion of the 3x3 covariance matrix.

      The values in this message are from GNSS measurements fused with
      inertial measurements. To get values from GNSS measurements only use
      MSG_VEL_NED_COV_GNSS.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: n
        type: s4
        doc: Velocity North coordinate
      - id: e
        type: s4
        doc: Velocity East coordinate
      - id: d
        type: s4
        doc: Velocity Down coordinate
      - id: cov_n_n
        type: f4
        doc: Estimated variance of northward measurement
      - id: cov_n_e
        type: f4
        doc: Covariance of northward and eastward measurement
      - id: cov_n_d
        type: f4
        doc: Covariance of northward and downward measurement
      - id: cov_e_e
        type: f4
        doc: Estimated variance of eastward measurement
      - id: cov_e_d
        type: f4
        doc: Covariance of eastward and downward measurement
      - id: cov_d_d
        type: f4
        doc: Estimated variance of downward measurement
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_pos_ecef_gnss:
    doc: |
      The position solution message reports absolute Earth Centered Earth
      Fixed (ECEF) coordinates and the status (single point vs pseudo-absolute
      RTK) of the position solution. If the rover receiver knows the surveyed
      position of the base station and has an RTK solution, this reports a
      pseudo-absolute position solution using the base station position and
      the rover's RTK baseline vector. The full GPS time is given by the
      preceding MSG_GPS_TIME_GNSS with the matching time-of-week (tow).

      The values in this message are from GNSS measurements only. To get
      values fused with inertial measurements use MSG_POS_ECEF.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: f8
        doc: ECEF X coordinate
      - id: y
        type: f8
        doc: ECEF Y coordinate
      - id: z
        type: f8
        doc: ECEF Z coordinate
      - id: accuracy
        type: u2
        doc: Position estimated standard deviation
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_pos_ecef_cov_gnss:
    doc: |
      The position solution message reports absolute Earth Centered Earth
      Fixed (ECEF) coordinates and the status (single point vs pseudo-absolute
      RTK) of the position solution. The message also reports the upper
      triangular portion of the 3x3 covariance matrix. If the receiver knows
      the surveyed position of the base station and has an RTK solution, this
      reports a pseudo-absolute position solution using the base station
      position and the rover's RTK baseline vector. The full GPS time is given
      by the preceding MSG_GPS_TIME_GNSS with the matching time-of-week (tow).

      The values in this message are from GNSS measurements only. To get
      values fused with inertial measurements use MSG_POS_ECEF_COV.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: f8
        doc: ECEF X coordinate
      - id: y
        type: f8
        doc: ECEF Y coordinate
      - id: z
        type: f8
        doc: ECEF Z coordinate
      - id: cov_x_x
        type: f4
        doc: Estimated variance of x
      - id: cov_x_y
        type: f4
        doc: Estimated covariance of x and y
      - id: cov_x_z
        type: f4
        doc: Estimated covariance of x and z
      - id: cov_y_y
        type: f4
        doc: Estimated variance of y
      - id: cov_y_z
        type: f4
        doc: Estimated covariance of y and z
      - id: cov_z_z
        type: f4
        doc: Estimated variance of z
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_pos_llh_gnss:
    doc: |
      This position solution message reports the absolute geodetic coordinates
      and the status (single point vs pseudo-absolute RTK) of the position
      solution. If the rover receiver knows the surveyed position of the base
      station and has an RTK solution, this reports a pseudo-absolute position
      solution using the base station position and the rover's RTK baseline
      vector. The full GPS time is given by the preceding MSG_GPS_TIME_GNSS
      with the matching time-of-week (tow).

      The values in this message are from GNSS measurements only. To get
      values fused with inertial measurements use MSG_POS_LLH.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: lat
        type: f8
        doc: Latitude
      - id: lon
        type: f8
        doc: Longitude
      - id: height
        type: f8
        doc: Height above WGS84 ellipsoid
      - id: h_accuracy
        type: u2
        doc: Horizontal position estimated standard deviation
      - id: v_accuracy
        type: u2
        doc: Vertical position estimated standard deviation
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution.
      - id: flags
        type: u1
        doc: Status flags
  
  msg_pos_llh_cov_gnss:
    doc: |
      This position solution message reports the absolute geodetic coordinates
      and the status (single point vs pseudo-absolute RTK) of the position
      solution as well as the upper triangle of the 3x3 covariance matrix.
      The position information and Fix Mode flags should follow the
      MSG_POS_LLH_GNSS message.  Since the covariance matrix is computed in
      the local-level North, East, Down frame, the covariance terms follow
      with that convention. Thus, covariances are reported against the
      "downward" measurement and care should be taken with the sign
      convention.

      The values in this message are from GNSS measurements only. To get
      values fused with inertial measurements use MSG_POS_LLH_COV.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: lat
        type: f8
        doc: Latitude
      - id: lon
        type: f8
        doc: Longitude
      - id: height
        type: f8
        doc: Height above WGS84 ellipsoid
      - id: cov_n_n
        type: f4
        doc: Estimated variance of northing
      - id: cov_n_e
        type: f4
        doc: Covariance of northing and easting
      - id: cov_n_d
        type: f4
        doc: Covariance of northing and downward measurement
      - id: cov_e_e
        type: f4
        doc: Estimated variance of easting
      - id: cov_e_d
        type: f4
        doc: Covariance of easting and downward measurement
      - id: cov_d_d
        type: f4
        doc: Estimated variance of downward measurement
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution.
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_ecef_gnss:
    doc: |
      This message reports the velocity in Earth Centered Earth Fixed (ECEF)
      coordinates. The full GPS time is given by the preceding
      MSG_GPS_TIME_GNSS with the matching time-of-week (tow).

      The values in this message are from GNSS measurements only. To get
      values fused with inertial measurements use MSG_VEL_ECEF.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: s4
        doc: Velocity ECEF X coordinate
      - id: y
        type: s4
        doc: Velocity ECEF Y coordinate
      - id: z
        type: s4
        doc: Velocity ECEF Z coordinate
      - id: accuracy
        type: u2
        doc: Velocity estimated standard deviation
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_ecef_cov_gnss:
    doc: |
      This message reports the velocity in Earth Centered Earth Fixed (ECEF)
      coordinates. The full GPS time is given by the preceding
      MSG_GPS_TIME_GNSS with the matching time-of-week (tow).

      The values in this message are from GNSS measurements only. To get
      values fused with inertial measurements use MSG_VEL_ECEF_COV.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: s4
        doc: Velocity ECEF X coordinate
      - id: y
        type: s4
        doc: Velocity ECEF Y coordinate
      - id: z
        type: s4
        doc: Velocity ECEF Z coordinate
      - id: cov_x_x
        type: f4
        doc: Estimated variance of x
      - id: cov_x_y
        type: f4
        doc: Estimated covariance of x and y
      - id: cov_x_z
        type: f4
        doc: Estimated covariance of x and z
      - id: cov_y_y
        type: f4
        doc: Estimated variance of y
      - id: cov_y_z
        type: f4
        doc: Estimated covariance of y and z
      - id: cov_z_z
        type: f4
        doc: Estimated variance of z
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_ned_gnss:
    doc: |
      This message reports the velocity in local North East Down (NED)
      coordinates. The NED coordinate system is defined as the local WGS84
      tangent plane centered at the current position. The full GPS time is
      given by the preceding MSG_GPS_TIME_GNSS with the matching time-of-week
      (tow).

      The values in this message are from GNSS measurements only. To get
      values fused with inertial measurements use MSG_VEL_NED.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: n
        type: s4
        doc: Velocity North coordinate
      - id: e
        type: s4
        doc: Velocity East coordinate
      - id: d
        type: s4
        doc: Velocity Down coordinate
      - id: h_accuracy
        type: u2
        doc: Horizontal velocity estimated standard deviation
      - id: v_accuracy
        type: u2
        doc: Vertical velocity estimated standard deviation
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_ned_cov_gnss:
    doc: |
      This message reports the velocity in local North East Down (NED)
      coordinates. The NED coordinate system is defined as the local WGS84
      tangent plane centered at the current position. The full GPS time is
      given by the preceding MSG_GPS_TIME_GNSS with the matching time-of-week
      (tow). This message is similar to the MSG_VEL_NED_GNSS, but it includes
      the upper triangular portion of the 3x3 covariance matrix.

      The values in this message are from GNSS measurements only. To get
      values fused with inertial measurements use MSG_VEL_NED_COV.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: n
        type: s4
        doc: Velocity North coordinate
      - id: e
        type: s4
        doc: Velocity East coordinate
      - id: d
        type: s4
        doc: Velocity Down coordinate
      - id: cov_n_n
        type: f4
        doc: Estimated variance of northward measurement
      - id: cov_n_e
        type: f4
        doc: Covariance of northward and eastward measurement
      - id: cov_n_d
        type: f4
        doc: Covariance of northward and downward measurement
      - id: cov_e_e
        type: f4
        doc: Estimated variance of eastward measurement
      - id: cov_e_d
        type: f4
        doc: Covariance of eastward and downward measurement
      - id: cov_d_d
        type: f4
        doc: Estimated variance of downward measurement
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_body:
    doc: |
      This message reports the velocity in the Vehicle Body Frame. By
      convention, the x-axis should point out the nose of the vehicle and
      represent the forward direction, while as the y-axis should point out
      the right hand side of the vehicle. Since this is a right handed system,
      z should point out the bottom of the vehicle. The orientation and origin
      of the Vehicle Body Frame are specified via the device settings. The
      full GPS time is given by the preceding MSG_GPS_TIME with the matching
      time-of-week (tow). This message is only produced by inertial versions
      of Swift products and is not available from Piksi Multi or Duro.

      The values in this message are from GNSS measurements fused with
      inertial measurements.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: s4
        doc: Velocity in x direction
      - id: y
        type: s4
        doc: Velocity in y direction
      - id: z
        type: s4
        doc: Velocity in z direction
      - id: cov_x_x
        type: f4
        doc: Estimated variance of x
      - id: cov_x_y
        type: f4
        doc: Covariance of x and y
      - id: cov_x_z
        type: f4
        doc: Covariance of x and z
      - id: cov_y_y
        type: f4
        doc: Estimated variance of y
      - id: cov_y_z
        type: f4
        doc: Covariance of y and z
      - id: cov_z_z
        type: f4
        doc: Estimated variance of z
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_cog:
    doc: |
      This message reports the receiver course over ground (COG) and speed
      over ground (SOG) based on the horizontal (N-E) components of the NED
      velocity vector. It also includes the vertical velocity coordinate. A
      flag is provided to indicate whether the COG value has been frozen. When
      the flag is set to true, the COG field is set to its last valid value
      until the system exceeds a minimum velocity threshold. No other fields
      are affected by this flag. The NED coordinate system is defined as the
      local WGS84 tangent plane centered at the current position. The full GPS
      time is given by the preceding MSG_GPS_TIME with the matching time-of-
      week (tow). Note: course over ground represents the receiver's direction
      of travel, but not necessarily the device heading.

      The values in this message are from GNSS measurements fused with
      inertial measurements.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: cog
        type: u4
        doc: Course over ground relative to north direction
      - id: sog
        type: u4
        doc: Speed over ground (based on horizontal velocity)
      - id: v_up
        type: s4
        doc: Vertical velocity component (positive up)
      - id: cog_accuracy
        type: u4
        doc: Course over ground estimated standard deviation
      - id: sog_accuracy
        type: u4
        doc: Speed over ground estimated standard deviation
      - id: v_up_accuracy
        type: u4
        doc: Vertical velocity estimated standard deviation
      - id: flags
        type: u2
        doc: Status flags
  
  msg_age_corrections:
    doc: |
      This message reports the Age of the corrections used for the current
      Differential solution.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: age
        type: u2
        doc: Age of the corrections (0xFFFF indicates invalid)
  
  msg_gps_time_dep_a:
    doc: Deprecated.
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
        doc: Status flags (reserved)
  
  msg_dops_dep_a:
    doc: Deprecated.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: gdop
        type: u2
        doc: Geometric Dilution of Precision
      - id: pdop
        type: u2
        doc: Position Dilution of Precision
      - id: tdop
        type: u2
        doc: Time Dilution of Precision
      - id: hdop
        type: u2
        doc: Horizontal Dilution of Precision
      - id: vdop
        type: u2
        doc: Vertical Dilution of Precision
  
  msg_pos_ecef_dep_a:
    doc: Deprecated.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: f8
        doc: ECEF X coordinate
      - id: y
        type: f8
        doc: ECEF Y coordinate
      - id: z
        type: f8
        doc: ECEF Z coordinate
      - id: accuracy
        type: u2
        doc: Position accuracy estimate (not implemented). Defaults to 0.
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_pos_llh_dep_a:
    doc: Deprecated.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: lat
        type: f8
        doc: Latitude
      - id: lon
        type: f8
        doc: Longitude
      - id: height
        type: f8
        doc: Height
      - id: h_accuracy
        type: u2
        doc: |
          Horizontal position accuracy estimate (not implemented). Defaults to
          0.
      - id: v_accuracy
        type: u2
        doc: |
          Vertical position accuracy estimate (not implemented). Defaults to
          0.
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution.
      - id: flags
        type: u1
        doc: Status flags
  
  msg_baseline_ecef_dep_a:
    doc: Deprecated.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: s4
        doc: Baseline ECEF X coordinate
      - id: y
        type: s4
        doc: Baseline ECEF Y coordinate
      - id: z
        type: s4
        doc: Baseline ECEF Z coordinate
      - id: accuracy
        type: u2
        doc: Position accuracy estimate
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_baseline_ned_dep_a:
    doc: Deprecated.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: n
        type: s4
        doc: Baseline North coordinate
      - id: e
        type: s4
        doc: Baseline East coordinate
      - id: d
        type: s4
        doc: Baseline Down coordinate
      - id: h_accuracy
        type: u2
        doc: |
          Horizontal position accuracy estimate (not implemented). Defaults to
          0.
      - id: v_accuracy
        type: u2
        doc: |
          Vertical position accuracy estimate (not implemented). Defaults to
          0.
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_vel_ecef_dep_a:
    doc: Deprecated.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: x
        type: s4
        doc: Velocity ECEF X coordinate
      - id: y
        type: s4
        doc: Velocity ECEF Y coordinate
      - id: z
        type: s4
        doc: Velocity ECEF Z coordinate
      - id: accuracy
        type: u2
        doc: Velocity accuracy estimate (not implemented). Defaults to 0.
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags (reserved)
  
  msg_vel_ned_dep_a:
    doc: Deprecated.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: n
        type: s4
        doc: Velocity North coordinate
      - id: e
        type: s4
        doc: Velocity East coordinate
      - id: d
        type: s4
        doc: Velocity Down coordinate
      - id: h_accuracy
        type: u2
        doc: |
          Horizontal velocity accuracy estimate (not implemented). Defaults to
          0.
      - id: v_accuracy
        type: u2
        doc: |
          Vertical velocity accuracy estimate (not implemented). Defaults to
          0.
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags (reserved)
  
  msg_baseline_heading_dep_a:
    doc: Deprecated.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: heading
        type: u4
        doc: Heading
      - id: n_sats
        type: u1
        doc: Number of satellites used in solution
      - id: flags
        type: u1
        doc: Status flags
  
  msg_protection_level_dep_a:
    doc: Deprecated.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: vpl
        type: u2
        doc: Vertical protection level
      - id: hpl
        type: u2
        doc: Horizontal protection level
      - id: lat
        type: f8
        doc: Latitude
      - id: lon
        type: f8
        doc: Longitude
      - id: height
        type: f8
        doc: Height
      - id: flags
        type: u1
        doc: Status flags
  
  msg_protection_level:
    doc: |
      This message reports the protection levels associated to the given state
      estimate. The full GPS time is given by the preceding MSG_GPS_TIME with
      the matching time-of-week (tow).
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: wn
        type: s2
        doc: GPS week number
      - id: hpl
        type: u2
        doc: Horizontal protection level
      - id: vpl
        type: u2
        doc: Vertical protection level
      - id: atpl
        type: u2
        doc: Along-track position error protection level
      - id: ctpl
        type: u2
        doc: Cross-track position error protection level
      - id: hvpl
        type: u2
        doc: |
          Protection level for the error vector between estimated and true
          along/cross track velocity vector
      - id: vvpl
        type: u2
        doc: |
          Protection level for the velocity in vehicle upright direction
          (different from vertical direction if on a slope)
      - id: hopl
        type: u2
        doc: Heading orientation protection level
      - id: popl
        type: u2
        doc: Pitch orientation protection level
      - id: ropl
        type: u2
        doc: Roll orientation protection level
      - id: lat
        type: f8
        doc: Latitude
      - id: lon
        type: f8
        doc: Longitude
      - id: height
        type: f8
        doc: Height
      - id: v_x
        type: s4
        doc: Velocity in vehicle x direction
      - id: v_y
        type: s4
        doc: Velocity in vehicle y direction
      - id: v_z
        type: s4
        doc: Velocity in vehicle z direction
      - id: roll
        type: s4
        doc: Roll angle
      - id: pitch
        type: s4
        doc: Pitch angle
      - id: heading
        type: s4
        doc: Heading angle
      - id: flags
        type: u4
        doc: Status flags
  
  msg_utc_leap_second:
    doc: |
      UTC-GPST leap seconds before and after the most recent (past, or future,
      for announced insertions) UTC leap second insertion.
    seq:
      - id: reserved_0
        type: s2
        doc: Reserved.
      - id: reserved_1
        type: s2
        doc: Reserved.
      - id: reserved_2
        type: s1
        doc: Reserved.
      - id: count_before
        type: s1
        doc: Leap second count before insertion.
      - id: reserved_3
        type: u2
        doc: Reserved.
      - id: reserved_4
        type: u2
        doc: Reserved.
      - id: ref_wn
        type: u2
        doc: Leap second reference GPS week number.
      - id: ref_dn
        type: u1
        doc: Leap second reference day number.
      - id: count_after
        type: s1
        doc: Leap second count after insertion.
  
  msg_reference_frame_param:
    seq:
      - id: ssr_iod
        type: u1
        doc: SSR IOD parameter.
      - id: sn
        size: 32
        type: str
        encoding: ASCII
        doc: Name of source coordinate-system.
      - id: tn
        size: 32
        type: str
        encoding: ASCII
        doc: Name of target coordinate-system.
      - id: sin
        type: u1
        doc: System Identification Number.
      - id: utn
        type: u2
        doc: Utilized Transformation Message.
      - id: re_t0
        type: u2
        doc: |
          Reference Epoch t0 for transformation parameter set given as
          Modified Julian Day (MJD) Number minus 44244 days.
      - id: delta_x0
        type: s4
        doc: Translation in X for Reference Epoch t0.
      - id: delta_y0
        type: s4
        doc: Translation in Y for Reference Epoch t0.
      - id: delta_z0
        type: s4
        doc: Translation in Z for Reference Epoch t0.
      - id: theta_01
        type: s4
        doc: Rotation around the X-axis for Reference Epoch t0.
      - id: theta_02
        type: s4
        doc: Rotation around the Y-axis for Reference Epoch t0.
      - id: theta_03
        type: s4
        doc: Rotation around the Z-axis for Reference Epoch t0.
      - id: scale
        type: s4
        doc: Scale correction for Reference Epoch t0.
      - id: dot_delta_x0
        type: s4
        doc: Rate of change of translation in X.
      - id: dot_delta_y0
        type: s4
        doc: Rate of change of translation in Y.
      - id: dot_delta_z0
        type: s4
        doc: Rate of change of translation in Z.
      - id: dot_theta_01
        type: s4
        doc: Rate of change of rotation around the X-axis.
      - id: dot_theta_02
        type: s4
        doc: Rate of change of rotation around the Y-axis.
      - id: dot_theta_03
        type: s4
        doc: Rate of change of rotation around the Z-axis.
      - id: dot_scale
        type: s2
        doc: Rate of change of scale correction.
  
  msg_pose_relative:
    doc: |
      This solution message reports the relative pose of a sensor between two
      time instances. The relative pose comprises of a rotation and a
      translation which relates the sensor (e.g. camera) frame at a given time
      (first keyframe) to the sensor frame at another time (second keyframe).
      The relative translations is a 3x1 vector described in the first
      keyframe. Relative rotation is described by a quaternion from second
      keyframe to the first keyframe.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: sensor_id
        type: u1
        doc: ID of the sensor producing this message
      - id: timestamp_1
        type: u4
        doc: Timestamp of first keyframe
      - id: timestamp_2
        type: u4
        doc: Timestamp of second keyframe
      - id: trans
        type: s4
        repeat: expr
        repeat-expr: 3
        doc: Relative translation [x,y,z] described in first keyframe
      - id: w
        type: s4
        doc: |
          Real component of quaternion to describe relative rotation (second
          to first keyframe)
      - id: x
        type: s4
        doc: |
          1st imaginary component of quaternion to describe relative rotation
          (second to first keyframe)
      - id: y
        type: s4
        doc: |
          2nd imaginary component of quaternion to describe relative rotation
          (second to first keyframe)
      - id: z
        type: s4
        doc: |
          3rd imaginary component of quaternion to describe relative rotation
          (second to first keyframe)
      - id: cov_r_x_x
        type: f4
        doc: Estimated variance of x (relative translation)
      - id: cov_r_x_y
        type: f4
        doc: Covariance of x and y (relative translation)
      - id: cov_r_x_z
        type: f4
        doc: Covariance of x and z (relative translation)
      - id: cov_r_y_y
        type: f4
        doc: Estimated variance of y (relative translation)
      - id: cov_r_y_z
        type: f4
        doc: Covariance of y and z (relative translation)
      - id: cov_r_z_z
        type: f4
        doc: Estimated variance of z (relative translation)
      - id: cov_c_x_x
        type: f4
        doc: Estimated variance of x (relative rotation)
      - id: cov_c_x_y
        type: f4
        doc: Covariance of x and y (relative rotation)
      - id: cov_c_x_z
        type: f4
        doc: Covariance of x and z (relative rotation)
      - id: cov_c_y_y
        type: f4
        doc: Estimated variance of y (relative rotation)
      - id: cov_c_y_z
        type: f4
        doc: Covariance of y and z (relative rotation)
      - id: cov_c_z_z
        type: f4
        doc: Estimated variance of z (relative rotation)
      - id: flags
        type: u1
        doc: Status flags of relative translation and rotation
  
