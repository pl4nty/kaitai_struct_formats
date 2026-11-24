# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/lxl_openwrt/lxl_openwrt.ksy
# Licence and copyright: see _community/README.md
meta:
  id: lxl_openwrt
  title: Luxul firmware header format (OpenWrt)
  file-extension: lxl
  license: MIT
  encoding: UTF-8
  endian: le
doc: |
  Luxul is a device manufacturer which has devices onto which OpenWrt
  can be installed. The format described here only applies to the OpenWrt
  builds, not to the firmware downloads from Luxul, which seem to have
  a different header.

  Only the header is described in this field.

  Test files: <https://openwrt.org/toh/hwdata/luxul/luxul_xbr-4500>
doc-ref: https://raw.githubusercontent.com/openwrt/openwrt/9aa6569a/tools/firmware-utils/src/lxlfw.c
seq:
  - id: magic
    contents: "LXL#"
  - id: version
    type: u4
    valid:
      any-of: [0, 1, 2]
  - id: len_header
    -orig-id: hdr_len
    type: u4
  - id: flags
    type: u4
    if: version > 0
  - id: board
    size: 16
    type: strz
    if: version > 0
  - id: release
    size: 16
    if: version > 1
