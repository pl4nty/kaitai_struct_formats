# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/seama/seama.ksy
# Licence and copyright: see _community/README.md
meta:
  id: dlink_seama
  title: SEAMA
  license: LGPL-2.1-or-later
  endian: be
doc: |
  The original source code from the developer (Alphanetworks) says:

  "(SEA)ttle i(MA)ge is the image which used in project seattle."

doc-ref: https://git.openwrt.org/?p=openwrt/svn-archive/archive.git;a=blob;f=tools/firmware-utils/src/seama.h;h=02683b6e98d1be37d3dc835b34d4221a1f73a677;hb=HEAD
seq:
  - id: magic
    contents: [0x5e, 0xa3, 0xa4, 0x17]
  - id: reserved
    size: 2
  - id: len_meta
    -orig-id: metasize
    type: u2
  - id: len_image
    -orig-id: size
    type: u4
  - id: md5_digest
    size: 16
    if: len_image != 0
  - id: metadata
    size: len_meta
  - id: image
    size: len_image
