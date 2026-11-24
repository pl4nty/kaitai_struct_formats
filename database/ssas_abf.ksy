# Imported from https://gist.githubusercontent.com/Hugoberry/6a1db3c3b0bf554970a2895804b955b5/raw/3a2aecde8aca200fe6dfa4bd891743b31bca15b9/abf.ksy
meta:
  id: ssas_abf
  title: SQL Server Analysis Services backup (.abf)
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: bom
    type: bom_t
  - id: stream_signature
    type: stream_signature_t
  - id: backup_log_header
    type: backup_log_header_t
  - id: start
    type: bom_t

instances: 
  virtual_directory:
    pos: 303104
    size: 4150
  additional_log:
    pos: 4096
    size: 112
  partitions:
    pos: 4208
    size: 28
# more files
  metadata_sqlitedb:
#get the name from log that is the last entry
    pos: 10144
    size: 278528
  log:
    pos: 288672
    size: 13180

types:
  bom_t:
    seq:
      - id: byte_order_mark
        contents: [ 0xff, 0xfe ]

  stream_signature_t:
    seq:
      - id: signature
        contents: [0x53, 0, 0x54, 0, 0x52, 0, 0x45, 0, 0x41, 0, 0x4d, 0, 0x5f, 0, 0x53, 0, 0x54, 0, 0x4f, 0, 0x52, 0, 0x41, 0, 0x47, 0, 0x45, 0, 0x5f, 0, 0x53, 0, 0x49, 0, 0x47, 0, 0x4e, 0, 0x41, 0, 0x54, 0, 0x55, 0, 0x52, 0, 0x45, 0, 0x5f, 0, 0x29, 0, 0x21, 0, 0x40, 0, 0x23, 0, 0x24, 0, 0x25, 0, 0x5e, 0, 0x26, 0, 0x2a, 0, 0x28, 0]
        #contents: [ STREAM_STORAGE_SIGNATURE_)!@#$%^&*( ]
        #size: 70

  backup_log_header_t:
    seq:
      - id: backup_restore_sync_version
        size: 4096 - 70 - 2
        type: str
        encoding: UTF-16LE
