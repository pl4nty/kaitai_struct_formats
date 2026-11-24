# Imported from https://github.com/sorche942/koa-formats-kaitai/blob/efc04be2db704e88200d287aa5c583c05ec09282/assetmgr_init.ksy
meta:
  id: koa_assetmgr_init
  title: Kingdoms of Amalur AssetManager _init.bin
  file-extension: bin
  license: LicenseRef-All-Rights-Reserved
  ks-version: 0.9
  endian: le

doc: |
  Reverse-engineered _init.bin format used for asset preloading/initialization.
  Commonly seen as fab_init.bin and quest_init.bin.

  Format:
  - 4-byte version/type (observed: 1)
  - 4-byte count of IDs
  - array of 4-byte resource IDs

seq:
  - id: version
    type: u4
    doc: Format version or type ID (observed 1 for fab/quest init).
  - id: count
    type: u4
    doc: Number of entries in the following list.
  - id: entries
    type: resource_entry
    repeat: expr
    repeat-expr: count
    doc: List of resource entry pairs to be initialized or preloaded.

types:
  resource_entry:
    seq:
      - id: id_a
        type: u4
      - id: id_b
        type: u4
