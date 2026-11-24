# Imported from https://github.com/connectbot/cbssh/blob/d09fe14dad0155ffcf0f8c6aa177067013cf14bd/protocol/src/main/resources/kaitai/ssh_agentc_extension.ksy
meta:
  id: ssh_agentc_extension
  title: SSH_AGENTC_EXTENSION
  license: Apache-2.0
  imports:
    - ssh_byte_string
  endian: be
doc: |
  Extension request message (type 27).
  Used for protocol extensions like session-bind@openssh.com.
seq:
  - id: extension_name
    type: ssh_byte_string
    doc: Extension name (e.g., "session-bind@openssh.com")
  - id: extension_data
    size-eos: true
    doc: Extension-specific payload
