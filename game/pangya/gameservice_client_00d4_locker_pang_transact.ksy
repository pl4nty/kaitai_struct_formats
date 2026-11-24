# Imported from https://github.com/pangbox/packetdoc/blob/d61f583a3e67e37695f7f560f7dc9af0fcf6e7e8/src/packets/gameservice/client/00d4.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gameservice_client_00d4_locker_pang_transact
  title: GameService Client Locker Pang Transact
  license: ISC
  imports:
    - pstring
  encoding: ASCII
  endian: le

doc: |
  This packet either deposits or withdraws some amount of pang from the locker.
  
  The responses are:
  * [GameService Server 0x0171 Locker Pang Transact
    Response](/packets/gameservice/server/0171.ksy),
  * [GameService Server 0x00C8 Pang
    Balance](/packets/gameservice/server/00c8.ksy), and
  * [GameService Server 0x0172 Locker Pang
    Balance](/packets/gameservice/server/0172.ksy).
  
  **Aliases:**
  * `hsreina/pangya-server`: `PLAYER_LOCKER_PANGS_TRANSACTION`
  * `eantoniobr/UGPangya`: `PLAYER_LOCKERPANG_CONTROL`

seq:
  - id: transaction_type
    type: u1
    enum: transaction_type
    doc: Sets whether to deposit or withdraw funds.
  - id: pang_amount
    type: u4
    doc: Amount to deposit or withdraw.
  - id: unknown_a
    size: 4
    doc: All 0x00.

enums:
  transaction_type:
    0x00: pang_withdrawal
    0x01: pang_deposit
