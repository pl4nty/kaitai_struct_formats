# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/system.ksy
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
# Standardized system messages from Swift Navigation devices.
#
# Automatically generated from spec/yaml/swiftnav/sbp/system.yaml with generate.py.
# Do not modify by hand!

meta:
  id: system
  title: SBP system messages
  license: MIT
  imports: [  ]
  endian: le

types:

  msg_startup:
    doc: |
      The system start-up message is sent once on system start-up. It notifies
      the host or other attached devices that the system has started and is
      now ready to respond to commands or configuration requests.
    seq:
      - id: cause
        type: u1
        doc: Cause of startup
      - id: startup_type
        type: u1
        doc: Startup type
      - id: reserved
        type: u2
        doc: Reserved
  
  msg_dgnss_status:
    doc: |
      This message provides information about the receipt of Differential
      corrections.  It is expected to be sent with each receipt of a complete
      corrections packet.
    seq:
      - id: flags
        type: u1
        doc: Status flags
      - id: latency
        type: u2
        doc: Latency of observation receipt
      - id: num_signals
        type: u1
        doc: Number of signals from base station
      - id: source
        size-eos: true
        type: str
        encoding: ASCII
        doc: Corrections source string
  
  msg_heartbeat:
    doc: |
      The heartbeat message is sent periodically to inform the host or other
      attached devices that the system is running. It is used to monitor
      system malfunctions. It also contains status flags that indicate to the
      host the status of the system and whether it is operating correctly.
      Currently, the expected heartbeat interval is 1 sec.

      The system error flag is used to indicate that an error has occurred in
      the system. To determine the source of the error, the remaining error
      flags should be inspected.
    seq:
      - id: flags
        type: u4
        doc: Status flags
  
  sub_system_report:
    doc: |
      Report the general and specific state of a subsystem.  If the generic
      state is reported as initializing, the specific state should be ignored.
    seq:
      - id: component
        type: u2
        doc: Identity of reporting subsystem
      - id: generic
        type: u1
        doc: Generic form status report
      - id: specific
        type: u1
        doc: Subsystem specific status code
  
  msg_status_report:
    doc: |
      The status report is sent periodically to inform the host or other
      attached devices that the system is running. It is used to monitor
      system malfunctions. It contains status reports that indicate to the
      host the status of each subsystem and whether it is operating correctly.

      Interpretation of the subsystem specific status code is product
      dependent, but if the generic status code is initializing, it should be
      ignored.  Refer to product documentation for details.
    seq:
      - id: reporting_system
        type: u2
        doc: Identity of reporting system
      - id: sbp_version
        type: u2
        doc: SBP protocol version
      - id: sequence
        type: u4
        doc: Increments on each status report sent
      - id: uptime
        type: u4
        doc: Number of seconds since system start-up
      - id: status
        type: sub_system_report
        repeat: eos
        doc: Reported status of individual subsystems
  
  status_journal_item:
    doc: |
      Reports the uptime and the state of a subsystem via generic and specific
      status codes.  If the generic state is reported as initializing, the
      specific state should be ignored.
    seq:
      - id: uptime
        type: u4
        doc: Milliseconds since system startup
      - id: report
        type: sub_system_report
  
  msg_status_journal:
    doc: |
      The status journal message contains past status reports (see
      MSG_STATUS_REPORT) and functions as a error/event storage for telemetry
      purposes.
    seq:
      - id: reporting_system
        type: u2
        doc: Identity of reporting system
      - id: sbp_version
        type: u2
        doc: SBP protocol version
      - id: total_status_reports
        type: u4
        doc: Total number of status reports sent since system startup
      - id: sequence_descriptor
        type: u1
        doc: |
          Index and number of messages in this sequence. First nibble is the
          size of the sequence (n), second nibble is the zero-indexed counter
          (ith packet of n)
      - id: journal
        type: status_journal_item
        repeat: eos
        doc: Status journal
  
  msg_ins_status:
    doc: |
      The INS status message describes the state of the operation and
      initialization of the inertial navigation system.
    seq:
      - id: flags
        type: u4
        doc: Status flags
  
  msg_csac_telemetry:
    doc: |
      The CSAC telemetry message has an implementation defined telemetry
      string from a device. It is not produced or available on general Swift
      Products. It is intended to be a low rate message for status purposes.
    seq:
      - id: id
        type: u1
        doc: |
          Index representing the type of telemetry in use.  It is
          implementation defined.
      - id: telemetry
        size-eos: true
        type: str
        encoding: ASCII
        doc: Comma separated list of values as defined by the index
  
  msg_csac_telemetry_labels:
    doc: |
      The CSAC telemetry message provides labels for each member of the string
      produced by MSG_CSAC_TELEMETRY. It should be provided by a device at a
      lower rate than the MSG_CSAC_TELEMETRY.
    seq:
      - id: id
        type: u1
        doc: |
          Index representing the type of telemetry in use.  It is
          implementation defined.
      - id: telemetry_labels
        size-eos: true
        type: str
        encoding: ASCII
        doc: Comma separated list of telemetry field values
  
  msg_ins_updates:
    doc: |
      The INS update status message contains information about executed and
      rejected INS updates. This message is expected to be extended in the
      future as new types of measurements are being added.
    seq:
      - id: tow
        type: u4
        doc: GPS Time of Week
      - id: gnsspos
        type: u1
        doc: GNSS position update status flags
      - id: gnssvel
        type: u1
        doc: GNSS velocity update status flags
      - id: wheelticks
        type: u1
        doc: Wheelticks update status flags
      - id: speed
        type: u1
        doc: Wheelticks update status flags
      - id: nhc
        type: u1
        doc: NHC update status flags
      - id: zerovel
        type: u1
        doc: Zero velocity update status flags
  
  msg_gnss_time_offset:
    doc: |
      The GNSS time offset message contains the information that is needed to
      translate messages tagged with a local timestamp (e.g. IMU or wheeltick
      messages) to GNSS time for the sender producing this message.
    seq:
      - id: weeks
        type: s2
        doc: Weeks portion of the time offset
      - id: milliseconds
        type: s4
        doc: Milliseconds portion of the time offset
      - id: microseconds
        type: s2
        doc: Microseconds portion of the time offset
      - id: flags
        type: u1
        doc: Status flags
  
  msg_pps_time:
    doc: |
      The PPS time message contains the value of the sender's local time in
      microseconds at the moment a pulse is detected on the PPS input. This is
      to be used for synchronisation of sensor data sampled with a local
      timestamp (e.g. IMU or wheeltick messages) where GNSS time is unknown to
      the sender.

      The local time used to timestamp the PPS pulse must be generated by the
      same clock which is used to timestamp the IMU/wheel sensor data and
      should follow the same roll-over rules (i.e. it should roll over to zero
      after 604800 seconds). A separate MSG_PPS_TIME message should be sent
      for each source of sensor data which uses local timestamping.  The
      sender ID for each of these MSG_PPS_TIME messages should match the
      sender ID of the respective sensor data.
    seq:
      - id: time
        type: u8
        doc: Local time in microseconds
      - id: flags
        type: u1
        doc: Status flags
  
  msg_sensor_aid_event:
    doc: |
      This diagnostic message contains state and update status information for
      all sensors that are being used by the fusion engine. This message will
      be generated asynchronously to the solution messages and will be emitted
      anytime a sensor update is being processed.
    seq:
      - id: time
        type: u4
        doc: Update timestamp in milliseconds.
      - id: sensor_type
        type: u1
        doc: Sensor type
      - id: sensor_id
        type: u2
        doc: |
          Sensor identifier. Always 0 for the GNSS observation types
          (pseudorange, carrier phase and Doppler).
      - id: sensor_state
        type: u1
        doc: Reserved for future use
      - id: n_available_meas
        type: u1
        doc: |
          Number of available measurements in this epoch. For the GNSS
          observation types, the number of signals that passed the quality
          checks for that observation type.
      - id: n_attempted_meas
        type: u1
        doc: |
          Number of attempted measurements in this epoch. For the GNSS
          observation types, the number of signals that the filter accepted or
          rejected as an outlier.
      - id: n_accepted_meas
        type: u1
        doc: |
          Number of accepted measurements in this epoch. For the GNSS
          observation types, the number of signals used in the filter update.
      - id: flags
        type: u4
        doc: Reserved for future use
  
  msg_group_meta:
    doc: |
      This leading message lists the time metadata of the Solution Group. It
      also lists the atomic contents (i.e. types of messages included) of the
      Solution Group.
    seq:
      - id: group_id
        type: u1
        doc: Id of the Msgs Group, 0 is Unknown, 1 is Bestpos, 2 is Gnss
      - id: flags
        type: u1
        doc: Status flags (reserved)
      - id: n_group_msgs
        type: u1
        doc: Size of list group_msgs
      - id: group_msgs
        type: u2
        repeat: eos
        doc: |
          An in-order list of message types included in the Solution Group,
          including GROUP_META itself
  
