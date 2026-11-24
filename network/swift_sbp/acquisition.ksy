# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/acquisition.ksy
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
# Satellite acquisition messages from the device.
#
# Automatically generated from spec/yaml/swiftnav/sbp/acquisition.yaml with generate.py.
# Do not modify by hand!

meta:
  id: acquisition
  title: SBP acquisition messages
  license: MIT
  imports: [ gnss ]
  endian: le

types:

  msg_acq_result:
    doc: |
      This message describes the results from an attempted GPS signal
      acquisition search for a satellite PRN over a code phase/carrier
      frequency range. It contains the parameters of the point in the
      acquisition search space with the best carrier-to-noise (CN/0) ratio.
    seq:
      - id: cn0
        type: f4
        doc: CN/0 of best point
      - id: cp
        type: f4
        doc: Code phase of best point
      - id: cf
        type: f4
        doc: Carrier frequency of best point
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal for which acquisition was attempted
  
  msg_acq_result_dep_c:
    doc: Deprecated.
    seq:
      - id: cn0
        type: f4
        doc: CN/0 of best point
      - id: cp
        type: f4
        doc: Code phase of best point
      - id: cf
        type: f4
        doc: Carrier frequency of best point
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal for which acquisition was attempted
  
  msg_acq_result_dep_b:
    doc: Deprecated.
    seq:
      - id: snr
        type: f4
        doc: |
          SNR of best point. Currently in arbitrary SNR points, but will be in
          units of dB Hz in a later revision of this message.
      - id: cp
        type: f4
        doc: Code phase of best point
      - id: cf
        type: f4
        doc: Carrier frequency of best point
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal for which acquisition was attempted
  
  msg_acq_result_dep_a:
    doc: Deprecated.
    seq:
      - id: snr
        type: f4
        doc: |
          SNR of best point. Currently dimensionless, but will have units of
          dB Hz in the revision of this message.
      - id: cp
        type: f4
        doc: Code phase of best point
      - id: cf
        type: f4
        doc: Carrier frequency of best point
      - id: prn
        type: u1
        doc: |
          PRN-1 identifier of the satellite signal for which acquisition was
          attempted
  
  acq_sv_profile:
    doc: |
      Profile for a specific SV for debugging purposes. The message describes
      SV profile during acquisition time. The message is used to debug and
      measure the performance.
    seq:
      - id: job_type
        type: u1
        doc: SV search job type (deep, fallback, etc)
      - id: status
        type: u1
        doc: Acquisition status 1 is Success, 0 is Failure
      - id: cn0
        type: u2
        doc: CN0 value. Only valid if status is '1'
      - id: int_time
        type: u1
        doc: Acquisition integration time
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal for which acquisition was attempted
      - id: bin_width
        type: u2
        doc: Acq frequency bin width
      - id: timestamp
        type: u4
        doc: Timestamp of the job complete event
      - id: time_spent
        type: u4
        doc: Time spent to search for sid.code
      - id: cf_min
        type: s4
        doc: Doppler range lowest frequency
      - id: cf_max
        type: s4
        doc: Doppler range highest frequency
      - id: cf
        type: s4
        doc: Doppler value of detected peak. Only valid if status is '1'
      - id: cp
        type: u4
        doc: Codephase of detected peak. Only valid if status is '1'
  
  acq_sv_profile_dep:
    doc: Deprecated.
    seq:
      - id: job_type
        type: u1
        doc: SV search job type (deep, fallback, etc)
      - id: status
        type: u1
        doc: Acquisition status 1 is Success, 0 is Failure
      - id: cn0
        type: u2
        doc: CN0 value. Only valid if status is '1'
      - id: int_time
        type: u1
        doc: Acquisition integration time
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal for which acquisition was attempted
      - id: bin_width
        type: u2
        doc: Acq frequency bin width
      - id: timestamp
        type: u4
        doc: Timestamp of the job complete event
      - id: time_spent
        type: u4
        doc: Time spent to search for sid.code
      - id: cf_min
        type: s4
        doc: Doppler range lowest frequency
      - id: cf_max
        type: s4
        doc: Doppler range highest frequency
      - id: cf
        type: s4
        doc: Doppler value of detected peak. Only valid if status is '1'
      - id: cp
        type: u4
        doc: Codephase of detected peak. Only valid if status is '1'
  
  msg_acq_sv_profile:
    doc: |
      The message describes all SV profiles during acquisition time. The
      message is used to debug and measure the performance.
    seq:
      - id: acq_sv_profile
        type: acq_sv_profile
        repeat: eos
        doc: SV profiles during acquisition time
  
  msg_acq_sv_profile_dep:
    doc: Deprecated.
    seq:
      - id: acq_sv_profile
        type: acq_sv_profile_dep
        repeat: eos
        doc: SV profiles during acquisition time
  
