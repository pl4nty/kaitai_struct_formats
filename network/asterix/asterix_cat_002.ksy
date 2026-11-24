meta:
  id: asterix_cat_002
  title: ASTERIX category 002
  license: GPL-3.0-only
  ks-version: 0.9
  imports:
    - asterix_field_spec
    - asterix_explicit
    - asterix_cat_002_catalog
  endian: be

doc: |
  Implementation of ASTERIX format.

  From Eurocontrol Asterix web page at
  https://www.eurocontrol.int/asterix

  Category 002 definition file
  Radar Data Exchange Part 2b
  Transmission of Monoradar Service Messages
  SUR.ET1.ST05.2000-STD-02b-01
  Edition : 1.0

doc-ref: |
  https://www.eurocontrol.int/publication/cat002-eurocontrol-standard-document-radar-data-exchange-part-2b

seq:
  - id: fspec
    type: asterix_field_spec

  - id: data
    type: uap_type(fspec, [10,0,20,30,41,50,60,70,100,90,80].as<u2[]>.as<str>)

instances:

  category:
    value: '"002"'

  version:
    value: '"1.00"'

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
        type: 'asterix_cat_002_catalog(fspec.octects[_index / 7].bits[_index % 7] ? uap_list[_index] : -1)'
        repeat: expr
        repeat-expr: loop_range


      - id: sp #,"E","1","Special Purpose Field","N.A."),
        type: asterix_explicit("SP",true)
        if: fspec.size >= 13 and fspec.octects[1].bits[5]

      - id: irfs #,"E","1","Reserved Expansion Field","N.A."),
        type: asterix_explicit("RFS",true)
        if: fspec.size >= 14 and fspec.octects[1].bits[6]


    instances:

      uap_list:
        value: uap.as<u2[]>

      loop_range:
        value: 'fspec.size > uap_list.size ? uap_list.size : fspec.size'
