meta:
  id: asterix_record
  title: ASTERIX record
  license: GPL-3.0-only
  ks-version: 0.9
  imports:
    - asterix_cat_000
    - asterix_cat_001
    - asterix_cat_002
    - asterix_cat_008
    - asterix_cat_010
    - asterix_cat_020
    - asterix_cat_021
    - asterix_cat_034
    - asterix_cat_048
    - asterix_cat_062

  endian: be

doc: |
  Implementation of ASTERIX format.

  From Eurocontrol Asterix web page at
  https://www.eurocontrol.int/asterix

  Asterix records, is a concatenation of records pertaining to a data block.
  All records are the same category. This implementation is category agnostic.
  Adding new categories is a matter of defining a catalog KSY file, and a Category
  KSY file. If the category implements an unique UAP, then no additional logic is
  needed, otherwise some instance implementation should be implemented in the
  category file. Please see CAT001 implementation file.

  Currently an unique CAT catalog/definition version are implemented per category.
  In the future it is expected to also select by SIC/SAC, which will permit having
  some sort of config file, or definition which will permit selecting category and
  version.

doc-ref: |
  https://www.eurocontrol.int/publication/eurocontrol-specification-surveillance-data-exchange-part-i

params:
  - id: cat
    type: u1

seq:
  - id: records
    type:
      switch-on: cat
      cases:
        1:  asterix_cat_001
        2:  asterix_cat_002
        8:  asterix_cat_008
        10: asterix_cat_010
        20: asterix_cat_020
        21: asterix_cat_021
        34: asterix_cat_034
        48: asterix_cat_048
        62: asterix_cat_062
        _:  asterix_cat_000
    repeat: eos
