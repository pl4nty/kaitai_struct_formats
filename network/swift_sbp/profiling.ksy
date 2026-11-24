# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/profiling.ksy
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
# Standardized profiling messages from Swift Navigation devices.
#
# Automatically generated from spec/yaml/swiftnav/sbp/profiling.yaml with generate.py.
# Do not modify by hand!

meta:
  id: profiling
  title: SBP profiling messages
  license: MIT
  imports: [  ]
  endian: le

types:

  msg_measurement_point:
    doc: |
      Tracks execution time of certain code paths in specially built products.
      This message should only be expected and processed on the direction of
      Swift's engineering teams.
    seq:
      - id: total_time
        type: u4
        doc: Total time spent in measurement point (microseconds)
      - id: num_executions
        type: u2
        doc: Number of times measurement point has executed
      - id: min
        type: u4
        doc: Minimum execution time (microseconds)
      - id: max
        type: u4
        doc: Maximum execution time (microseconds)
      - id: return_addr
        type: u8
        doc: Return address
      - id: id
        type: u8
        doc: Unique ID
      - id: slice_time
        type: u8
        doc: CPU slice time (milliseconds)
      - id: line
        type: u2
        doc: Line number
      - id: func
        size-eos: true
        type: str
        encoding: ASCII
        doc: Function name
  
  msg_profiling_system_info:
    doc: |
      Contains basic information about system resource usage. System is
      defined in terms of the source of this message and may vary from sender
      to sender. Refer to product documentation to understand the exact scope
      and meaning of this message.
    seq:
      - id: total_cpu_time
        type: u8
        doc: Total cpu time in microseconds consumed by this system
      - id: age
        type: u8
        doc: Age of the producing system in microseconds
      - id: n_threads
        type: u1
        doc: Number of threads being tracked by this system
      - id: heap_usage
        type: u4
        doc: Number of bytes allocated on the heap
  
  msg_profiling_thread_info:
    doc: |
      Contains profiling information related to a single thread being tracked
      by the producing system. Refer to product documentation to understand
      the exact scope and meaning of this message.
    seq:
      - id: total_cpu_time
        type: u8
        doc: Total cpu time in microseconds consumed by this thread
      - id: age
        type: u8
        doc: Age of the thread in microseconds
      - id: state
        type: u1
        doc: Thread state
      - id: stack_size
        type: u4
        doc: Stack size in bytes
      - id: stack_usage
        type: u4
        doc: Stack high water usage in bytes
      - id: name
        size-eos: true
        type: str
        encoding: ASCII
        doc: Thread name
  
  resource_bucket:
    doc: |
      Information about allocation of various resources grouped by buckets.
      Refer to product documentation to understand the meaning and values in
      this message.
    seq:
      - id: name
        size: 21
        type: str
        encoding: ASCII
        doc: Bucket name
      - id: thread
        type: u1
        doc: Number of threads
      - id: mutex
        type: u1
        doc: Number of mutexes
      - id: cv
        type: u1
        doc: Number of condition variables
      - id: io
        type: u1
        doc: Number of IO handles
      - id: heap_bytes_alloc
        type: u4
        doc: Number of bytes allocated on the heap
      - id: heap_bytes_free
        type: u4
        doc: Number of bytes freed on the heap
      - id: io_write
        type: u4
        doc: Number of bytes written to IO handles
      - id: io_read
        type: u4
        doc: Number of bytes read from IO handles
  
  msg_profiling_resource_counter:
    doc: |
      Information about resource buckets. Refer to product documentation to
      understand the meaning and values in this message.
    seq:
      - id: seq_no
        type: u1
        doc: Message number in complete sequence
      - id: seq_len
        type: u1
        doc: Length of message sequence
      - id: buckets
        type: resource_bucket
        repeat: eos
        doc: List of resource buckets
  
  queue_info:
    doc: Profiling information for a single swiftlet internal message queue type.
    seq:
      - id: timestamp
        type: u8
        doc: Timestamp in milliseconds
      - id: name
        size: 40
        type: str
        encoding: ASCII
        doc: Queue type name
      - id: size
        type: u2
        doc: Total number of slots in the queue
      - id: current_fill
        type: u2
        doc: Number of slots currently in use
      - id: peak_fill
        type: u2
        doc: Peak number of slots used since init
      - id: drop_count
        type: u2
        doc: Number of messages dropped since init
  
  msg_profiling_queue_info:
    doc: |
      Contains profiling information for swiftlet internal message queues.
      Refer to product documentation to understand the meaning and values in
      this message.
    seq:
      - id: seq_no
        type: u1
        doc: Message number in complete sequence
      - id: seq_len
        type: u1
        doc: Length of message sequence
      - id: queues
        type: queue_info
        repeat: eos
        doc: List of queue stats
  
