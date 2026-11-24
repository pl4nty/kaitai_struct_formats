# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/sercomm/sercomm.ksy
meta:
  id: sercomm_firmware
  title: Sercomm firmware
  license: GPL-2.0-only
  encoding: ASCII
  endian: le
doc: |
  A simple 512 byte header that can be found on devices made by Sercomm,
  an ODM from Taiwan. Examples are several NETGEAR devices, such as the
  NETGEAR DGND4000.

  The header does not contain any information about the data that follows
  and only has a one byte checksum.
doc-ref:
  - https://raw.githubusercontent.com/openwrt/openwrt/3f5619f259de/tools/firmware-utils/src/mksercommfw.c
  - https://raw.githubusercontent.com/ReFirmLabs/binwalk/563a19d5c/src/binwalk/magic/firmware
seq:
  - id: magic
    contents: "sErCoMm"
  - id: version
    size: 4
  - id: hardware_id
    size: 34
    type: strz
  - id: hardware_version
    size: 10
    type: strz
  - id: software_version
    size: 8
  - id: magic2
    contents: "sErCoMm"
  - id: padding_bytes
    type: padding_byte
    repeat: expr
    repeat-expr: 441
  - id: checksum
    size: 1
types:
  padding_byte:
    seq:
      - id: padding_byte
        contents: [0x00]
