# Imported from https://github.com/connectbot/cbssh/blob/d09fe14dad0155ffcf0f8c6aa177067013cf14bd/protocol/src/main/resources/kaitai/ssh_agentc_lock.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ssh_agentc_lock
  title: SSH agent lock or unlock
  license: Apache-2.0
  imports:
    - ssh_byte_string
  endian: be
seq:
  - id: passphrase
    type: ssh_byte_string
