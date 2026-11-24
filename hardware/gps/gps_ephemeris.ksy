meta:
  id: gps_ephemeris
  title: GPS CNAV ephemeris messages
  license: LicenseRef-All-Rights-Reserved
  endian: be
  bit-endian: be
doc: |
  Ephemeris of a GPS satellite as broadcast in the civil navigation message
  (CNAV) on the L2C and L5 signals. The orbit is split over two messages,
  type 10 ("Ephemeris 1") and type 11 ("Ephemeris 2"), which belong together
  if their `ephemeris_time` is the same.

  A CNAV message is 300 bits long. This spec describes one message after the
  forward error correction has been removed, stored most significant bit
  first in 38 bytes, i.e. followed by 4 padding bits. Messages of other
  types are not parsed.

  Signed values are two's complement numbers. Angles are given in
  semicircles, as in the interface specification; multiply by pi to get
  radians.
doc-ref:
  - https://www.gps.gov/technical/icwg/IS-GPS-200H.pdf Figures 30-1 and 30-2, Table 30-I
  - https://github.com/gnss-sdr/gnss-sdr/blob/main/src/core/system_parameters/GPS_CNAV.h
seq:
  - id: message
    type:
      switch-on: message_type
      cases:
        10: ephemeris1
        11: ephemeris2
instances:
  header_peek:
    pos: 1
    type: u2
  message_type:
    value: (header_peek >> 4) & 0x3f
    doc: |
      Bits 15 to 20 of the message, read ahead because a bit field cannot
      continue across the boundary of a type.
types:
  ephemeris1:
    seq:
      - id: preamble
        type: b8
        valid: 0x8b
      - id: prn
        type: b6
        doc: PRN number of the transmitting satellite.
      - id: message_type
        type: b6
      - id: tow_count
        type: b17
        doc: |
          Time of week at the start of the next message, in units of 6
          seconds.
      - id: is_alert
        type: b1
        doc: |
          Set if the signal accuracy may be worse than indicated, so that the
          satellite is used at the user's own risk.
      - id: week_number
        type: b13
        doc: GPS week number, modulo 8192.
      - id: is_l1_unhealthy
        type: b1
        doc: Set if the L1 signal is bad or unavailable.
      - id: is_l2_unhealthy
        type: b1
        doc: Set if the L2 signal is bad or unavailable.
      - id: is_l5_unhealthy
        type: b1
        doc: Set if the L5 signal is bad or unavailable.
      - id: data_predict_time_raw
        type: b11
      - id: ura_ed_index_raw
        type: b5
      - id: ephemeris_time_raw
        type: b11
      - id: delta_a_raw
        type: b26
      - id: a_dot_raw
        type: b25
      - id: delta_n0_raw
        type: b17
      - id: delta_n0_dot_raw
        type: b23
      - id: mean_anomaly_raw
        type: b33
      - id: eccentricity_raw
        type: b33
      - id: argument_of_perigee_raw
        type: b33
      - id: integrity_status_flag
        type: b1
        doc: |
          Set if the satellite provides the enhanced level of integrity
          assurance.
      - id: l2c_phasing_flag
        type: b1
        doc: |
          Tells whether the L2C signal is in phase with the L2 P(Y) signal or
          in phase quadrature with it.
      - id: reserved
        type: b3
      - id: crc
        type: b24
        doc: CRC-24Q of the preceding 276 bits.
      - id: padding
        type: b4
        doc: Fills the 300-bit message up to 38 bytes.
    instances:
      ura_ed_index:
        value: ura_ed_index_raw - ((ura_ed_index_raw >> 4) << 5)
        doc: |
          Elevation-dependent user range accuracy index, -16 to 15; 15 means
          that no accuracy prediction is available.
      a_ref:
        value: 26559710
        doc: Reference semi-major axis, meters.
      semi_major_axis:
        value: a_ref + delta_a
        doc: A_0, semi-major axis at the reference time, meters.
      data_predict_time:
        value: data_predict_time_raw * 300
        doc: |
          t_op, time of week the prediction was made at, seconds (scale factor
          300).
      ephemeris_time:
        value: ephemeris_time_raw * 300
        doc: |
          t_oe, reference time of week of the ephemeris, seconds (scale factor
          300).
      delta_a:
        value: (delta_a_raw - ((delta_a_raw >> 25) << 26)) * 0.001953125
        doc: |
          Difference of the semi-major axis at the reference time from
          `a_ref`, meters (signed, scale factor 2^-9).
      a_dot:
        value: (a_dot_raw - ((a_dot_raw >> 24) << 25)) * 4.76837158203125e-07
        doc: |
          Rate of change of the semi-major axis, meters per second (signed,
          scale factor 2^-21).
      delta_n0:
        value: (delta_n0_raw - ((delta_n0_raw >> 16) << 17)) * 5.684341886080802e-14
        doc: |
          Difference of the mean motion from its computed value at the
          reference time, semicircles per second (signed, scale factor 2^-44).
      delta_n0_dot:
        value: (delta_n0_dot_raw - ((delta_n0_dot_raw >> 22) << 23)) * 6.938893903907228e-18
        doc: |
          Rate of the mean motion difference, semicircles per second squared
          (signed, scale factor 2^-57).
      mean_anomaly:
        value: (mean_anomaly_raw - ((mean_anomaly_raw >> 32) << 33)) * 2.3283064365386963e-10
        doc: |
          M_0-n, mean anomaly at the reference time, semicircles (signed,
          scale factor 2^-32).
      eccentricity:
        value: eccentricity_raw * 5.820766091346741e-11
        doc: e_n, dimensionless (scale factor 2^-34).
      argument_of_perigee:
        value: (argument_of_perigee_raw - ((argument_of_perigee_raw >> 32) << 33)) * 2.3283064365386963e-10
        doc: omega_n, semicircles (signed, scale factor 2^-32).
  ephemeris2:
    seq:
      - id: preamble
        type: b8
        valid: 0x8b
      - id: prn
        type: b6
        doc: PRN number of the transmitting satellite.
      - id: message_type
        type: b6
      - id: tow_count
        type: b17
        doc: |
          Time of week at the start of the next message, in units of 6
          seconds.
      - id: is_alert
        type: b1
        doc: |
          Set if the signal accuracy may be worse than indicated, so that the
          satellite is used at the user's own risk.
      - id: ephemeris_time_raw
        type: b11
      - id: longitude_of_ascending_node_raw
        type: b33
      - id: inclination_raw
        type: b33
      - id: delta_omega_dot_raw
        type: b17
      - id: inclination_rate_raw
        type: b15
      - id: c_is_raw
        type: b16
      - id: c_ic_raw
        type: b16
      - id: c_rs_raw
        type: b24
      - id: c_rc_raw
        type: b24
      - id: c_us_raw
        type: b21
      - id: c_uc_raw
        type: b21
      - id: reserved
        type: b7
      - id: crc
        type: b24
        doc: CRC-24Q of the preceding 276 bits.
      - id: padding
        type: b4
        doc: Fills the 300-bit message up to 38 bytes.
    instances:
      omega_dot_ref:
        value: -2.6e-9
        doc: Reference rate of right ascension, semicircles per second.
      ephemeris_time:
        value: ephemeris_time_raw * 300
        doc: |
          t_oe, reference time of week of the ephemeris, seconds (scale factor
          300).
      longitude_of_ascending_node:
        value: (longitude_of_ascending_node_raw - ((longitude_of_ascending_node_raw >> 32) << 33)) * 2.3283064365386963e-10
        doc: |
          OMEGA_0-n, longitude of the ascending node of the orbit plane at the
          weekly epoch, semicircles (signed, scale factor 2^-32).
      inclination:
        value: (inclination_raw - ((inclination_raw >> 32) << 33)) * 2.3283064365386963e-10
        doc: |
          i_0-n, inclination angle at the reference time, semicircles (signed,
          scale factor 2^-32).
      delta_omega_dot:
        value: (delta_omega_dot_raw - ((delta_omega_dot_raw >> 16) << 17)) * 5.684341886080802e-14
        doc: |
          Difference of the rate of right ascension from `omega_dot_ref`,
          semicircles per second (signed, scale factor 2^-44).
      inclination_rate:
        value: (inclination_rate_raw - ((inclination_rate_raw >> 14) << 15)) * 5.684341886080802e-14
        doc: |
          i_0-n-DOT, rate of the inclination angle, semicircles per second
          (signed, scale factor 2^-44).
      c_is:
        value: (c_is_raw - ((c_is_raw >> 15) << 16)) * 9.313225746154785e-10
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination, radians (signed, scale factor 2^-30).
      c_ic:
        value: (c_ic_raw - ((c_ic_raw >> 15) << 16)) * 9.313225746154785e-10
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination, radians (signed, scale factor 2^-30).
      c_rs:
        value: (c_rs_raw - ((c_rs_raw >> 23) << 24)) * 0.00390625
        doc: |
          Amplitude of the sine correction term to the orbit radius, meters
          (signed, scale factor 2^-8).
      c_rc:
        value: (c_rc_raw - ((c_rc_raw >> 23) << 24)) * 0.00390625
        doc: |
          Amplitude of the cosine correction term to the orbit radius, meters
          (signed, scale factor 2^-8).
      c_us:
        value: (c_us_raw - ((c_us_raw >> 20) << 21)) * 9.313225746154785e-10
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude, radians (signed, scale factor 2^-30).
      c_uc:
        value: (c_uc_raw - ((c_uc_raw >> 20) << 21)) * 9.313225746154785e-10
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude, radians (signed, scale factor 2^-30).
