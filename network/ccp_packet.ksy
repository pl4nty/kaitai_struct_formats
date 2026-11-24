meta:
  id: ccp_packet
  title: PPP Compression Control Protocol (CCP) packet
  xref:
    rfc: 1962
  license: LicenseRef-All-Rights-Reserved
  endian: be
doc: |
  The Compression Control Protocol negotiates the compression of the data
  sent over a PPP link. Its packets have the same layout as the ones of LCP
  and are carried in PPP frames with protocol number 0x80fd.
doc-ref: https://www.rfc-editor.org/rfc/rfc1962
seq:
  - id: code
    type: u1
    enum: code_enum
  - id: identifier
    type: u1
    doc: Matches replies to requests.
  - id: length
    type: u2
    doc: |
      Length of the packet in bytes, including `code`, `identifier` and
      this field. Anything that follows the packet is padding.
  - id: data
    size: length - 4
    type:
      switch-on: code
      cases:
        'code_enum::configure_request': options_type
        'code_enum::configure_ack': options_type
        'code_enum::configure_nak': options_type
        'code_enum::configure_reject': options_type
types:
  options_type:
    seq:
      - id: options
        type: option
        repeat: eos
  option:
    seq:
      - id: type
        type: u1
        enum: type_enum
      - id: length
        type: u1
        doc: Length of the option in bytes, including `type` and this field.
      - id: value
        size: length - 2
enums:
  code_enum:
    1: configure_request
    2: configure_ack
    3: configure_nak
    4: configure_reject
    5: terminate_request
    6: terminate_ack
    7: code_reject
    14: reset_request
    15: reset_ack
  type_enum:
    0: oui
    1: predictor_type_1
    2: predictor_type_2
    3: puddle_jumper
    16: hewlett_packard_ppc
    17: stac_lzs
    18: microsoft_ppc
    19: gandalf_fza
    20: v42bis
    21: bsd_compress
    23: lzs_dcp
    24: mvrca
    25: dce
    26: deflate
