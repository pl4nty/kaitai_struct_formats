meta:
  id: pvz_users_dat
  application: Plants vs. Zombies
  file-extension: dat
  license: CC0-1.0
  encoding: ASCII
  endian: le
doc: |
  https://github.com/Freed-Wu/pvz.nvim provides tools to (de)serialize it.
doc-ref: https://github.com/chiaracoetzee/plants-vs-zombies-user-file-editor/blob/595523add14b649147218bcd059eeb18fe506e92/Plants%20vs.%20Zombies%20user%20file%20editor/FormSelectUser.cs#L111-L125
seq:
  - id: version
    type: u4
    valid: 0x0E
  - id: num_users
    type: u2
  - id: users
    type: user_entry
    repeat: expr
    repeat-expr: num_users
types:
  user_entry:
    seq:
      - id: len_name
        type: u2
      - id: name
        size: len_name
        type: str
      - id: timestamp
        type: u4
      - id: id
        type: u4
