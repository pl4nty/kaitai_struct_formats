# Imported from https://gist.githubusercontent.com/plowsec/ecd8f27c60787c85a347ed892bcf8146/raw/d00a28da264e3db0c4361c0b459d9e91d2676090/metsrv_config.ksy
meta:
  id: meterpreter_metsrv_config
  file-extension: mtp
  license: LicenseRef-All-Rights-Reserved
seq:
  - id: handle
    size: 8
  - id: exit_func
    type: u4le
  - id: expiry
    type: s4le
  - id: uuid
    size: 16
  - id: guid
    size: 16
  - id: url
    size: 1024
    type: str
    encoding: UTF-16LE
  - id: comms_timeout
    type: s4le
  - id: retry_total
    type: s4le
  - id: retry_wait
    type: s4le
  - id: hostname
    size: 256
    type: str
    encoding: UTF-8
  - id: username
    size: 128
    type: str
    encoding: UTF-8
  - id: password
    size: 128
    type: str
    encoding: UTF-8
  - id: ua
    size: 512
    type: str
    encoding: UTF-8
  - id: ssl_cert_hash
    size: 20
  - id: custom_headers
    size: 4
  - id: extension_size
    type: u4le
  - id: extension_data
    size: 411648
