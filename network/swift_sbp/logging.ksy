# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/logging.ksy
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
# Logging and debugging messages from the device.
#
# Automatically generated from spec/yaml/swiftnav/sbp/logging.yaml with generate.py.
# Do not modify by hand!

meta:
  id: logging
  title: SBP logging messages
  license: MIT
  imports: [  ]
  endian: le

types:

  msg_log:
    doc: |
      This message contains a human-readable payload string from the device
      containing errors, warnings and informational messages at ERROR,
      WARNING, DEBUG, INFO logging levels.
    seq:
      - id: level
        type: u1
        doc: Logging level
      - id: text
        size-eos: true
        type: str
        encoding: ASCII
        doc: Human-readable string
  
  msg_fwd:
    doc: |
      This message provides the ability to forward messages over SBP.  This
      may take the form of wrapping up SBP messages received by Piksi for
      logging purposes or wrapping another protocol with SBP.

      The source identifier indicates from what interface a forwarded stream
      derived. The protocol identifier identifies what the expected protocol
      the forwarded msg contains. Protocol 0 represents SBP and the remaining
      values are implementation defined.
    seq:
      - id: source
        type: u1
        doc: source identifier
      - id: protocol
        type: u1
        doc: protocol identifier
      - id: fwd_payload
        type: u1
        repeat: eos
        doc: variable length wrapped binary message
  
  msg_print_dep:
    doc: Deprecated.
    seq:
      - id: text
        size-eos: true
        type: str
        encoding: ASCII
        doc: Human-readable string
  
