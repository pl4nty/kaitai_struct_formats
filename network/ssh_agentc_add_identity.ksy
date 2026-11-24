# Imported from https://github.com/connectbot/cbssh/blob/d09fe14dad0155ffcf0f8c6aa177067013cf14bd/protocol/src/main/resources/kaitai/ssh_agentc_add_identity.ksy
meta:
  id: ssh_agentc_add_identity
  title: SSH agent add identity
  license: Apache-2.0
  imports:
    - ssh_agent_enums
    - ssh_ascii_string
    - ssh_byte_string
    - ssh_mpint
  endian: be
seq:
  - id: key_type
    type: ssh_ascii_string
    valid:
      expr: _.value == "ssh-rsa" or _.value == "ssh-dss" or _.value == "ecdsa-sha2-nistp256" or _.value == "ecdsa-sha2-nistp384" or _.value == "ecdsa-sha2-nistp521"
  - id: key
    type:
      switch-on: key_type.value
      cases:
        '"ssh-rsa"': rsa
        '"ssh-dss"': dsa
        '"ecdsa-sha2-nistp256"': ec
        '"ecdsa-sha2-nistp384"': ec
        '"ecdsa-sha2-nistp521"': ec
  - id: comment
    type: ssh_byte_string
  - id: constraints
    type: constraint
    repeat: eos
types:
  rsa:
    seq:
      - id: n
        type: ssh_mpint
      - id: e
        type: ssh_mpint
      - id: d
        type: ssh_mpint
      - id: iqmp
        type: ssh_mpint
      - id: p
        type: ssh_mpint
      - id: q
        type: ssh_mpint
  dsa:
    seq:
      - id: p
        type: ssh_mpint
      - id: q
        type: ssh_mpint
      - id: g
        type: ssh_mpint
      - id: y
        type: ssh_mpint
      - id: x
        type: ssh_mpint
  ec:
    seq:
      - id: curve
        type: ssh_ascii_string
      - id: point
        type: ssh_byte_string
      - id: scalar
        type: ssh_mpint
  constraint:
    seq:
      - id: kind
        type: u1
        enum: ssh_agent_enums::constraint_kind
        valid:
          any-of: [ssh_agent_enums::constraint_kind::lifetime, ssh_agent_enums::constraint_kind::confirm]
      - id: lifetime
        type: u4
        if: kind == ssh_agent_enums::constraint_kind::lifetime
