# Imported from https://github.com/sbtlocalization/sbt-infinity/blob/74b697f643d53c72e4c54b5b40710d593dcf5079/kaitai/acm.ksy
# SPDX-FileCopyrightText: © 2026 SBT Localization https://sbt.localization.com.ua
# SPDX-FileContributor: Serhii Olendarenko <sergey.olendarenko@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-only

meta:
  id: infinity_acm
  file-extension: acm
  license: GPL-3.0-only
  endian: le
  bit-endian: le
doc: |
  InterPlay ACM audio codec format. Used by Infinity Engine games for compressed
  audio.
  The header is followed by a compressed bitstream that must be decoded
  algorithmically
  using a subband decoder.
doc-ref: |
  https://gibberlings3.github.io/iesdp/file_formats/ie_formats/acm.htm
seq:
  - id: signature
    contents: [0x97, 0x28, 0x03, 0x01]
  - id: num_samples
    type: u4
  - id: num_channels
    type: u2
  - id: sample_rate
    type: u2
  - id: subband_params
    type: u2
instances:
  levels:
    value: subband_params & 0x0f
  sub_blocks:
    value: (subband_params >> 4) & 0x0fff
  block_size:
    value: (1 << levels) * sub_blocks
  compressed_data:
    pos: 14
    size-eos: true
