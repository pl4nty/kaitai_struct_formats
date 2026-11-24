meta:
  id: bitcoin_transaction
  title: Bitcoin Transaction
  license: MIT
  endian: le
doc-ref: |
  https://bitcoin.org/en/developer-guide#transactions
  https://en.bitcoin.it/wiki/Transaction
seq:
  - id: version
    type: u4
    doc: Version number.
  - id: num_vins
    type: var_int
    doc: Number of input transactions.
  - id: vins
    type: vin
    repeat: expr
    repeat-expr: num_vins.value
    doc: |
      Input transactions.
      An input refers to an output from a previous transaction.
  - id: num_vouts
    type: var_int
    doc: Number of output transactions.
  - id: vouts
    type: vout
    repeat: expr
    repeat-expr: num_vouts.value
    doc: Output transactions.
  - id: locktime
    type: u4
types:
  var_int:
    doc: |
      Variable-length integer ("CompactSize"): values below 0xfd are stored in
      the first byte; 0xfd, 0xfe and 0xff announce a following u2, u4 or u8.
    doc-ref: https://en.bitcoin.it/wiki/Protocol_documentation#Variable_length_integer
    seq:
      - id: flag
        type: u1
      - id: data
        type:
          switch-on: flag
          cases:
            0xfd: u2
            0xfe: u4
            0xff: u8
        if: flag >= 0xfd
    instances:
      value:
        value: 'flag < 0xfd ? flag : data'
  vin:
    seq:
      - id: txid
        size: 32
        doc: Previous transaction hash.
      - id: output_id
        type: u4
        doc: |
          ID indexing an output of the transaction referred by txid.
          This output will be used as an input in the present transaction.
      - id: len_script
        type: var_int
        doc: ScriptSig's length.
      - id: script_sig
        size: len_script.value
        type: script_signature
        doc: ScriptSig.
        doc-ref: |
          https://en.bitcoin.it/wiki/Transaction#Input
          https://en.bitcoin.it/wiki/Script
      - id: sequence
        type: u4
        doc: |
          Sequence number (nSequence). 0xffffffff in transactions that use
          neither lock time nor relative lock time; 0xfffffffe and lower values
          are common (BIP 68 relative lock time, BIP 125 replace-by-fee).
        doc-ref: https://en.bitcoin.it/wiki/Transaction#Input
    types:
      script_signature:
        seq:
          - id: len_sig_stack
            type: u1
          - id: der_sig
            type: der_signature
            doc: DER-encoded ECDSA signature.
            doc-ref: |
              https://en.wikipedia.org/wiki/X.690#DER_encoding
              https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm
          - id: sig_type
            type: u1
            enum: sighash_type
            doc: Type of signature.
          - id: len_pubkey_stack
            type: u1
          - id: pubkey
            type: public_key
            doc: Public key (bitcoin address of the recipient).
        types:
          der_signature:
            seq:
              - id: sequence
                contents: [0x30]
              - id: len_sig
                type: u1
              - id: sep_1
                contents: [0x02]
              - id: len_sig_r
                type: u1
                doc: |
                  'r' value's length.
              - id: sig_r
                size: len_sig_r
                doc: |
                  'r' value of the ECDSA signature.
                doc-ref: 'https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm'
              - id: sep_2
                contents: [0x02]
              - id: len_sig_s
                type: u1
                doc: |
                  's' value's length.
              - id: sig_s
                size: len_sig_s
                doc: |
                  's' value of the ECDSA signature.
                doc-ref: 'https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm'
          public_key:
            seq:
              - id: type
                type: u1
              - id: x
                size: 32
                doc: |
                  'x' coordinate of the public key on the elliptic curve.
              - id: y
                size: 32
                doc: |
                  'y' coordinate of the public key on the elliptic curve.
        enums:
          sighash_type:
            1: sighash_all
            2: sighash_none
            3: sighash_single
            0x80: sighash_anyonecanpay
            0x81: sighash_all_anyonecanpay
            0x82: sighash_none_anyonecanpay
            0x83: sighash_single_anyonecanpay
  vout:
    seq:
      - id: amount
        type: u8
        doc: Number of Satoshis to be transferred.
      - id: len_script
        type: var_int
        doc: ScriptPubKey's length.
      - id: script_pub_key
        size: len_script.value
        doc: ScriptPubKey.
        doc-ref: |
          https://en.bitcoin.it/wiki/Transaction#Output
          https://en.bitcoin.it/wiki/Script
