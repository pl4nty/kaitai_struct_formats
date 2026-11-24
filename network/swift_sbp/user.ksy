# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/user.ksy
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
# Messages reserved for use by the user.
#
# Automatically generated from spec/yaml/swiftnav/sbp/user.yaml with generate.py.
# Do not modify by hand!

meta:
  id: user
  title: SBP user messages
  license: MIT
  imports: [  ]
  endian: le

types:

  msg_user_data:
    doc: |
      This message can contain any application specific user data up to a
      maximum length of 255 bytes per message.
    seq:
      - id: contents
        type: u1
        repeat: eos
        doc: User data payload
  
