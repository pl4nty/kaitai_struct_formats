# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/signing.ksy
# Licence and copyright: see _community/README.md
# Copyright (C) 2015-2023 Swift Navigation Inc.
# Contact: https://support.swiftnav.com
#
# This source is subject to the license found in the file 'LICENSE' which must
# be distributed together with this source. All other rights reserved.
#
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
#
# Messages relating to signatures
#
# Automatically generated from spec/yaml/swiftnav/sbp/signing.yaml with generate.py.
# Do not modify by hand!

meta:
  id: signing
  title: SBP signing messages
  license: MIT
  imports: [  ]
  endian: le

types:

  utc_time:
    seq:
      - id: year
        type: u2
        doc: Year
      - id: month
        type: u1
        doc: Month (range 1 .. 12)
      - id: day
        type: u1
        doc: days in the month (range 1-31)
      - id: hours
        type: u1
        doc: hours of day (range 0-23)
      - id: minutes
        type: u1
        doc: minutes of hour (range 0-59)
      - id: seconds
        type: u1
        doc: seconds of minute (range 0-60) rounded down
      - id: ns
        type: u4
        doc: nanoseconds of second (range 0-999999999)
  
  ecdsa_signature:
    seq:
      - id: len
        type: u1
        doc: |
          Number of bytes to use of the signature field.  The DER encoded
          signature has a maximum size of 72 bytes but can vary between 70 and
          72 bytes in length.
      - id: data
        type: u1
        repeat: expr
        repeat-expr: 72
        doc: |
          DER encoded ECDSA signature for the messages using SHA-256 as the
          digest algorithm.
  
  msg_ecdsa_certificate:
    doc: A DER encoded x.509 ECDSA-256 certificate (using curve secp256r1).
    seq:
      - id: n_msg
        type: u1
        doc: |
          Total number messages that make up the certificate. The first nibble
          (mask 0xF0 or left shifted by 4 bits) is the size of the sequence
          (n), second nibble (mask 0x0F) is the zero-indexed counter (ith
          packet of n).
      - id: certificate_id
        type: u1
        repeat: expr
        repeat-expr: 4
        doc: The last 4 bytes of the certificate's SHA-1 fingerprint
      - id: flags
        type: u1
      - id: certificate_bytes
        type: u1
        repeat: eos
        doc: DER encoded x.509 ECDSA certificate bytes
  
  msg_certificate_chain:
    seq:
      - id: root_certificate
        type: u1
        repeat: expr
        repeat-expr: 20
        doc: SHA-1 fingerprint of the root certificate
      - id: intermediate_certificate
        type: u1
        repeat: expr
        repeat-expr: 20
        doc: SHA-1 fingerprint of the intermediate certificate
      - id: corrections_certificate
        type: u1
        repeat: expr
        repeat-expr: 20
        doc: SHA-1 fingerprint of the corrections certificate
      - id: expiration
        type: utc_time
        doc: |
          The time after which the signature given is no longer valid.
          Implementors should consult a time source (such as GNSS) to check if
          the current time is later than the expiration time, if the condition
          is true, signatures in the stream should not be considered valid.
      - id: signature
        type: ecdsa_signature
        doc: |
          Signature (created by the root certificate) over the concatenation
          of the SBP payload bytes preceding this field. That is, the
          concatenation of `root_certificate`, `intermediate_certificate`,
          `corrections_certificate` and `expiration`.  This certificate chain
          (allow list) can also be validated by fetching it from
          `http(s)://certs.swiftnav.com/chain`.
  
  msg_certificate_chain_dep:
    doc: Deprecated.
    seq:
      - id: root_certificate
        type: u1
        repeat: expr
        repeat-expr: 20
        doc: SHA-1 fingerprint of the root certificate
      - id: intermediate_certificate
        type: u1
        repeat: expr
        repeat-expr: 20
        doc: SHA-1 fingerprint of the intermediate certificate
      - id: corrections_certificate
        type: u1
        repeat: expr
        repeat-expr: 20
        doc: SHA-1 fingerprint of the corrections certificate
      - id: expiration
        type: utc_time
        doc: |
          The certificate chain comprised of three fingerprints: root
          certificate, intermediate certificate and corrections certificate.
      - id: signature
        type: u1
        repeat: expr
        repeat-expr: 64
        doc: |
          An ECDSA signature (created by the root certificate) over the
          concatenation of the SBP payload bytes preceding this field. That
          is, the concatenation of `root_certificate`,
          `intermediate_certificate`, `corrections_certificate` and
          `expiration`.  This certificate chain (allow list) can also be
          validated by fetching it from `http(s)://certs.swiftnav.com/chain`.
  
  msg_aes_cmac_signature:
    doc: Digital signature using AES-CMAC 128 algorithm used for data integrity.
    seq:
      - id: stream_counter
        type: u1
        doc: |
          Signature message counter. Zero indexed and incremented with each
          signature message.  The counter will not increment if this message
          was in response to an on demand request.  The counter will roll over
          after 256 messages. Upon connection, the value of the counter may
          not initially be zero.
      - id: on_demand_counter
        type: u1
        doc: |
          On demand message counter. Zero indexed and incremented with each
          signature message sent in response to an on demand message. The
          counter will roll over after 256 messages.  Upon connection, the
          value of the counter may not initially be zero.
      - id: certificate_id
        type: u1
        repeat: expr
        repeat-expr: 4
        doc: The last 4 bytes of the certificate's SHA-1 fingerprint
      - id: signature
        type: u1
        repeat: expr
        repeat-expr: 16
        doc: Signature (CMAC tag value)
      - id: flags
        type: u1
        doc: Describes the format of the 'signed_messages' field.
      - id: signed_messages
        type: u1
        repeat: eos
        doc: |
          CRCs of the messages covered by this signature.  For Skylark, which
          delivers SBP messages wrapped in Swift's proprietary RTCM message,
          these are the 24-bit CRCs from the RTCM message framing. For SBP
          only streams, this will be 16-bit CRCs from the SBP framing.  See
          the `flags` field to determine the type of CRCs covered.
  
  msg_ecdsa_signature:
    doc: An ECDSA-256 signature using SHA-256 as the message digest algorithm.
    seq:
      - id: flags
        type: u1
        doc: Describes the format of the 'signed_messages' field.
      - id: stream_counter
        type: u1
        doc: |
          Signature message counter. Zero indexed and incremented with each
          signature message.  The counter will not increment if this message
          was in response to an on demand request.  The counter will roll over
          after 256 messages. Upon connection, the value of the counter may
          not initially be zero.
      - id: on_demand_counter
        type: u1
        doc: |
          On demand message counter. Zero indexed and incremented with each
          signature message sent in response to an on demand message. The
          counter will roll over after 256 messages.  Upon connection, the
          value of the counter may not initially be zero.
      - id: certificate_id
        type: u1
        repeat: expr
        repeat-expr: 4
        doc: The last 4 bytes of the certificate's SHA-1 fingerprint
      - id: signature
        type: ecdsa_signature
        doc: Signature over the frames of this message group.
      - id: signed_messages
        type: u1
        repeat: eos
        doc: |
          CRCs of the messages covered by this signature.  For Skylark, which
          delivers SBP messages wrapped in Swift's proprietary RTCM message,
          these are the 24-bit CRCs from the RTCM message framing. For SBP
          only streams, this will be 16-bit CRCs from the SBP framing.  See
          the `flags` field to determine the type of CRCs covered.
  
  msg_ecdsa_signature_dep_b:
    doc: Deprecated.
    seq:
      - id: flags
        type: u1
        doc: Describes the format of the 'signed_messages' field.
      - id: stream_counter
        type: u1
        doc: |
          Signature message counter. Zero indexed and incremented with each
          signature message.  The counter will not increment if this message
          was in response to an on demand request.  The counter will roll over
          after 256 messages. Upon connection, the value of the counter may
          not initially be zero.
      - id: on_demand_counter
        type: u1
        doc: |
          On demand message counter. Zero indexed and incremented with each
          signature message sent in response to an on demand message. The
          counter will roll over after 256 messages.  Upon connection, the
          value of the counter may not initially be zero.
      - id: certificate_id
        type: u1
        repeat: expr
        repeat-expr: 4
        doc: The last 4 bytes of the certificate's SHA-1 fingerprint
      - id: n_signature_bytes
        type: u1
        doc: |
          Number of bytes to use of the signature field.  The DER encoded
          signature has a maximum size of 72 bytes but can vary between 70 and
          72 bytes in length.
      - id: signature
        type: u1
        repeat: expr
        repeat-expr: 72
        doc: |
          DER encoded ECDSA signature for the messages using SHA-256 as the
          digest algorithm.
      - id: signed_messages
        type: u1
        repeat: eos
        doc: |
          CRCs of the messages covered by this signature.  For Skylark, which
          delivers SBP messages wrapped in Swift's proprietary RTCM message,
          these are the 24-bit CRCs from the RTCM message framing. For SBP
          only streams, this will be 16-bit CRCs from the SBP framing.  See
          the `flags` field to determine the type of CRCs covered.
  
  msg_ecdsa_signature_dep_a:
    doc: Deprecated.
    seq:
      - id: flags
        type: u1
        doc: Describes the format of the 'signed_messages' field.
      - id: stream_counter
        type: u1
        doc: |
          Signature message counter. Zero indexed and incremented with each
          signature message.  The counter will not increment if this message
          was in response to an on demand request.  The counter will roll over
          after 256 messages. Upon connection, the value of the counter may
          not initially be zero.
      - id: on_demand_counter
        type: u1
        doc: |
          On demand message counter. Zero indexed and incremented with each
          signature message sent in response to an on demand message. The
          counter will roll over after 256 messages.  Upon connection, the
          value of the counter may not initially be zero.
      - id: certificate_id
        type: u1
        repeat: expr
        repeat-expr: 4
        doc: The last 4 bytes of the certificate's SHA-1 fingerprint
      - id: signature
        type: u1
        repeat: expr
        repeat-expr: 64
        doc: |
          ECDSA signature for the messages using SHA-256 as the digest
          algorithm.
      - id: signed_messages
        type: u1
        repeat: eos
        doc: |
          CRCs of the messages covered by this signature.  For Skylark, which
          delivers SBP messages wrapped in Swift's proprietary RTCM message,
          these are the 24-bit CRCs from the RTCM message framing. For SBP
          only streams, this will be 16-bit CRCs from the SBP framing.  See
          the `flags` field to determine the type of CRCs covered.
  
  msg_ed25519_certificate_dep:
    doc: Deprecated.
    seq:
      - id: n_msg
        type: u1
        doc: |
          Total number messages that make up the certificate. First nibble is
          the size of the sequence (n), second nibble is the zero-indexed
          counter (ith packet of n)
      - id: fingerprint
        type: u1
        repeat: expr
        repeat-expr: 20
        doc: SHA-1 fingerprint of the associated certificate.
      - id: certificate_bytes
        type: u1
        repeat: eos
        doc: ED25519 certificate bytes.
  
  msg_ed25519_signature_dep_a:
    doc: Deprecated.
    seq:
      - id: signature
        type: u1
        repeat: expr
        repeat-expr: 64
        doc: ED25519 signature for messages.
      - id: fingerprint
        type: u1
        repeat: expr
        repeat-expr: 20
        doc: SHA-1 fingerprint of the associated certificate.
      - id: signed_messages
        type: u4
        repeat: eos
        doc: CRCs of signed messages.
  
  msg_ed25519_signature_dep_b:
    doc: Deprecated.
    seq:
      - id: stream_counter
        type: u1
        doc: |
          Signature message counter. Zero indexed and incremented with each
          signature message.  The counter will not increment if this message
          was in response to an on demand request.  The counter will roll over
          after 256 messages. Upon connection, the value of the counter may
          not initially be zero.
      - id: on_demand_counter
        type: u1
        doc: |
          On demand message counter. Zero indexed and incremented with each
          signature message sent in response to an on demand message. The
          counter will roll over after 256 messages.  Upon connection, the
          value of the counter may not initially be zero.
      - id: signature
        type: u1
        repeat: expr
        repeat-expr: 64
        doc: ED25519 signature for messages.
      - id: fingerprint
        type: u1
        repeat: expr
        repeat-expr: 20
        doc: SHA-1 fingerprint of the associated certificate.
      - id: signed_messages
        type: u4
        repeat: eos
        doc: CRCs of signed messages.
  
