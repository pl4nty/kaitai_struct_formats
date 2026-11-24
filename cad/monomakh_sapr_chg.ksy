meta:
  id: monomakh_sapr_chg
  application: MONOMAKH-SAPR
  file-extension: chg
  license: CC0-1.0
  ks-version: 0.7
  endian: le
doc: |
  CHG is a container format file used by
  [MONOMAKH-SAPR](https://www.liraland.com/mono/), a software
  package for analysis & design of reinforced concrete multi-storey
  buildings with arbitrary configuration in plan.

  CHG is a simple container, which bundles several project files
  together.

  Written and tested by Vladimir Shulzhitskiy, 2017
seq:
  - id: title
    size: 10
    type: str
    encoding: "ASCII"
  - id: ent
    type: block
    repeat: eos
types:
  block:
    seq:
      - id: header
        size: 13
        type: str
        encoding: "ASCII"
      - id: file_size
        type: u8
      - id: file
        size: file_size
