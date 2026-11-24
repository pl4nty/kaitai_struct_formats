meta:
  id: gps_almanac
  title: GPS LNAV almanac page
  license: LicenseRef-All-Rights-Reserved
  endian: be
  bit-endian: be
doc: |
  Almanac of one GPS satellite as broadcast in the legacy navigation message
  (LNAV): pages 1 to 24 of subframe 5 and pages 2 to 5 and 7 to 10 of
  subframe 4. The almanac is a reduced-precision subset of the clock and
  ephemeris parameters that lets a receiver find out which satellites are in
  view.

  This spec describes words 3 to 10 of such a page after the 6 parity bits
  of every 30-bit word have been removed, i.e. 8 words of 24 bits. Words 1
  and 2 (telemetry and handover word) are not part of it.

  The page of a dummy satellite (`sv_id` 0) contains alternating ones and
  zeros.
doc-ref:
  - https://www.gps.gov/technical/icwg/IS-GPS-200H.pdf Figure 20-1, Table 20-VI
  - https://github.com/tomojitakasu/RTKLIB/blob/180043ee24b6d2b168f98b64be15f69d50046b1a/src/rcvraw.c#L1090-L1118
seq:
  - id: data_id
    type: b2
    doc: Version of the navigation data structure, 1 for GPS.
  - id: sv_id
    type: b6
    doc: |
      Page identifier; on an almanac page this is the PRN number of the
      satellite (1 to 32), or 0 for a dummy satellite.
  - id: eccentricity_raw
    type: u2
  - id: reference_time_raw
    type: u1
  - id: delta_inclination_raw
    type: s2
  - id: rate_of_right_ascension_raw
    type: s2
  - id: sv_health
    type: u1
    doc: |
      The 3 high bits summarise the health of the navigation data, the 5 low
      bits the health of the signal components; 0 is fully healthy.
  - id: sqrt_semi_major_axis_raw
    type: b24
  - id: longitude_of_ascending_node_raw
    type: b24
  - id: argument_of_perigee_raw
    type: b24
  - id: mean_anomaly_raw
    type: b24
  - id: clock_bias_high
    type: b8
    doc: 8 most significant bits of the 11-bit clock bias.
  - id: clock_drift_raw
    type: b11
  - id: clock_bias_low
    type: b3
    doc: 3 least significant bits of the 11-bit clock bias.
  - id: parity_solving_bits
    type: b2
    doc: |
      Bits without information, chosen so that the parity of the word ends
      in two zeros.
instances:
  eccentricity:
    value: eccentricity_raw * 4.76837158203125e-07
    doc: e, dimensionless (scale factor 2^-21).
  reference_time:
    value: reference_time_raw * 4096
    doc: t_oa, seconds into the GPS week (scale factor 2^12).
  nominal_inclination:
    value: 0.30
    doc: i_0, semicircles.
  delta_inclination:
    value: delta_inclination_raw * 1.9073486328125e-06
    doc: delta_i, semicircles relative to i_0 (scale factor 2^-19).
  inclination:
    value: nominal_inclination + delta_inclination
    doc: i, semicircles.
  rate_of_right_ascension:
    value: rate_of_right_ascension_raw * 3.637978807091713e-12
    doc: OMEGADOT, semicircles per second (scale factor 2^-38).
  sqrt_semi_major_axis:
    value: sqrt_semi_major_axis_raw * 0.00048828125
    doc: Square root of A, in square root of meters (scale factor 2^-11).
  longitude_of_ascending_node:
    value: (longitude_of_ascending_node_raw - ((longitude_of_ascending_node_raw >> 23) << 24)) * 1.1920928955078125e-07
    doc: |
      OMEGA_0, longitude of the ascending node of the orbit plane at the
      weekly epoch, semicircles (signed, scale factor 2^-23).
  argument_of_perigee:
    value: (argument_of_perigee_raw - ((argument_of_perigee_raw >> 23) << 24)) * 1.1920928955078125e-07
    doc: omega, semicircles (signed, scale factor 2^-23).
  mean_anomaly:
    value: (mean_anomaly_raw - ((mean_anomaly_raw >> 23) << 24)) * 1.1920928955078125e-07
    doc: |
      M_0, mean anomaly at the reference time, semicircles (signed, scale factor
      2^-23).
  clock_bias_raw:
    value: (clock_bias_high << 3) | clock_bias_low
  clock_bias:
    value: (clock_bias_raw - ((clock_bias_raw >> 10) << 11)) * 9.5367431640625e-07
    doc: a_f0, seconds (signed, scale factor 2^-20).
  clock_drift:
    value: (clock_drift_raw - ((clock_drift_raw >> 10) << 11)) * 3.637978807091713e-12
    doc: a_f1, seconds per second (signed, scale factor 2^-38).
