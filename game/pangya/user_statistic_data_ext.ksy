# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/common/user_statistic_data_ext.ksy
# Licence and copyright: see _community/README.md
meta:
  id: user_statistic_data_ext
  title: User Statistic Data Extension
  license: ISC
  imports:
    - id_bank
  encoding: ASCII
  endian: le

doc: |
  Additional data that comes after some instances of `user_statistic_data`.
  
  **See Also**:
  * [Common Data Structures](/packets/common/index.md)

seq:
  - id: unknown_user_statistic_data_ak
    size: 56
    doc: All 0x00?
  - id: unknown_user_statistic_data_ar
    type: u4
  - id: unknown_user_statistic_data_as
    size: 18
