# Imported from https://github.com/connectbot/cbssh/blob/d09fe14dad0155ffcf0f8c6aa177067013cf14bd/protocol/src/main/resources/kaitai/ssh_agentc_remove_identity.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ssh_agentc_remove_identity
  title: SSH agent remove identity
  license: Apache-2.0
  imports:
    - ssh_byte_string
  endian: be
seq:
  - id: key_blob
    type: ssh_byte_string
