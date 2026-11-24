# Imported from https://github.com/connectbot/cbssh/blob/d09fe14dad0155ffcf0f8c6aa177067013cf14bd/protocol/src/main/resources/kaitai/ssh_agent_message.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ssh_agent_message
  title: SSH Agent Protocol Message
  license: Apache-2.0
  imports:
    - ssh_agent_enums
    - ssh_agentc_request_identities
    - ssh_agentc_sign_request
    - ssh_agentc_extension
    - ssh_agentc_add_identity
    - ssh_agentc_remove_identity
    - ssh_agentc_lock
  endian: be
doc: |
  Top-level SSH agent protocol message framing (IETF draft-miller-ssh-agent).
  Used for SSH agent forwarding where remote servers make agent requests.
seq:
  - id: length
    type: u4
    valid:
      expr: _ >= 1 and _ == _io.size - _io.pos
    doc: Length of message_type + payload
  - id: message_type
    type: u1
    enum: ssh_agent_enums::message_type
    doc: Agent message type code
  - id: payload
    size: length - 1
    type:
      switch-on: message_type
      cases:
        'ssh_agent_enums::message_type::request_identities': ssh_agentc_request_identities
        'ssh_agent_enums::message_type::sign_request': ssh_agentc_sign_request
        'ssh_agent_enums::message_type::add_identity': ssh_agentc_add_identity
        'ssh_agent_enums::message_type::remove_identity': ssh_agentc_remove_identity
        'ssh_agent_enums::message_type::remove_all_identities': ssh_agentc_request_identities
        'ssh_agent_enums::message_type::lock': ssh_agentc_lock
        'ssh_agent_enums::message_type::unlock': ssh_agentc_lock
        'ssh_agent_enums::message_type::add_id_constrained': ssh_agentc_add_identity
        'ssh_agent_enums::message_type::extension': ssh_agentc_extension
