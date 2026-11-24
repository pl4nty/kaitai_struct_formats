# Imported from https://github.com/connectbot/cbssh/blob/d09fe14dad0155ffcf0f8c6aa177067013cf14bd/protocol/src/main/resources/kaitai/ssh_agentc_request_identities.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ssh_agentc_request_identities
  title: SSH_AGENTC_REQUEST_IDENTITIES
  license: Apache-2.0
  endian: be
doc: |
  Request identities message (type 11).
  Server requests list of available public keys from the agent.
  Has no payload beyond the message type.
seq: []
