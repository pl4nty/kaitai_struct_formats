# Imported from https://github.com/audienceproject/tcf-parser-java/blob/8deca2ce0deafe8fb2f4ec088c7e7cbc7b075fae/src/main/resources/tcf_core.ksy
meta:
  id: iab_tcf_v2_core
  title: IAB TCF v2 core string
  license: MIT
  endian: be
seq:
  - id: version
    type: b6
    doc: TC string format version (1 or 2).
  - id: created
    type: b36
    doc: Time the TC string was created, in deciseconds since the Unix epoch.
  - id: last_updated
    type: b36
    doc: |
      Time the TC string was last updated, in deciseconds since the Unix
      epoch.
  - id: cmp_id
    type: b12
    doc: |
      ID of the Consent Management Platform (CMP) that last updated the
      string.
  - id: cmp_version
    type: b12
    doc: Version of the CMP that last updated the string.
  - id: consent_screen
    type: b6
    doc: CMP-specific number of the screen on which consent was given.
  - id: consent_language
    type: letter_code
    doc: Two-letter ISO 639-1 language code of the consent dialog.
  - id: vendor_list_version
    type: b12
    doc: Version of the Global Vendor List used when the string was last updated.
  - id: core_string_v1
    type: core_string_v1
    if: version == 1
  - id: core_string_v2
    type: core_string_v2
    if: version == 2
types:
  letter_code:
    seq:
      - id: first
        type: b6
        doc: First letter, 0 = A to 25 = Z.
      - id: second
        type: b6
        doc: Second letter, 0 = A to 25 = Z.
  core_string_v1:
    seq:
      - id: purposes_allowed
        type: b1
        repeat: expr
        repeat-expr: 24
      - id: vendors
        type: vendor_section
    types:
      vendor_section:
        seq:
          - id: max_vendor_id
            type: b16
          - id: encoding_type
            type: b1
            enum: encoding_type
          - id: bit_field
            type: b1
            repeat: expr
            repeat-expr: max_vendor_id
            if: encoding_type == encoding_type::bit_field
          - id: range_section
            type: range_section
            if: encoding_type == encoding_type::range
      range_section:
        seq:
          - id: default_consent
            type: b1
          - id: num_entries
            type: b12
          - id: range_entries
            type: range_entry
            repeat: expr
            repeat-expr: num_entries
      range_entry:
        seq:
          - id: single_or_range
            type: b1
            enum: single_or_range
          - id: single_vendor_id
            type: b16
            if: single_or_range == single_or_range::single
          - id: start_vendor_id
            type: b16
            if: single_or_range == single_or_range::range
          - id: end_vendor_id
            type: b16
            if: single_or_range == single_or_range::range
    enums:
      encoding_type:
        0: bit_field
        1: range
      single_or_range:
        0: single
        1: range
  core_string_v2:
    seq:
      - id: tcf_policy_version
        type: b6
        doc: Version of the TCF policy the string was created under.
      - id: is_service_specific
        type: b1
        doc: |
          Whether the signals apply only to the service that set them, rather
          than globally.
      - id: use_non_standard_stacks
        type: b1
        doc: |
          Whether the CMP used non-IAB standard stacks or texts in the consent
          dialog.
      - id: special_feature_opt_ins
        type: b12
        doc: |
          Opt-in bit per special feature, most significant bit is special
          feature 1.
      - id: purposes_consent
        type: b1
        repeat: expr
        repeat-expr: 24
        doc: Consent bit per purpose, purposes 1 to 24.
      - id: purposes_li_transparency
        type: b1
        repeat: expr
        repeat-expr: 24
        doc: Legitimate interest transparency bit per purpose, purposes 1 to 24.
      - id: specific_jurisdiction_disclosures
        type: specific_jurisdiction_disclosures
      - id: vendor_consent
        type: vendor_section
        doc: Vendors that the user consented to.
      - id: vendor_legitimate_interest
        type: vendor_section
        doc: |
          Vendors whose legitimate interest disclosure the user saw (and did
          not object to).
      - id: publisher_restrictions
        type: publisher_restrictions_section
        doc: Restrictions the publisher put on vendors' purposes.
    types:
      specific_jurisdiction_disclosures:
        seq:
          - id: purpose_one_treatment
            type: b1
            doc: |
              Whether purpose 1 was disclosed differently, as allowed in some
              jurisdictions.
          - id: publisher_cc
            type: letter_code
            doc: ISO 3166-1 alpha-2 country code of the publisher.
      vendor_section:
        seq:
          - id: max_vendor_id
            type: b16
          - id: is_range_encoding
            type: b1
          - id: bit_field
            type: b1
            repeat: expr
            repeat-expr: max_vendor_id
            if: not is_range_encoding
          - id: range_section
            type: range_section
            if: is_range_encoding
      publisher_restrictions_section:
        seq:
          - id: num_pub_restrictions
            type: b12
            doc: Number of restriction entries.
          - id: pub_restriction_entries
            type: pub_restriction_entry
            repeat: expr
            repeat-expr: num_pub_restrictions
            if: num_pub_restrictions > 0
        types:
          pub_restriction_entry:
            seq:
              - id: purpose_id
                type: b6
                doc: Purpose the restriction applies to.
              - id: restriction_type
                type: b2
                enum: restriction_type
                doc: Type of the restriction.
              - id: range_section
                type: range_section
                doc: Vendors the restriction applies to.
        enums:
          restriction_type:
            0: not_allowed
            1: require_consent
            2: require_legitimate_interest
            3: undefined
      range_section:
        seq:
          - id: num_entries
            type: b12
          - id: range_entries
            type: range_entry
            repeat: expr
            repeat-expr: num_entries
      range_entry:
        seq:
          - id: is_a_range
            type: b1
          - id: start_or_only_vendor_id
            type: b16
          - id: end_vendor_id
            type: b16
            if: is_a_range
enums:
  purposes_v1:
    0: storage_and_access
    1: personalization
    2: ad_selection
    3: content_delivery
    4: measurement
  purposes_v2:
    0: storage_and_access
    1: basic_selection
    2: ad_profiling
    3: ad_personalization
    4: content_profiling
    5: content_personalization
    6: ad_measurement
    7: content_measurement
    8: market_research
    9: develop_and_improve
