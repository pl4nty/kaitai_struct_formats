# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/sbas.ksy
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
# SBAS data
#
# Automatically generated from spec/yaml/swiftnav/sbp/sbas.yaml with generate.py.
# Do not modify by hand!

meta:
  id: sbas
  title: SBP SBAS messages
  license: MIT
  imports: [ gnss ]
  endian: le

types:

  msg_sbas_raw:
    doc: |
      This message is sent once per second per SBAS satellite. ME checks the
      parity of the data block and sends only blocks that pass the check.
    seq:
      - id: sid
        type: gnss::gnss_signal
        doc: GNSS signal identifier.
      - id: tow
        type: u4
        doc: GPS time-of-week at the start of the data block.
      - id: message_type
        type: u1
        doc: SBAS message type (0-63)
      - id: data
        type: u1
        repeat: expr
        repeat-expr: 27
        doc: Raw SBAS data field of 212 bits (last byte padded with zeros).
  
