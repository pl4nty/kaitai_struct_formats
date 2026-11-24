meta:
  id: asterix_cat_020
  title: ASTERIX category 020
  license: GPL-3.0-only
  ks-version: 0.9
  imports:
    - asterix_field_spec
    - asterix_explicit
    - asterix_cat_020_catalog
  endian: be

doc: |
  Implementation of ASTERIX format.

  From Eurocontrol Asterix web page at
  https://www.eurocontrol.int/asterix

  Category 020 definition file

  ASTERIX Part 14 Category 20 Multilateration Target Reports
  EUROCONTROL-SPEC-0149-14

  Edition Number: 1.9

doc-ref: |
  https://www.eurocontrol.int/publication/cat020-eurocontrol-specification-surveillance-data-exchange-asterix-part-14-category-20

seq:
  - id: fspec
    type: asterix_field_spec

  - id: data
    type: uap_type(fspec, [10,20,140,41,42,161,170,70,202,90,100,220,245,110,105,210,300,310,500,400,250,230,260,30,55,50].as<u2[]>.as<str>)

instances:
  category:
    value: '"020"'

  version:
    value: '"1.9"'

  items:
    value: data.items

types:
  uap_type:
    params:

      - id: fspec
        type: asterix_field_spec

      - id: uap
        type: str

    seq:
      - id: items
        doc: |
          One entry per UAP slot (FRN - 1), so items[k] is always UAP slot k.
          A slot whose FSPEC bit is clear gets a catalog entry with
          item_ref_num -1, which matches no case and consumes no bytes
          (ASTERIX Part 1, FSPEC / UAP rules).
        type: 'asterix_cat_020_catalog(fspec.octects[_index / 7].bits[_index % 7] ? uap_list[_index] : -1)'
        repeat: expr
        repeat-expr: loop_range

      - id: re #,"E","1","Reserved Expansion Field","N.A."),
        type: asterix_explicit("RE",true)
        if: fspec.size >= 48 and fspec.octects[1].bits[5]

      - id: sp #,"E","1","Special Purpose Field","N.A."),
        type: asterix_explicit("SP",true)
        if: fspec.size >= 49 and fspec.octects[1].bits[6]

    instances:

      uap_list:
        value: uap.as<u2[]>

      loop_range:
        value: 'fspec.size > uap_list.size ? uap_list.size : fspec.size'
