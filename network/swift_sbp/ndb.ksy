# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/ndb.ksy
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
# Messages for logging NDB events.
#
# Automatically generated from spec/yaml/swiftnav/sbp/ndb.yaml with generate.py.
# Do not modify by hand!

meta:
  id: ndb
  title: SBP navigation database messages
  license: MIT
  imports: [ gnss ]
  endian: le

types:

  msg_ndb_event:
    doc: |
      This message is sent out when an object is stored into NDB. If needed
      message could also be sent out when fetching an object from NDB.
    seq:
      - id: recv_time
        type: u8
        doc: HW time in milliseconds.
      - id: event
        type: u1
        doc: Event type.
      - id: object_type
        type: u1
        doc: Event object type.
      - id: result
        type: u1
        doc: Event result.
      - id: data_source
        type: u1
        doc: Data source for STORE event, reserved for other events.
      - id: object_sid
        type: gnss::gnss_signal
        doc: |
          GNSS signal identifier, If object_type is Ephemeris OR Almanac, sid
          indicates for which signal the object belongs to. Reserved in other
          cases.
      - id: src_sid
        type: gnss::gnss_signal
        doc: |
          GNSS signal identifier, If object_type is Almanac, Almanac WN, Iono
          OR L2C capabilities AND data_source is NDB_DS_RECEIVER sid indicates
          from which SV data was decoded. Reserved in other cases.
      - id: original_sender
        type: u2
        doc: |
          A unique identifier of the sending hardware. For v1.0, set to the 2
          least significant bytes of the device serial number, valid only if
          data_source is NDB_DS_SBP. Reserved in case of other data_source.
  
