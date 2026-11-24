# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/linux.ksy
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
# Linux state monitoring.
#
# Automatically generated from spec/yaml/swiftnav/sbp/linux.yaml with generate.py.
# Do not modify by hand!

meta:
  id: linux
  title: SBP Linux messages
  license: MIT
  imports: [  ]
  endian: le

types:

  msg_linux_cpu_state_dep_a:
    doc: Deprecated.
    seq:
      - id: index
        type: u1
        doc: sequence of this status message, values from 0-9
      - id: pid
        type: u2
        doc: the PID of the process
      - id: pcpu
        type: u1
        doc: percent of cpu used, expressed as a fraction of 256
      - id: tname
        size: 15
        type: str
        encoding: ASCII
        doc: fixed length string representing the thread name
      - id: cmdline
        size-eos: true
        type: str
        encoding: ASCII
        doc: the command line (as much as it fits in the remaining packet)
  
  msg_linux_mem_state_dep_a:
    doc: Deprecated.
    seq:
      - id: index
        type: u1
        doc: sequence of this status message, values from 0-9
      - id: pid
        type: u2
        doc: the PID of the process
      - id: pmem
        type: u1
        doc: percent of memory used, expressed as a fraction of 256
      - id: tname
        size: 15
        type: str
        encoding: ASCII
        doc: fixed length string representing the thread name
      - id: cmdline
        size-eos: true
        type: str
        encoding: ASCII
        doc: the command line (as much as it fits in the remaining packet)
  
  msg_linux_sys_state_dep_a:
    doc: Deprecated.
    seq:
      - id: mem_total
        type: u2
        doc: total system memory
      - id: pcpu
        type: u1
        doc: percent of total cpu currently utilized
      - id: pmem
        type: u1
        doc: percent of total memory currently utilized
      - id: procs_starting
        type: u2
        doc: number of processes that started during collection phase
      - id: procs_stopping
        type: u2
        doc: number of processes that stopped during collection phase
      - id: pid_count
        type: u2
        doc: the count of processes on the system
  
  msg_linux_process_socket_counts:
    doc: Top 10 list of processes with high socket counts.
    seq:
      - id: index
        type: u1
        doc: sequence of this status message, values from 0-9
      - id: pid
        type: u2
        doc: the PID of the process in question
      - id: socket_count
        type: u2
        doc: the number of sockets the process is using
      - id: socket_types
        type: u2
        doc: |
          A bitfield indicating the socket types used: 0x1 (tcp), 0x2 (udp),
          0x4 (unix stream), 0x8 (unix dgram), 0x10 (netlink), and 0x8000
          (unknown)
      - id: socket_states
        type: u2
        doc: |
          A bitfield indicating the socket states: 0x1 (established), 0x2
          (syn-sent), 0x4 (syn-recv), 0x8 (fin-wait-1), 0x10 (fin-wait-2),
          0x20 (time-wait), 0x40 (closed), 0x80 (close-wait), 0x100 (last-
          ack), 0x200 (listen), 0x400 (closing), 0x800 (unconnected), and
          0x8000 (unknown)
      - id: cmdline
        size-eos: true
        type: str
        encoding: ASCII
        doc: the command line of the process in question
  
  msg_linux_process_socket_queues:
    doc: Top 10 list of sockets with deep queues.
    seq:
      - id: index
        type: u1
        doc: sequence of this status message, values from 0-9
      - id: pid
        type: u2
        doc: the PID of the process in question
      - id: recv_queued
        type: u2
        doc: the total amount of receive data queued for this process
      - id: send_queued
        type: u2
        doc: the total amount of send data queued for this process
      - id: socket_types
        type: u2
        doc: |
          A bitfield indicating the socket types used: 0x1 (tcp), 0x2 (udp),
          0x4 (unix stream), 0x8 (unix dgram), 0x10 (netlink), and 0x8000
          (unknown)
      - id: socket_states
        type: u2
        doc: |
          A bitfield indicating the socket states: 0x1 (established), 0x2
          (syn-sent), 0x4 (syn-recv), 0x8 (fin-wait-1), 0x10 (fin-wait-2),
          0x20 (time-wait), 0x40 (closed), 0x80 (close-wait), 0x100 (last-
          ack), 0x200 (listen), 0x400 (closing), 0x800 (unconnected), and
          0x8000 (unknown)
      - id: address_of_largest
        size: 64
        type: str
        encoding: ASCII
        doc: |
          Address of the largest queue, remote or local depending on the
          directionality of the connection.
      - id: cmdline
        size-eos: true
        type: str
        encoding: ASCII
        doc: the command line of the process in question
  
  msg_linux_socket_usage:
    doc: Summaries the socket usage across the system.
    seq:
      - id: avg_queue_depth
        type: u4
        doc: average socket queue depths across all sockets on the system
      - id: max_queue_depth
        type: u4
        doc: the max queue depth seen within the reporting period
      - id: socket_state_counts
        type: u2
        repeat: expr
        repeat-expr: 16
        doc: |
          A count for each socket type reported in the `socket_types_reported`
          field, the first entry corresponds to the first enabled bit in
          `types_reported`.
      - id: socket_type_counts
        type: u2
        repeat: expr
        repeat-expr: 16
        doc: |
          A count for each socket type reported in the `socket_types_reported`
          field, the first entry corresponds to the first enabled bit in
          `types_reported`.
  
  msg_linux_process_fd_count:
    doc: Top 10 list of processes with a large number of open file descriptors.
    seq:
      - id: index
        type: u1
        doc: sequence of this status message, values from 0-9
      - id: pid
        type: u2
        doc: the PID of the process in question
      - id: fd_count
        type: u2
        doc: a count of the number of file descriptors opened by the process
      - id: cmdline
        size-eos: true
        type: str
        encoding: ASCII
        doc: the command line of the process in question
  
  msg_linux_process_fd_summary:
    doc: Summary of open file descriptors on the system.
    seq:
      - id: sys_fd_count
        type: u4
        doc: count of total FDs open on the system
      - id: most_opened
        size-eos: true
        type: str
        encoding: ASCII
        doc: |
          A null delimited list of strings which alternates between a string
          representation of the process count and the file name whose count it
          being reported.  That is, in C string syntax
          "32\0/var/log/syslog\012\0/tmp/foo\0" with the end of the list being
          2 NULL terminators in a row.
  
  msg_linux_cpu_state:
    doc: |
      This message indicates the process state of the top 10 heaviest
      consumers of CPU on the system, including a timestamp.
    seq:
      - id: index
        type: u1
        doc: sequence of this status message, values from 0-9
      - id: pid
        type: u2
        doc: the PID of the process
      - id: pcpu
        type: u1
        doc: percent of CPU used, expressed as a fraction of 256
      - id: time
        type: u4
        doc: timestamp of message, refer to flags field for how to interpret
      - id: flags
        type: u1
        doc: flags
      - id: tname
        size: 15
        type: str
        encoding: ASCII
        doc: fixed length string representing the thread name
      - id: cmdline
        size-eos: true
        type: str
        encoding: ASCII
        doc: the command line (as much as it fits in the remaining packet)
  
  msg_linux_mem_state:
    doc: |
      This message indicates the process state of the top 10 heaviest
      consumers of memory on the system, including a timestamp.
    seq:
      - id: index
        type: u1
        doc: sequence of this status message, values from 0-9
      - id: pid
        type: u2
        doc: the PID of the process
      - id: pmem
        type: u1
        doc: percent of memory used, expressed as a fraction of 256
      - id: time
        type: u4
        doc: timestamp of message, refer to flags field for how to interpret
      - id: flags
        type: u1
        doc: flags
      - id: tname
        size: 15
        type: str
        encoding: ASCII
        doc: fixed length string representing the thread name
      - id: cmdline
        size-eos: true
        type: str
        encoding: ASCII
        doc: the command line (as much as it fits in the remaining packet)
  
  msg_linux_sys_state:
    doc: |
      This presents a summary of CPU and memory utilization, including a
      timestamp.
    seq:
      - id: mem_total
        type: u2
        doc: total system memory, in MiB
      - id: pcpu
        type: u1
        doc: percent of CPU used, expressed as a fraction of 256
      - id: pmem
        type: u1
        doc: percent of memory used, expressed as a fraction of 256
      - id: procs_starting
        type: u2
        doc: number of processes that started during collection phase
      - id: procs_stopping
        type: u2
        doc: number of processes that stopped during collection phase
      - id: pid_count
        type: u2
        doc: the count of processes on the system
      - id: time
        type: u4
        doc: timestamp of message, refer to flags field for how to interpret
      - id: flags
        type: u1
        doc: flags
  
