# Imported from https://gist.githubusercontent.com/generalmimon/3702ee8aee7794309f13dd0e32f41dc1/raw/15b669623ecbfaa9ea2b882a51cb572142ed0f2b/github_new_auth_token.ksy
meta:
  id: github_new_auth_token
  title: GitHub authentication token
  license: CC0-1.0
  encoding: ASCII
doc: |
  The format of new (April 2021) GitHub authentication tokens, which superseded
  the old 40-character hex encoded tokens.
  You can generate one at <https://github.com/settings/tokens>.
  
  A token is `ghp_` (or another prefix) followed by a 30-character Base62
  `secret` and a 6-character `crc32_base62`, the Base62 encoding of the
  CRC-32 of `secret`. The worked example token from the original gist is
  omitted here so that secret scanners do not flag it.
doc-ref: https://github.blog/2021-04-05-behind-githubs-new-authentication-token-formats/
seq:
  - id: prefix
    size: 4
    type: str
    terminator: 0x5f # _ (underscore)
  - id: secret
    size: 30
    type: str
    doc: |
      The random part in the token (according to GitHub:
      <https://github.blog/2021-04-05-behind-githubs-new-authentication-token-formats/#token-entropy>,
      it is fully random).
      
      It should probably not be treated as Base62-encoded. Although it contains
      only lower/upper case alphanumeric characters, the following CRC-32 checksum
      is calculated from the literal string value (not decoded in any way).
  - id: crc32_base62
    size: 6
    type: str
    doc: |
      The CRC-32 checksum of the `secret` string in ASCII, encoded as Base62
      and left-padded with `0` characters (digit zero, 48 or 0x30 in ASCII).
      The Base62 alphabet used is `0-9A-Za-z`.
instances:
  token_type:
    value: >-
      prefix == 'ghp' ? token_types::personal_access :
      prefix == 'gho' ? token_types::oauth_access :
      prefix == 'ghu' ? token_types::gh_app_user2server :
      prefix == 'ghs' ? token_types::gh_app_server2server :
      prefix == 'ghr' ? token_types::gh_app_refresh :
      token_types::invalid
enums:
  token_types:
    -1: invalid
    0: personal_access
    1: oauth_access
    2: gh_app_user2server
    3: gh_app_server2server
    4: gh_app_refresh
