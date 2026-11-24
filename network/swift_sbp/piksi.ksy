# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/piksi.ksy
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
# System health, configuration, and diagnostic messages specific to the Piksi L1
# receiver, including a variety of legacy messages that may no longer be used.
#
# Automatically generated from spec/yaml/swiftnav/sbp/piksi.yaml with generate.py.
# Do not modify by hand!

meta:
  id: piksi
  title: SBP Piksi messages
  license: MIT
  imports: [ gnss ]
  endian: le

types:

  msg_almanac:
    doc: |
      This is a legacy message for sending and loading a satellite alamanac
      onto the Piksi's flash memory from the host.
    seq: []
  
  msg_set_time:
    doc: |
      This message sets up timing functionality using a coarse GPS time
      estimate sent by the host.
    seq: []
  
  msg_reset:
    doc: This message from the host resets the Piksi back into the bootloader.
    seq:
      - id: flags
        type: u4
        doc: Reset flags
  
  msg_reset_dep:
    doc: Deprecated.
    seq: []
  
  msg_cw_results:
    doc: |
      This is an unused legacy message for result reporting from the CW
      interference channel on the SwiftNAP. This message will be removed in a
      future release.
    seq: []
  
  msg_cw_start:
    doc: |
      This is an unused legacy message from the host for starting the CW
      interference channel on the SwiftNAP. This message will be removed in a
      future release.
    seq: []
  
  msg_reset_filters:
    doc: |
      This message resets either the DGNSS Kalman filters or Integer Ambiguity
      Resolution (IAR) process.
    seq:
      - id: filter
        type: u1
        doc: Filter flags
  
  msg_init_base_dep:
    doc: Deprecated.
    seq: []
  
  msg_thread_state:
    doc: |
      The thread usage message from the device reports real-time operating
      system (RTOS) thread usage statistics for the named thread. The reported
      percentage values must be normalized.
    seq:
      - id: name
        size: 20
        type: str
        encoding: ASCII
        doc: Thread name (NULL terminated)
      - id: cpu
        type: u2
        doc: |
          Percentage cpu use for this thread. Values range from 0 - 1000 and
          needs to be renormalized to 100
      - id: stack_free
        type: u4
        doc: Free stack space for this thread
  
  uart_channel:
    doc: |
      Throughput, utilization, and error counts on the RX/TX buffers of this
      UART channel. The reported percentage values must be normalized.
    seq:
      - id: tx_throughput
        type: f4
        doc: UART transmit throughput
      - id: rx_throughput
        type: f4
        doc: UART receive throughput
      - id: crc_error_count
        type: u2
        doc: UART CRC error count
      - id: io_error_count
        type: u2
        doc: UART IO error count
      - id: tx_buffer_level
        type: u1
        doc: UART transmit buffer percentage utilization (ranges from 0 to 255)
      - id: rx_buffer_level
        type: u1
        doc: UART receive buffer percentage utilization (ranges from 0 to 255)
  
  period:
    doc: |
      Statistics on the period of observations received from the base station.
      As complete observation sets are received, their time of reception is
      compared with the prior set''s time of reception. This measurement
      provides a proxy for link quality as incomplete or missing sets will
      increase the period.  Long periods can cause momentary RTK solution
      outages.
    seq:
      - id: avg
        type: s4
        doc: Average period
      - id: pmin
        type: s4
        doc: Minimum period
      - id: pmax
        type: s4
        doc: Maximum period
      - id: current
        type: s4
        doc: Smoothed estimate of the current period
  
  latency:
    doc: |
      Statistics on the latency of observations received from the base
      station. As observation packets are received their GPS time is compared
      to the current GPS time calculated locally by the receiver to give a
      precise measurement of the end-to-end communication latency in the
      system.
    seq:
      - id: avg
        type: s4
        doc: Average latency
      - id: lmin
        type: s4
        doc: Minimum latency
      - id: lmax
        type: s4
        doc: Maximum latency
      - id: current
        type: s4
        doc: Smoothed estimate of the current latency
  
  msg_uart_state:
    doc: |
      The UART message reports data latency and throughput of the UART
      channels providing SBP I/O. On the default Piksi configuration, UARTs A
      and B are used for telemetry radios, but can also be host access ports
      for embedded hosts, or other interfaces in future. The reported
      percentage values must be normalized. Observations latency and period
      can be used to assess the health of the differential corrections link.
      Latency provides the timeliness of received base observations while the
      period indicates their likelihood of transmission.
    seq:
      - id: uart_a
        type: uart_channel
        doc: State of UART A
      - id: uart_b
        type: uart_channel
        doc: State of UART B
      - id: uart_ftdi
        type: uart_channel
        doc: State of UART FTDI (USB logger)
      - id: latency
        type: latency
        doc: UART communication latency
      - id: obs_period
        type: period
        doc: Observation receipt period
  
  msg_uart_state_depa:
    doc: Deprecated.
    seq:
      - id: uart_a
        type: uart_channel
        doc: State of UART A
      - id: uart_b
        type: uart_channel
        doc: State of UART B
      - id: uart_ftdi
        type: uart_channel
        doc: State of UART FTDI (USB logger)
      - id: latency
        type: latency
        doc: UART communication latency
  
  msg_iar_state:
    doc: |
      This message reports the state of the Integer Ambiguity Resolution (IAR)
      process, which resolves unknown integer ambiguities from double-
      differenced carrier-phase measurements from satellite observations.
    seq:
      - id: num_hyps
        type: u4
        doc: Number of integer ambiguity hypotheses remaining
  
  msg_mask_satellite:
    doc: |
      This message allows setting a mask to prevent a particular satellite
      from being used in various Piksi subsystems.
    seq:
      - id: mask
        type: u1
        doc: Mask of systems that should ignore this satellite.
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal for which the mask is applied
  
  msg_mask_satellite_dep:
    doc: Deprecated.
    seq:
      - id: mask
        type: u1
        doc: Mask of systems that should ignore this satellite.
      - id: sid
        type: gnss::gnss_signal_dep
        doc: GNSS signal for which the mask is applied
  
  msg_device_monitor:
    doc: |
      This message contains temperature and voltage level measurements from
      the processor's monitoring system and the RF frontend die temperature if
      available.
    seq:
      - id: dev_vin
        type: s2
        doc: Device V_in
      - id: cpu_vint
        type: s2
        doc: Processor V_int
      - id: cpu_vaux
        type: s2
        doc: Processor V_aux
      - id: cpu_temperature
        type: s2
        doc: Processor temperature
      - id: fe_temperature
        type: s2
        doc: Frontend temperature (if available)
  
  msg_command_req:
    doc: |
      Request the recipient to execute an command. Output will be sent in
      MSG_LOG messages, and the exit code will be returned with
      MSG_COMMAND_RESP.
    seq:
      - id: sequence
        type: u4
        doc: Sequence number
      - id: command
        size-eos: true
        type: str
        encoding: ASCII
        doc: Command line to execute
  
  msg_command_resp:
    doc: |
      The response to MSG_COMMAND_REQ with the return code of the command.  A
      return code of zero indicates success.
    seq:
      - id: sequence
        type: u4
        doc: Sequence number
      - id: code
        type: s4
        doc: Exit code
  
  msg_command_output:
    doc: |
      Returns the standard output and standard error of the command requested
      by MSG_COMMAND_REQ. The sequence number can be used to filter for
      filtering the correct command.
    seq:
      - id: sequence
        type: u4
        doc: Sequence number
      - id: line
        size-eos: true
        type: str
        encoding: ASCII
        doc: Line of standard output or standard error
  
  msg_network_state_req:
    doc: |
      Request state of Piksi network interfaces. Output will be sent in
      MSG_NETWORK_STATE_RESP messages.
    seq: []
  
  msg_network_state_resp:
    doc: |
      The state of a network interface on the Piksi. Data is made to reflect
      output of ifaddrs struct returned by getifaddrs in c.
    seq:
      - id: ipv4_address
        type: u1
        repeat: expr
        repeat-expr: 4
        doc: IPv4 address (all zero when unavailable)
      - id: ipv4_mask_size
        type: u1
        doc: IPv4 netmask CIDR notation
      - id: ipv6_address
        type: u1
        repeat: expr
        repeat-expr: 16
        doc: IPv6 address (all zero when unavailable)
      - id: ipv6_mask_size
        type: u1
        doc: IPv6 netmask CIDR notation
      - id: rx_bytes
        type: u4
        doc: Number of Rx bytes
      - id: tx_bytes
        type: u4
        doc: Number of Tx bytes
      - id: interface_name
        size: 16
        type: str
        encoding: ASCII
        doc: Interface Name
      - id: flags
        type: u4
        doc: Interface flags from SIOCGIFFLAGS
  
  network_usage:
    doc: |
      The bandwidth usage for each interface can be reported within this
      struct and utilize multiple fields to fully specify the type of traffic
      that is being tracked. As either the interval of collection or the
      collection time may vary, both a timestamp and period field is provided,
      though may not necessarily be populated with a value.
    seq:
      - id: duration
        type: u8
        doc: Duration over which the measurement was collected
      - id: total_bytes
        type: u8
        doc: Number of bytes handled in total within period
      - id: rx_bytes
        type: u4
        doc: Number of bytes transmitted within period
      - id: tx_bytes
        type: u4
        doc: Number of bytes received within period
      - id: interface_name
        size: 16
        type: str
        encoding: ASCII
        doc: Interface Name
  
  msg_network_bandwidth_usage:
    doc: The bandwidth usage, a list of usage by interface.
    seq:
      - id: interfaces
        type: network_usage
        repeat: eos
        doc: Usage measurement array
  
  msg_cell_modem_status:
    doc: |
      If a cell modem is present on a piksi device, this message will be send
      periodically to update the host on the status of the modem and its
      various parameters.
    seq:
      - id: signal_strength
        type: s1
        doc: Received cell signal strength in dBm, zero translates to unknown
      - id: signal_error_rate
        type: f4
        doc: BER as reported by the modem, zero translates to unknown
      - id: reserved
        type: u1
        repeat: eos
        doc: Unspecified data TBD for this schema
  
  msg_specan_dep:
    doc: Deprecated.
    seq:
      - id: channel_tag
        type: u2
        doc: Channel ID
      - id: t
        type: gnss::gps_time_dep
        doc: Receiver time of this observation
      - id: freq_ref
        type: f4
        doc: Reference frequency of this packet
      - id: freq_step
        type: f4
        doc: Frequency step of points in this packet
      - id: amplitude_ref
        type: f4
        doc: Reference amplitude of this packet
      - id: amplitude_unit
        type: f4
        doc: Amplitude unit value of points in this packet
      - id: amplitude_value
        type: u1
        repeat: eos
        doc: Amplitude values (in the above units) of points in this packet
  
  msg_specan:
    doc: Spectrum analyzer packet.
    seq:
      - id: channel_tag
        type: u2
        doc: Channel ID
      - id: t
        type: gnss::gps_time
        doc: Receiver time of this observation
      - id: freq_ref
        type: f4
        doc: Reference frequency of this packet
      - id: freq_step
        type: f4
        doc: Frequency step of points in this packet
      - id: amplitude_ref
        type: f4
        doc: Reference amplitude of this packet
      - id: amplitude_unit
        type: f4
        doc: Amplitude unit value of points in this packet
      - id: amplitude_value
        type: u1
        repeat: eos
        doc: Amplitude values (in the above units) of points in this packet
  
  msg_front_end_gain:
    doc: |
      This message describes the gain of each channel in the receiver
      frontend. Each gain is encoded as a non-dimensional percentage relative
      to the maximum range possible for the gain stage of the frontend. By
      convention, each gain array has 8 entries and the index of the array
      corresponding to the index of the rf channel in the frontend. A gain of
      127 percent encodes that rf channel is not present in the hardware. A
      negative value implies an error for the particular gain stage as
      reported by the frontend.
    seq:
      - id: rf_gain
        type: s1
        repeat: expr
        repeat-expr: 8
        doc: RF gain for each frontend channel
      - id: if_gain
        type: s1
        repeat: expr
        repeat-expr: 8
        doc: Intermediate frequency gain for each frontend channel
  
