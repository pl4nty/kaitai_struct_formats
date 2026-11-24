meta:
  id: dnsfire
  title: DNS Firewall Enforcer (dnsfire) notification datagram
  application: DNS Firewall Enforcer (BIND 9 dnsfire patch)
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  "DNS Firewall Enforcer" (dnsfire) is a proof-of-concept patch for the
  BIND 9 name server that reports every A and AAAA record it hands out to
  a firewall, so that the firewall only allows connections to addresses
  that were previously resolved through that DNS server.

  For each DNS response containing IN A or AAAA records (in the answer,
  authority or additional sections), the server sends one UDP datagram to
  the configured address. The datagram lists the records with their TTLs
  and ends with a SipHash-2-4 MAC computed with the 16-byte shared key
  over all preceding bytes. Integers are in network byte order.
doc-ref:
  - https://github.com/wupeka/dnsfire/blob/ea2721c07cb3ccbde6a635f7a309dc3370096528/bind9-dnsfire.patch
  - https://github.com/isc-projects/bind9/blob/main/lib/isc/include/isc/buffer.h
seq:
  - id: magic
    contents: DFE1
  - id: reserved
    type: u4
    doc: Always 0.
  - id: num_a_records
    type: u2
  - id: num_aaaa_records
    type: u2
  - id: a_records
    type: a_record
    repeat: expr
    repeat-expr: num_a_records
  - id: aaaa_records
    type: aaaa_record
    repeat: expr
    repeat-expr: num_aaaa_records
  - id: mac
    size: 8
    doc: SipHash-2-4 of all preceding bytes, keyed with the configured 16-byte key.
types:
  a_record:
    seq:
      - id: ttl
        type: u4
      - id: address
        size: 4
        doc: IPv4 address.
  aaaa_record:
    seq:
      - id: ttl
        type: u4
      - id: address
        size: 16
        doc: IPv6 address.
