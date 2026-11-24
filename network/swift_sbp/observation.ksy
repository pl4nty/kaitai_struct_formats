# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/observation.ksy
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
# Satellite observation messages from the device. The SBP sender ID of 0 indicates
# remote observations from a GNSS base station, correction network, or Skylark,
# Swift's cloud GNSS correction product.
#
# Automatically generated from spec/yaml/swiftnav/sbp/observation.yaml with generate.py.
# Do not modify by hand!

meta:
  id: observation
  title: SBP observation messages
  license: MIT
  imports: [ gnss ]
  endian: le

types:

  observation_header:
    doc: Header of a GNSS observation message.
    seq:
      - id: t
        type: gnss::gps_time
        doc: GNSS time of this observation
      - id: n_obs
        type: u1
        doc: |
          Total number of observations. First nibble is the size of the
          sequence (n), second nibble is the zero-indexed counter (ith packet
          of n)
  
  doppler:
    doc: |
      Doppler measurement in Hz represented as a 24-bit fixed point number
      with Q16.8 layout, i.e. 16-bits of whole doppler and 8-bits of
      fractional doppler. This doppler is defined as positive for approaching
      satellites.
    seq:
      - id: i
        type: s2
        doc: Doppler whole Hz
      - id: f
        type: u1
        doc: Doppler fractional part
  
  packed_obs_content:
    doc: |
      Pseudorange and carrier phase observation for a satellite being tracked.
      The observations are interoperable with 3rd party receivers and conform
      with typical RTCM 3.1 message GPS/GLO observations.

      Carrier phase observations are not guaranteed to be aligned to the RINEX
      3 or RTCM 3.3 MSM reference signal and no 1/4 cycle adjustments are
      currently performed.
    seq:
      - id: p
        type: u4
        doc: Pseudorange observation
      - id: l
        type: gnss::carrier_phase
        doc: Carrier phase observation with typical sign convention.
      - id: d
        type: doppler
        doc: Doppler observation with typical sign convention.
      - id: cn0
        type: u1
        doc: Carrier-to-Noise density.  Zero implies invalid cn0.
      - id: lock
        type: u1
        doc: |
          Lock timer. This value gives an indication of the time for which a
          signal has maintained continuous phase lock. Whenever a signal has
          lost and regained lock, this value is reset to zero. It is encoded
          according to DF402 from the RTCM 10403.2 Amendment 2 specification.
          Valid values range from 0 to 15 and the most significant nibble is
          reserved for future use.
      - id: flags
        type: u1
        doc: |
          Measurement status flags. A bit field of flags providing the status
          of this observation.  If this field is 0 it means only the Cn0
          estimate for the signal is valid.
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier (16 bit)
  
  packed_osr_content:
    doc: |
      Pseudorange and carrier phase network corrections for a satellite
      signal.
    seq:
      - id: p
        type: u4
        doc: Pseudorange observation
      - id: l
        type: gnss::carrier_phase
        doc: Carrier phase observation with typical sign convention.
      - id: lock
        type: u1
        doc: |
          Lock timer. This value gives an indication of the time for which a
          signal has maintained continuous phase lock. Whenever a signal has
          lost and regained lock, this value is reset to zero. It is encoded
          according to DF402 from the RTCM 10403.2 Amendment 2 specification.
          Valid values range from 0 to 15 and the most significant nibble is
          reserved for future use.
      - id: flags
        type: u1
        doc: Correction flags.
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier (16 bit)
      - id: iono_std
        type: u2
        doc: Slant ionospheric correction standard deviation
      - id: tropo_std
        type: u2
        doc: Slant tropospheric correction standard deviation
      - id: range_std
        type: u2
        doc: Orbit/clock/bias correction projected on range standard deviation
  
  msg_obs:
    doc: |
      The GPS observations message reports all the raw pseudorange and carrier
      phase observations for the satellites being tracked by the device.
      Carrier phase observation here is represented as a 40-bit fixed point
      number with Q32.8 layout (i.e. 32-bits of whole cycles and 8-bits of
      fractional cycles). The observations are be interoperable with 3rd party
      receivers and conform with typical RTCMv3 GNSS observations.
    seq:
      - id: header
        type: observation_header
        doc: Header of a GPS observation message
      - id: obs
        type: packed_obs_content
        repeat: eos
        doc: |
          Pseudorange and carrier phase observation for a satellite being
          tracked.
  
  msg_base_pos_llh:
    doc: |
      The base station position message is the position reported by the base
      station itself. It is used for pseudo-absolute RTK positioning, and is
      required to be a high-accuracy surveyed location of the base station.
      Any error here will result in an error in the pseudo-absolute position
      output.
    seq:
      - id: lat
        type: f8
        doc: Latitude
      - id: lon
        type: f8
        doc: Longitude
      - id: height
        type: f8
        doc: Height
  
  msg_base_pos_ecef:
    doc: |
      The base station position message is the position reported by the base
      station itself in absolute Earth Centered Earth Fixed coordinates. It is
      used for pseudo-absolute RTK positioning, and is required to be a high-
      accuracy surveyed location of the base station. Any error here will
      result in an error in the pseudo-absolute position output.
    seq:
      - id: x
        type: f8
        doc: ECEF X coordinate
      - id: y
        type: f8
        doc: ECEF Y coordinate
      - id: z
        type: f8
        doc: ECEF Z coordinate
  
  ephemeris_common_content:
    seq:
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier (16 bit)
      - id: toe
        type: gnss::gps_time_sec
        doc: Time of Ephemerides
      - id: ura
        type: f4
        doc: User Range Accuracy
      - id: fit_interval
        type: u4
        doc: Curve fit interval
      - id: valid
        type: u1
        doc: Status of ephemeris, 1 = valid, 0 = invalid
      - id: health_bits
        type: u1
        doc: |
          Satellite health status.
          GPS: ICD-GPS-200, chapter 20.3.3.3.1.4
          SBAS: 0 = valid, non-zero = invalid
          GLO: 0 = valid, non-zero = invalid
  
  ephemeris_common_content_dep_b:
    seq:
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier (16 bit)
      - id: toe
        type: gnss::gps_time_sec
        doc: Time of Ephemerides
      - id: ura
        type: f8
        doc: User Range Accuracy
      - id: fit_interval
        type: u4
        doc: Curve fit interval
      - id: valid
        type: u1
        doc: Status of ephemeris, 1 = valid, 0 = invalid
      - id: health_bits
        type: u1
        doc: |
          Satellite health status.
          GPS: ICD-GPS-200, chapter 20.3.3.3.1.4
          Others: 0 = valid, non-zero = invalid
  
  ephemeris_common_content_dep_a:
    seq:
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal identifier
      - id: toe
        type: gnss::gps_time_dep
        doc: Time of Ephemerides
      - id: ura
        type: f8
        doc: User Range Accuracy
      - id: fit_interval
        type: u4
        doc: Curve fit interval
      - id: valid
        type: u1
        doc: Status of ephemeris, 1 = valid, 0 = invalid
      - id: health_bits
        type: u1
        doc: |
          Satellite health status.
          GPS: ICD-GPS-200, chapter 20.3.3.3.1.4
          SBAS: 0 = valid, non-zero = invalid
          GLO: 0 = valid, non-zero = invalid
  
  msg_ephemeris_gps_dep_e:
    doc: Deprecated.
    seq:
      - id: common
        type: ephemeris_common_content_dep_a
        doc: Values common for all ephemeris types
      - id: tgd
        type: f8
        doc: Group delay differential between L1 and L2
      - id: c_rs
        type: f8
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f8
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f8
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f8
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toc
        type: gnss::gps_time_dep
        doc: Clock reference
      - id: iode
        type: u1
        doc: Issue of ephemeris data
      - id: iodc
        type: u2
        doc: Issue of clock data
  
  msg_ephemeris_gps_dep_f:
    doc: Deprecated.
    seq:
      - id: common
        type: ephemeris_common_content_dep_b
        doc: Values common for all ephemeris types
      - id: tgd
        type: f8
        doc: Group delay differential between L1 and L2
      - id: c_rs
        type: f8
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f8
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f8
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f8
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toc
        type: gnss::gps_time_sec
        doc: Clock reference
      - id: iode
        type: u1
        doc: Issue of ephemeris data
      - id: iodc
        type: u2
        doc: Issue of clock data
  
  msg_ephemeris_gps:
    doc: |
      The ephemeris message returns a set of satellite orbit parameters that
      is used to calculate GPS satellite position, velocity, and clock offset.
      Please see the Navstar GPS Space Segment/Navigation user interfaces
      (ICD-GPS-200, Table 20-III) for more details.
    seq:
      - id: common
        type: ephemeris_common_content
        doc: Values common for all ephemeris types
      - id: tgd
        type: f4
        doc: Group delay differential between L1 and L2
      - id: c_rs
        type: f4
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f4
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f4
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f4
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f4
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f4
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f4
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f4
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f4
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toc
        type: gnss::gps_time_sec
        doc: Clock reference
      - id: iode
        type: u1
        doc: Issue of ephemeris data
      - id: iodc
        type: u2
        doc: Issue of clock data
  
  msg_ephemeris_qzss:
    doc: |
      The ephemeris message returns a set of satellite orbit parameters that
      is used to calculate QZSS satellite position, velocity, and clock
      offset.
    seq:
      - id: common
        type: ephemeris_common_content
        doc: Values common for all ephemeris types
      - id: tgd
        type: f4
        doc: Group delay differential between L1 and L2
      - id: c_rs
        type: f4
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f4
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f4
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f4
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f4
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f4
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f4
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f4
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f4
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toc
        type: gnss::gps_time_sec
        doc: Clock reference
      - id: iode
        type: u1
        doc: Issue of ephemeris data
      - id: iodc
        type: u2
        doc: Issue of clock data
  
  msg_ephemeris_bds:
    doc: |
      The ephemeris message returns a set of satellite orbit parameters that
      is used to calculate BDS satellite position, velocity, and clock offset.
      Please see the BeiDou Navigation Satellite System SIS-ICD Version 2.1,
      Table 5-9 for more details.
    seq:
      - id: common
        type: ephemeris_common_content
        doc: Values common for all ephemeris types
      - id: tgd1
        type: f4
        doc: Group delay differential for B1
      - id: tgd2
        type: f4
        doc: Group delay differential for B2
      - id: c_rs
        type: f4
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f4
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f4
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f4
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f4
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f4
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f4
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f4
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toc
        type: gnss::gps_time_sec
        doc: Clock reference
      - id: iode
        type: u1
        doc: |
          Issue of ephemeris data
          Calculated from the navigation data parameter t_oe per RTCM/CSNO
          recommendation: IODE = mod (t_oe / 720, 240)
      - id: iodc
        type: u2
        doc: |
          Issue of clock data
          Calculated from the navigation data parameter t_oe per RTCM/CSNO
          recommendation: IODE = mod (t_oc / 720, 240)
  
  msg_ephemeris_gal_dep_a:
    doc: Deprecated.
    seq:
      - id: common
        type: ephemeris_common_content
        doc: Values common for all ephemeris types
      - id: bgd_e1e5a
        type: f4
        doc: E1-E5a Broadcast Group Delay
      - id: bgd_e1e5b
        type: f4
        doc: E1-E5b Broadcast Group Delay
      - id: c_rs
        type: f4
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f4
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f4
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f4
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f4
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f4
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f8
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f4
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toc
        type: gnss::gps_time_sec
        doc: Clock reference
      - id: iode
        type: u2
        doc: Issue of data (IODnav)
      - id: iodc
        type: u2
        doc: Issue of data (IODnav). Always equal to iode
  
  msg_ephemeris_gal:
    doc: |
      The ephemeris message returns a set of satellite orbit parameters that
      is used to calculate Galileo satellite position, velocity, and clock
      offset. Please see the Signal In Space ICD OS SIS ICD, Issue 1.3,
      December 2016 for more details.
    seq:
      - id: common
        type: ephemeris_common_content
        doc: Values common for all ephemeris types
      - id: bgd_e1e5a
        type: f4
        doc: E1-E5a Broadcast Group Delay
      - id: bgd_e1e5b
        type: f4
        doc: E1-E5b Broadcast Group Delay
      - id: c_rs
        type: f4
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f4
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f4
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f4
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f4
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f4
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f8
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f4
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toc
        type: gnss::gps_time_sec
        doc: Clock reference
      - id: iode
        type: u2
        doc: Issue of data (IODnav)
      - id: iodc
        type: u2
        doc: Issue of data (IODnav). Always equal to iode
      - id: source
        type: u1
        doc: 0=I/NAV, 1=F/NAV
  
  msg_ephemeris_sbas_dep_a:
    doc: Deprecated.
    seq:
      - id: common
        type: ephemeris_common_content_dep_a
        doc: Values common for all ephemeris types
      - id: pos
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Position of the GEO at time toe
      - id: vel
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Velocity of the GEO at time toe
      - id: acc
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Acceleration of the GEO at time toe
      - id: a_gf0
        type: f8
        doc: Time offset of the GEO clock w.r.t. SBAS Network Time
      - id: a_gf1
        type: f8
        doc: Drift of the GEO clock w.r.t. SBAS Network Time
  
  msg_ephemeris_glo_dep_a:
    doc: Deprecated.
    seq:
      - id: common
        type: ephemeris_common_content_dep_a
        doc: Values common for all ephemeris types
      - id: gamma
        type: f8
        doc: Relative deviation of predicted carrier frequency from nominal
      - id: tau
        type: f8
        doc: Correction to the SV time
      - id: pos
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Position of the SV at tb in PZ-90.02 coordinates system
      - id: vel
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Velocity vector of the SV at tb in PZ-90.02 coordinates system
      - id: acc
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Acceleration vector of the SV at tb in PZ-90.02 coordinates sys
  
  msg_ephemeris_sbas_dep_b:
    doc: Deprecated.
    seq:
      - id: common
        type: ephemeris_common_content_dep_b
        doc: Values common for all ephemeris types
      - id: pos
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Position of the GEO at time toe
      - id: vel
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Velocity of the GEO at time toe
      - id: acc
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Acceleration of the GEO at time toe
      - id: a_gf0
        type: f8
        doc: Time offset of the GEO clock w.r.t. SBAS Network Time
      - id: a_gf1
        type: f8
        doc: Drift of the GEO clock w.r.t. SBAS Network Time
  
  msg_ephemeris_sbas:
    seq:
      - id: common
        type: ephemeris_common_content
        doc: Values common for all ephemeris types
      - id: pos
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Position of the GEO at time toe
      - id: vel
        type: f4
        repeat: expr
        repeat-expr: 3
        doc: Velocity of the GEO at time toe
      - id: acc
        type: f4
        repeat: expr
        repeat-expr: 3
        doc: Acceleration of the GEO at time toe
      - id: a_gf0
        type: f4
        doc: Time offset of the GEO clock w.r.t. SBAS Network Time
      - id: a_gf1
        type: f4
        doc: Drift of the GEO clock w.r.t. SBAS Network Time
  
  msg_ephemeris_glo_dep_b:
    doc: Deprecated.
    seq:
      - id: common
        type: ephemeris_common_content_dep_b
        doc: Values common for all ephemeris types
      - id: gamma
        type: f8
        doc: Relative deviation of predicted carrier frequency from nominal
      - id: tau
        type: f8
        doc: Correction to the SV time
      - id: pos
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Position of the SV at tb in PZ-90.02 coordinates system
      - id: vel
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Velocity vector of the SV at tb in PZ-90.02 coordinates system
      - id: acc
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Acceleration vector of the SV at tb in PZ-90.02 coordinates sys
  
  msg_ephemeris_glo_dep_c:
    doc: |
      The ephemeris message returns a set of satellite orbit parameters that
      is used to calculate GLO satellite position, velocity, and clock offset.
      Please see the GLO ICD 5.1 "Table 4.5 Characteristics of words of
      immediate information (ephemeris parameters)" for more details.
    seq:
      - id: common
        type: ephemeris_common_content_dep_b
        doc: Values common for all ephemeris types
      - id: gamma
        type: f8
        doc: Relative deviation of predicted carrier frequency from nominal
      - id: tau
        type: f8
        doc: Correction to the SV time
      - id: d_tau
        type: f8
        doc: Equipment delay between L1 and L2
      - id: pos
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Position of the SV at tb in PZ-90.02 coordinates system
      - id: vel
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Velocity vector of the SV at tb in PZ-90.02 coordinates system
      - id: acc
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Acceleration vector of the SV at tb in PZ-90.02 coordinates sys
      - id: fcn
        type: u1
        doc: Frequency slot. FCN+8 (that is [1..14]). 0 or 0xFF for invalid
  
  msg_ephemeris_glo_dep_d:
    doc: |
      This observation message has been deprecated in favor of ephemeris
      message using floats for size reduction.
    seq:
      - id: common
        type: ephemeris_common_content_dep_b
        doc: Values common for all ephemeris types
      - id: gamma
        type: f8
        doc: Relative deviation of predicted carrier frequency from nominal
      - id: tau
        type: f8
        doc: Correction to the SV time
      - id: d_tau
        type: f8
        doc: Equipment delay between L1 and L2
      - id: pos
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Position of the SV at tb in PZ-90.02 coordinates system
      - id: vel
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Velocity vector of the SV at tb in PZ-90.02 coordinates system
      - id: acc
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Acceleration vector of the SV at tb in PZ-90.02 coordinates sys
      - id: fcn
        type: u1
        doc: Frequency slot. FCN+8 (that is [1..14]). 0 or 0xFF for invalid
      - id: iod
        type: u1
        doc: Issue of data. Equal to the 7 bits of the immediate data word t_b
  
  msg_ephemeris_glo:
    doc: |
      The ephemeris message returns a set of satellite orbit parameters that
      is used to calculate GLO satellite position, velocity, and clock offset.
      Please see the GLO ICD 5.1 "Table 4.5 Characteristics of words of
      immediate information (ephemeris parameters)" for more details.
    seq:
      - id: common
        type: ephemeris_common_content
        doc: Values common for all ephemeris types
      - id: gamma
        type: f4
        doc: Relative deviation of predicted carrier frequency from nominal
      - id: tau
        type: f4
        doc: Correction to the SV time
      - id: d_tau
        type: f4
        doc: Equipment delay between L1 and L2
      - id: pos
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Position of the SV at tb in PZ-90.02 coordinates system
      - id: vel
        type: f8
        repeat: expr
        repeat-expr: 3
        doc: Velocity vector of the SV at tb in PZ-90.02 coordinates system
      - id: acc
        type: f4
        repeat: expr
        repeat-expr: 3
        doc: Acceleration vector of the SV at tb in PZ-90.02 coordinates sys
      - id: fcn
        type: u1
        doc: Frequency slot. FCN+8 (that is [1..14]). 0 or 0xFF for invalid
      - id: iod
        type: u1
        doc: Issue of data. Equal to the 7 bits of the immediate data word t_b
  
  msg_ephemeris_dep_d:
    doc: Deprecated.
    seq:
      - id: tgd
        type: f8
        doc: Group delay differential between L1 and L2
      - id: c_rs
        type: f8
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f8
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f8
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f8
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toe_tow
        type: f8
        doc: Time of week
      - id: toe_wn
        type: u2
        doc: Week number
      - id: toc_tow
        type: f8
        doc: Clock reference time of week
      - id: toc_wn
        type: u2
        doc: Clock reference week number
      - id: valid
        type: u1
        doc: Is valid?
      - id: healthy
        type: u1
        doc: Satellite is healthy?
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal identifier
      - id: iode
        type: u1
        doc: Issue of ephemeris data
      - id: iodc
        type: u2
        doc: Issue of clock data
      - id: reserved
        type: u4
        doc: Reserved field
  
  msg_ephemeris_dep_a:
    doc: Deprecated.
    seq:
      - id: tgd
        type: f8
        doc: Group delay differential between L1 and L2
      - id: c_rs
        type: f8
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f8
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f8
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f8
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toe_tow
        type: f8
        doc: Time of week
      - id: toe_wn
        type: u2
        doc: Week number
      - id: toc_tow
        type: f8
        doc: Clock reference time of week
      - id: toc_wn
        type: u2
        doc: Clock reference week number
      - id: valid
        type: u1
        doc: Is valid?
      - id: healthy
        type: u1
        doc: Satellite is healthy?
      - id: prn
        type: u1
        doc: PRN being tracked
  
  msg_ephemeris_dep_b:
    doc: Deprecated.
    seq:
      - id: tgd
        type: f8
        doc: Group delay differential between L1 and L2
      - id: c_rs
        type: f8
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f8
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f8
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f8
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toe_tow
        type: f8
        doc: Time of week
      - id: toe_wn
        type: u2
        doc: Week number
      - id: toc_tow
        type: f8
        doc: Clock reference time of week
      - id: toc_wn
        type: u2
        doc: Clock reference week number
      - id: valid
        type: u1
        doc: Is valid?
      - id: healthy
        type: u1
        doc: Satellite is healthy?
      - id: prn
        type: u1
        doc: PRN being tracked
      - id: iode
        type: u1
        doc: Issue of ephemeris data
  
  msg_ephemeris_dep_c:
    doc: Deprecated.
    seq:
      - id: tgd
        type: f8
        doc: Group delay differential between L1 and L2
      - id: c_rs
        type: f8
        doc: Amplitude of the sine harmonic correction term to the orbit radius
      - id: c_rc
        type: f8
        doc: Amplitude of the cosine harmonic correction term to the orbit radius
      - id: c_uc
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the argument of
          latitude
      - id: c_us
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the argument of
          latitude
      - id: c_ic
        type: f8
        doc: |
          Amplitude of the cosine harmonic correction term to the angle of
          inclination
      - id: c_is
        type: f8
        doc: |
          Amplitude of the sine harmonic correction term to the angle of
          inclination
      - id: dn
        type: f8
        doc: Mean motion difference
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: inc_dot
        type: f8
        doc: Inclination first derivative
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f8
        doc: Polynomial clock correction coefficient (clock drift)
      - id: af2
        type: f8
        doc: Polynomial clock correction coefficient (rate of clock drift)
      - id: toe_tow
        type: f8
        doc: Time of week
      - id: toe_wn
        type: u2
        doc: Week number
      - id: toc_tow
        type: f8
        doc: Clock reference time of week
      - id: toc_wn
        type: u2
        doc: Clock reference week number
      - id: valid
        type: u1
        doc: Is valid?
      - id: healthy
        type: u1
        doc: Satellite is healthy?
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal identifier
      - id: iode
        type: u1
        doc: Issue of ephemeris data
      - id: iodc
        type: u2
        doc: Issue of clock data
      - id: reserved
        type: u4
        doc: Reserved field
  
  observation_header_dep:
    doc: Header of a GPS observation message.
    seq:
      - id: t
        type: gnss::gps_time_dep
        doc: GPS time of this observation
      - id: n_obs
        type: u1
        doc: |
          Total number of observations. First nibble is the size of the
          sequence (n), second nibble is the zero-indexed counter (ith packet
          of n)
  
  carrier_phase_dep_a:
    doc: |
      Carrier phase measurement in cycles represented as a 40-bit fixed point
      number with Q32.8 layout, i.e. 32-bits of whole cycles and 8-bits of
      fractional cycles. This has the opposite sign convention than a typical
      GPS receiver and the phase has the opposite sign as the pseudorange.
    seq:
      - id: i
        type: s4
        doc: Carrier phase whole cycles
      - id: f
        type: u1
        doc: Carrier phase fractional part
  
  packed_obs_content_dep_a:
    doc: Deprecated.
    seq:
      - id: p
        type: u4
        doc: Pseudorange observation
      - id: l
        type: carrier_phase_dep_a
        doc: Carrier phase observation with opposite sign from typical convention
      - id: cn0
        type: u1
        doc: Carrier-to-Noise density
      - id: lock
        type: u2
        doc: |
          Lock indicator. This value changes whenever a satellite signal has
          lost and regained lock, indicating that the carrier phase ambiguity
          may have changed.
      - id: prn
        type: u1
        doc: PRN-1 identifier of the satellite signal
  
  packed_obs_content_dep_b:
    doc: |
      Pseudorange and carrier phase observation for a satellite being tracked.
      Pseudoranges are referenced to a nominal pseudorange.
    seq:
      - id: p
        type: u4
        doc: Pseudorange observation
      - id: l
        type: carrier_phase_dep_a
        doc: |
          Carrier phase observation with opposite sign from typical
          convention.
      - id: cn0
        type: u1
        doc: Carrier-to-Noise density
      - id: lock
        type: u2
        doc: |
          Lock indicator. This value changes whenever a satellite signal has
          lost and regained lock, indicating that the carrier phase ambiguity
          may have changed.
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal identifier
  
  packed_obs_content_dep_c:
    doc: |
      Pseudorange and carrier phase observation for a satellite being tracked.
      The observations are be interoperable with 3rd party receivers and
      conform with typical RTCMv3 GNSS observations.
    seq:
      - id: p
        type: u4
        doc: Pseudorange observation
      - id: l
        type: gnss::carrier_phase
        doc: Carrier phase observation with typical sign convention.
      - id: cn0
        type: u1
        doc: Carrier-to-Noise density
      - id: lock
        type: u2
        doc: |
          Lock indicator. This value changes whenever a satellite signal has
          lost and regained lock, indicating that the carrier phase ambiguity
          may have changed.
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal identifier
  
  msg_obs_dep_a:
    doc: Deprecated.
    seq:
      - id: header
        type: observation_header_dep
        doc: Header of a GPS observation message
      - id: obs
        type: packed_obs_content_dep_a
        repeat: eos
        doc: |
          Pseudorange and carrier phase observation for a satellite being
          tracked.
  
  msg_obs_dep_b:
    doc: Deprecated.
    seq:
      - id: header
        type: observation_header_dep
        doc: Header of a GPS observation message
      - id: obs
        type: packed_obs_content_dep_b
        repeat: eos
        doc: |
          Pseudorange and carrier phase observation for a satellite being
          tracked.
  
  msg_obs_dep_c:
    doc: Deprecated.
    seq:
      - id: header
        type: observation_header_dep
        doc: Header of a GPS observation message
      - id: obs
        type: packed_obs_content_dep_c
        repeat: eos
        doc: |
          Pseudorange and carrier phase observation for a satellite being
          tracked.
  
  msg_iono:
    doc: |
      The ionospheric parameters which allow the "L1 only" or "L2 only" user
      to utilize the ionospheric model for computation of the ionospheric
      delay. Please see ICD-GPS-200 (Chapter 20.3.3.5.1.7) for more details.
    seq:
      - id: t_nmct
        type: gnss::gps_time_sec
        doc: Navigation Message Correction Table Validity Time
      - id: a0
        type: f8
      - id: a1
        type: f8
      - id: a2
        type: f8
      - id: a3
        type: f8
      - id: b0
        type: f8
      - id: b1
        type: f8
      - id: b2
        type: f8
      - id: b3
        type: f8
  
  msg_sv_configuration_gps_dep:
    doc: Deprecated.
    seq:
      - id: t_nmct
        type: gnss::gps_time_sec
        doc: Navigation Message Correction Table Validity Time
      - id: l2c_mask
        type: u4
        doc: L2C capability mask, SV32 bit being MSB, SV1 bit being LSB
  
  gnss_capb:
    seq:
      - id: gps_active
        type: u8
        doc: GPS SV active mask
      - id: gps_l2c
        type: u8
        doc: GPS L2C active mask
      - id: gps_l5
        type: u8
        doc: GPS L5 active mask
      - id: glo_active
        type: u4
        doc: GLO active mask
      - id: glo_l2of
        type: u4
        doc: GLO L2OF active mask
      - id: glo_l3
        type: u4
        doc: GLO L3 active mask
      - id: sbas_active
        type: u8
        doc: |
          SBAS active mask (PRNs 120..158, AN 7/62.2.2-18/18 Table B-23,
          https://www.caat.or.th/wp-content/uploads/2018/03/SL-2018.18.E-1.pdf)
      - id: sbas_l5
        type: u8
        doc: |
          SBAS L5 active mask (PRNs 120..158, AN 7/62.2.2-18/18 Table B-23,
          https://www.caat.or.th/wp-content/uploads/2018/03/SL-2018.18.E-1.pdf)
      - id: bds_active
        type: u8
        doc: BDS active mask
      - id: bds_d2nav
        type: u8
        doc: BDS D2NAV active mask
      - id: bds_b2
        type: u8
        doc: BDS B2 active mask
      - id: bds_b2a
        type: u8
        doc: BDS B2A active mask
      - id: qzss_active
        type: u4
        doc: QZSS active mask
      - id: gal_active
        type: u8
        doc: GAL active mask
      - id: gal_e5
        type: u8
        doc: GAL E5 active mask
  
  msg_gnss_capb:
    doc: |
      Bit masks of signal capabilities for each GNSS satellite PRN.
      Please see ICD-GPS-200 (Chapter 20.3.3.5.1.4) for more details.
    seq:
      - id: t_nmct
        type: gnss::gps_time_sec
        doc: Navigation Message Correction Table Validity Time
      - id: gc
        type: gnss_capb
        doc: GNSS capabilities masks
  
  msg_group_delay_dep_a:
    doc: Deprecated.
    seq:
      - id: t_op
        type: gnss::gps_time_dep
        doc: Data Predict Time of Week
      - id: prn
        type: u1
        doc: Satellite number
      - id: valid
        type: u1
        doc: |
          bit-field indicating validity of the values, LSB indicating tgd
          validity etc. 1 = value is valid, 0 = value is not valid.
      - id: tgd
        type: s2
      - id: isc_l1ca
        type: s2
      - id: isc_l2c
        type: s2
  
  msg_group_delay_dep_b:
    doc: Deprecated.
    seq:
      - id: t_op
        type: gnss::gps_time_sec
        doc: Data Predict Time of Week
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal identifier
      - id: valid
        type: u1
        doc: |
          bit-field indicating validity of the values, LSB indicating tgd
          validity etc. 1 = value is valid, 0 = value is not valid.
      - id: tgd
        type: s2
      - id: isc_l1ca
        type: s2
      - id: isc_l2c
        type: s2
  
  msg_group_delay:
    doc: Please see ICD-GPS-200 (30.3.3.3.1.1) for more details.
    seq:
      - id: t_op
        type: gnss::gps_time_sec
        doc: Data Predict Time of Week
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier
      - id: valid
        type: u1
        doc: |
          bit-field indicating validity of the values, LSB indicating tgd
          validity etc. 1 = value is valid, 0 = value is not valid.
      - id: tgd
        type: s2
      - id: isc_l1ca
        type: s2
      - id: isc_l2c
        type: s2
  
  almanac_common_content:
    seq:
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier
      - id: toa
        type: gnss::gps_time_sec
        doc: Reference time of almanac
      - id: ura
        type: f8
        doc: User Range Accuracy
      - id: fit_interval
        type: u4
        doc: Curve fit interval
      - id: valid
        type: u1
        doc: Status of almanac, 1 = valid, 0 = invalid
      - id: health_bits
        type: u1
        doc: |
          Satellite health status for GPS:
            - bits 5-7: NAV data health status. See IS-GPS-200H
              Table 20-VII: NAV Data Health Indications.
            - bits 0-4: Signal health status. See IS-GPS-200H
              Table 20-VIII. Codes for Health of SV Signal
              Components.

          Satellite health status for GLO (see GLO ICD 5.1 table 5.1 for
          details):
            - bit 0: C(n), "unhealthy" flag that is transmitted within
              non-immediate data and indicates overall constellation status
              at the moment of almanac uploading.
              '0' indicates malfunction of n-satellite.
              '1' indicates that n-satellite is operational.
            - bit 1: Bn(ln), '0' indicates the satellite is operational
              and suitable for navigation.
  
  almanac_common_content_dep:
    seq:
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal identifier
      - id: toa
        type: gnss::gps_time_sec
        doc: Reference time of almanac
      - id: ura
        type: f8
        doc: User Range Accuracy
      - id: fit_interval
        type: u4
        doc: Curve fit interval
      - id: valid
        type: u1
        doc: Status of almanac, 1 = valid, 0 = invalid
      - id: health_bits
        type: u1
        doc: |
          Satellite health status for GPS:
            - bits 5-7: NAV data health status. See IS-GPS-200H
              Table 20-VII: NAV Data Health Indications.
            - bits 0-4: Signal health status. See IS-GPS-200H
              Table 20-VIII. Codes for Health of SV Signal
              Components.

          Satellite health status for GLO (see GLO ICD 5.1 table 5.1 for
          details):
            - bit 0: C(n), "unhealthy" flag that is transmitted within
              non-immediate data and indicates overall constellation status
              at the moment of almanac uploading.
              '0' indicates malfunction of n-satellite.
              '1' indicates that n-satellite is operational.
            - bit 1: Bn(ln), '0' indicates the satellite is operational
              and suitable for navigation.
  
  msg_almanac_gps_dep:
    doc: Deprecated.
    seq:
      - id: common
        type: almanac_common_content_dep
        doc: Values common for all almanac types
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f8
        doc: Polynomial clock correction coefficient (clock drift)
  
  msg_almanac_gps:
    doc: |
      The almanac message returns a set of satellite orbit parameters. Almanac
      data is not very precise and is considered valid for up to several
      months. Please see the Navstar GPS Space Segment/Navigation user
      interfaces (ICD-GPS-200, Chapter 20.3.3.5.1.2 Almanac Data) for more
      details.
    seq:
      - id: common
        type: almanac_common_content
        doc: Values common for all almanac types
      - id: m0
        type: f8
        doc: Mean anomaly at reference time
      - id: ecc
        type: f8
        doc: Eccentricity of satellite orbit
      - id: sqrta
        type: f8
        doc: Square root of the semi-major axis of orbit
      - id: omega0
        type: f8
        doc: Longitude of ascending node of orbit plane at weekly epoch
      - id: omegadot
        type: f8
        doc: Rate of right ascension
      - id: w
        type: f8
        doc: Argument of perigee
      - id: inc
        type: f8
        doc: Inclination
      - id: af0
        type: f8
        doc: Polynomial clock correction coefficient (clock bias)
      - id: af1
        type: f8
        doc: Polynomial clock correction coefficient (clock drift)
  
  msg_almanac_glo_dep:
    doc: Deprecated.
    seq:
      - id: common
        type: almanac_common_content_dep
        doc: Values common for all almanac types
      - id: lambda_na
        type: f8
        doc: |
          Longitude of the first ascending node of the orbit in PZ-90.02
          coordinate system
      - id: t_lambda_na
        type: f8
        doc: Time of the first ascending node passage
      - id: i
        type: f8
        doc: Value of inclination at instant of t_lambda
      - id: t
        type: f8
        doc: Value of Draconian period at instant of t_lambda
      - id: t_dot
        type: f8
        doc: Rate of change of the Draconian period
      - id: epsilon
        type: f8
        doc: Eccentricity at instant of t_lambda
      - id: omega
        type: f8
        doc: Argument of perigee at instant of t_lambda
  
  msg_almanac_glo:
    doc: |
      The almanac message returns a set of satellite orbit parameters. Almanac
      data is not very precise and is considered valid for up to several
      months. Please see the GLO ICD 5.1 "Chapter 4.5 Non-immediate
      information and almanac" for details.
    seq:
      - id: common
        type: almanac_common_content
        doc: Values common for all almanac types
      - id: lambda_na
        type: f8
        doc: |
          Longitude of the first ascending node of the orbit in PZ-90.02
          coordinate system
      - id: t_lambda_na
        type: f8
        doc: Time of the first ascending node passage
      - id: i
        type: f8
        doc: Value of inclination at instant of t_lambda
      - id: t
        type: f8
        doc: Value of Draconian period at instant of t_lambda
      - id: t_dot
        type: f8
        doc: Rate of change of the Draconian period
      - id: epsilon
        type: f8
        doc: Eccentricity at instant of t_lambda
      - id: omega
        type: f8
        doc: Argument of perigee at instant of t_lambda
  
  msg_glo_biases:
    doc: |
      The GLONASS L1/L2 Code-Phase biases allows to perform GPS+GLONASS
      integer ambiguity resolution for baselines with mixed receiver types
      (e.g. receiver of different manufacturers).
    seq:
      - id: mask
        type: u1
        doc: GLONASS FDMA signals mask
      - id: l1ca_bias
        type: s2
        doc: GLONASS L1 C/A Code-Phase Bias
      - id: l1p_bias
        type: s2
        doc: GLONASS L1 P Code-Phase Bias
      - id: l2ca_bias
        type: s2
        doc: GLONASS L2 C/A Code-Phase Bias
      - id: l2p_bias
        type: s2
        doc: GLONASS L2 P Code-Phase Bias
  
  sv_az_el:
    doc: Satellite azimuth and elevation.
    seq:
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier
      - id: az
        type: u1
        doc: Azimuth angle (range 0..179)
      - id: el
        type: s1
        doc: Elevation angle (range -90..90)
  
  msg_sv_az_el:
    doc: |
      Azimuth and elevation angles of all the visible satellites that the
      device does have ephemeris or almanac for.
    seq:
      - id: azel
        type: sv_az_el
        repeat: eos
        doc: Azimuth and elevation per satellite
  
  msg_osr:
    doc: |
      The OSR message contains network corrections in an observation-like
      format.
    seq:
      - id: header
        type: observation_header
        doc: Header of a GPS observation message
      - id: obs
        type: packed_osr_content
        repeat: eos
        doc: Network correction for a satellite signal.
  
