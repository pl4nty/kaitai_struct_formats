# Imported from https://github.com/connectbot/cbssh/blob/d09fe14dad0155ffcf0f8c6aa177067013cf14bd/protocol/src/main/resources/kaitai/ssh_agentc_sign_request.ksy
# Licence and copyright: see _community/README.md
meta:
  id: ssh_agentc_sign_request
  title: SSH_AGENTC_SIGN_REQUEST
  license: Apache-2.0
  imports:
    - /security/byte_string
  endian: be
doc: |
  Sign request message (type 13).
  Server requests the agent to sign data with a specific key.
seq:
  - id: key_blob
    type: byte_string
    doc: Public key blob to sign with
  - id: data
    type: byte_string
    doc: Data to be signed
  - id: flags
    type: u4
    doc: Signature flags (0 for default, 2 for RSA_SHA2_256, 4 for RSA_SHA2_512)
