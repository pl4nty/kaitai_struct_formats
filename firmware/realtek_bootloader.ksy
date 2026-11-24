# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/realtek_bootloader/realtek_bootloader.ksy
meta:
  id: realtek_bootloader
  title: Realtek bootloader
  license: CC0-1.0
  encoding: UTF-8
  endian: be
doc: |
  Realtek RTL8198 and RTL8196C related. The docs do not always fully correspond
  to devices seen in the wild.
doc-ref:
  - https://github.com/krzys-h/8level-WRT-1200AC-firmware-tools
  - https://github.com/jameshilliard/WECB-VZ-GPL/blob/master/rtl819x/bootcode/boot/init/rtk.h
seq:
  - id: header
    type: header
  - id: data
    size: header.len_data
types:
  header:
    seq:
      - id: signature
        type: u4
        enum: signatures
        valid:
          any-of:
            - signatures::cr6c
            - signatures::r6cr
      - id: load_address
        type: u4
      - id: flash_memory_address
        type: u4
      - id: len_data
        type: u4
enums:
  signatures:
    0x63723663: cr6c
    0x72366372: r6cr
