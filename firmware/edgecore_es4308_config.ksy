# Imported from https://github.com/dlorent/es4308cfg/blob/3435d03434009cee57c1a5421500b84fa6d661be/spec/es4308.ksy
# Licence and copyright: see _community/README.md
meta:
  id: edgecore_es4308_config
  title: Edgecore ES4308-PoE NVRAM config (CONF/MW)
  file-extension: cfg
  license: MIT
  endian: be
doc: |
  Reverse-engineered structure of the binary config produced by the Edgecore
  ES4308-PoE web UI (SYSTEM -> Tools -> Download) and consumed by Upload/Restore.

  Fixed 1056-byte image: a 32-byte header followed by a 1024-byte body of
  length-prefixed records. All multi-byte integers are big-endian.

  This spec is read-only structure description. The two checksums in the header
  (cksum_a at 0x06:07 and cksum_b at 0x0d) are parsed as raw values only; Kaitai
  does not recompute them. See es4308cfg/docs/FORMAT.md for the checksum formulas.
doc-ref: es4308cfg/docs/FORMAT.md

seq:
  - id: header
    type: header
  - id: body
    size: header.body_length
    type: body

types:
  header:
    doc: 32-byte fixed header.
    seq:
      - id: magic
        contents: "CONF "
        doc: 5-byte magic (43 4F 4E 46 20).
      - id: version
        type: u1
      - id: cksum_a
        type: u2
        doc: 16-bit sum of file[0x10:], big-endian. Parsed only, not verified.
      - id: body_length
        type: u4
        doc: Body length, always 0x400 (1024).
      - id: const_0c
        contents: [0x01]
        doc: Constant byte, always 0x01.
      - id: cksum_b
        type: u1
        doc: 1-byte checksum B. Parsed only, not verified.
      - id: device_const
        type: u2
        doc: Device/serial constant (also present in record 0x05).
      - id: pad
        size: 16
        doc: Zero padding.

  body:
    doc: |
      Flat sequence of records. Order is preserved and NOT sorted (type 0x14 may
      appear before 0x13). The body is exactly body_length bytes; records are
      read until the substream is exhausted.
    seq:
      - id: records
        type: record
        repeat: eos
    instances:
      vlan_slot_table:
        io: _root._io
        pos: 0x08d
        type: vlan_slot
        repeat: expr
        repeat-expr: 64
        doc: |
          VLAN slot table living inside record 0x00, at absolute file offset
          0x08d. 64 fixed slots of {vid: u2be, flag: u1}. Empty slot = FF FF 00.
          Slots are filled in creation order (not sorted by VID). flag is a
          bitmask of member ports (see FORMAT.md port->bit map).

  vlan_slot:
    seq:
      - id: vid
        type: u2
      - id: flag
        type: u1
        doc: Bitmask of member ports. FF FF 00 marks an empty slot.
    instances:
      is_empty:
        value: vid == 0xffff

  record:
    doc: 'One record: BA BE | type(u1) | flag(u1) | len(u2be) | data[len].'
    seq:
      - id: marker
        contents: [0xba, 0xbe]
      - id: rec_type
        type: u1
        enum: record_type
      - id: flag
        type: u1
      - id: len
        type: u2
      - id: data
        size: len
        type:
          switch-on: rec_type
          cases:
            'record_type::mgmt': mgmt
            'record_type::identity': identity
            'record_type::poe': poe
            'record_type::presence': presence
        doc: |
          Typed body where FORMAT.md documents it, otherwise raw bytes. Unknown
          records are kept verbatim as their raw data slice.

  mgmt:
    doc: 'Record 0x02: in-band management interface.'
    seq:
      - id: kind
        type: u1
        doc: Always 0x01 in observed samples.
      - id: vid
        type: u2
        doc: Management VLAN ID.
      - id: ip
        size: 4
        doc: Management IPv4 address (4 bytes, big-endian octets).
      - id: gateway
        size: 4
        doc: Default gateway IPv4 address.
      - id: netmask
        size: 4
        doc: Subnet mask.

  identity:
    doc: |
      Record 0x05: device identity. Layout is a 6-byte lead, then a serial blob and
      padding, then the base MAC at data offset 0x16, then a trailing second copy.
      Modeled minimally: skip to the MAC, expose it, keep the rest raw.
    seq:
      - id: pre
        size: 0x16
        doc: Lead + serial + pad, up to the MAC.
      - id: mac
        size: 6
        doc: Base MAC address (e.g. 00:12:cf:00:00:01 on the real unit).
      - id: rest
        size-eos: true
        doc: Trailer + a second identity copy. Not decoded.

  poe:
    doc: |
      Record 0x0b: Power over Ethernet configuration. Both the enable bitmask and
      the priority array index ports in a nibble-split order (web ports 1-4 -> slots
      4..7, ports 5-8 -> slots 0..3), NOT the VLAN PORT_BIT map — confirmed by
      disabling PoE on ports 3/5/6 and setting port 6 priority Critical. See
      FORMAT.md.
    seq:
      - id: reserved0
        type: u1
        doc: Leading flag byte (0x00 observed).
      - id: enable_bitmask
        type: u1
        doc: Per-port enable bitmask (0xff = all ports on); nibble-split port order.
      - id: priority
        type: u1
        repeat: expr
        repeat-expr: 8
        doc: Per-port PoE priority (0=low..3=critical); nibble-split port order.
      - id: limit
        type: u2
        repeat: expr
        repeat-expr: 8
        doc: Per-port power limit, u16 in units of 0.1 W (0x009a = 15.4 W).
      - id: rest
        size-eos: true
        doc: Any trailing bytes.

  presence:
    doc: |
      Record 0x12: per-VLAN-slot presence array. One byte per slot index,
      matching the slot index in body.vlan_slot_table. 0xC0 = VLAN present,
      0x00 = empty.
    seq:
      - id: slots
        type: u1
        repeat: eos

enums:
  record_type:
    0x00: defaults
    0x01: port_arrays
    0x02: mgmt
    0x03: unknown_03
    0x05: identity
    0x06: snmp
    0x07: port_07
    0x08: port_08
    0x09: stp_timers
    0x0a: user_table
    0x0b: poe
    0x0d: unknown_0d
    0x0f: lldp_per_port
    0x10: unknown_10
    0x11: unknown_11
    0x12: presence
    0x13: unknown_13
    0x14: unknown_14
