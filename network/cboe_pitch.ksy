# Imported from https://github.com/haydenbbickerton/cboe-viewer/blob/cf647a7a7e366207aff327e2f4f65b393276e323/structs/cboe.ksy
meta:
  id: cboe_pitch
  title: Cboe PITCH market data
  license: LicenseRef-All-Rights-Reserved
# ks-debug: true
  encoding: ASCII
  endian: le
seq:
  - id: records
    type: record(_index, _io.pos)
    # size-eos: true
    eos-error: false
    repeat: eos
instances:
  num_record_entries:
    value: records.size
  record_type_mask:
    value: 0x08
    doc: Magic number to offset the position of the msgtype char in record.
types:
  record:
    params:
      - id: idx
        type: u4
      - id: ofs
        type: u4
    seq:
      - id: start_of_line
        contents: S
        doc: Magic starting char "S"
      - id: raw
        type: strz
        terminator: 0xd
        include: false
        consume: false
      - id: end_of_line
        contents: [0xd, 0xa] # CRLF
    instances:
      type_indicator:
        io: _root._io
        pos: data_offset + _root.record_type_mask
        size: 1
        type: str
      data:
        io: _root._io
        pos: data_offset
        size: data_size
        type:
          switch-on: type_indicator
          cases:
            '"B"': trade_break_message
            '"X"': order_cancel_message
            '"J"': auction_summary_message
            '"H"': trading_status_message
            '"s"': symbol_clear_message
            '"A"': add_order_message_short
            '"I"': auction_update_message
            '"P"': trade_message_short
            '"R"': retail_price_improvement_message
            '"r"': trade_message_long
            '"E"': order_executed_message
            '"d"': add_order_message_long
      data_offset:
        value: ofs + 1
      data_size:
        value: raw.length
  block:
    params:
      - id: type
        type: str
      - id: offset
        type: u2
      - id: length
        type: u2
    seq:
      - id: value
        size: length
        type: strz
  trade_break_message:
    doc: |-
      The Trade Break message is sent whenever an execution on Cboe is broken.
      Trade breaks are rare and only affect applications that rely upon Cboe
      execution based data. Applications that simply build a Cboe book can
      ignore Trade Break messages.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: Timestamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Trade Break message
      - id: execution_id
        type: block('base_36_numeric', 9, 12)
        doc: |-
          Cboe execution identifier of the execution that was broken.
          Execution ID refers to previously sent Order Execution or Trade
          message.
  order_cancel_message:
    doc: |-
      Order Cancel messages are sent when a visible order on the Cboe book is
      canceled in whole or in part.

      NOTE:  Order Modification messages (4.4.x) refer to an Order ID previously
      sent with an Add Order message. Multiple Order Modification messages may
      modify a single order and the effects are cumulative. Order Modification
      messages always reduce the remaining shares in the referenced open order
      by the number of shares indicated. When the remaining shares for an order
      reach zero, the order is dead and should be removed from the book.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: Timestamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Order Cancel message
      - id: order_id
        type: block('base_36_numeric', 9, 12)
        doc: |
          Order ID of a previously sent Add Order Message that has been reduced or
          cancelled
      - id: canceled_shares
        type: block('numeric', 21, 6)
        doc: Number of shares canceled
  auction_summary_message:
    doc: |-
      Auction Summary messages are used to disseminate the results of an auction
      of a Cboe listed security. An Opening Auction Summary message for each
      Cboe listed security is sent at the conclusion of its opening auction at
      9:30 a.m. and represents the Cboe official opening price. A Closing
      Auction Summary message for each Cboe listed security is sent at the
      conclusion of its closing auction at 4:00 p.m. and represents the Cboe
      official closing price. An IPO Auction Summary message for each Cboe
      listed security is sent at the conclusion of the IPO Auction and
      represents the official Cboe IPO opening price.

      Cboe Auction Summary messages support the Cboe Opening, Closing, Halt and
      IPO Auctions on the BZX Exchange. Refer to the Cboe US Equities Auction
      Process specification for more information on Cboe Auctions.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: Timestamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Auction Summary message
      - id: stock_symbol
        type: block('printable_ascii', 9, 8)
        doc: Stock symbol right padded with spaces.
      - id: auction_type
        type: block('alpha', 17, 1)
        doc: |-
          O = Opening Auction
          C = Closing Auction
          H = Halt Auction
          I = IPO Auction
      - id: price
        type: block('price', 18, 10)
        doc: Auction price
      - id: shares
        type: block('numeric', 28, 10)
        doc: Cumulative number of shares  executed during the auction
  trading_status_message:
    doc: |-
      The Trading Status message is used to indicate the current trading status
      of a security. A Trading Status message will be sent whenever a security’s
      trading status changes. In addition, Cboe will send a Trading Status
      message for all securities that are “Halted” or have a price test in
      effect before the start of trading hours.

      Trading Status of `S` will be implied at system startup. `T` will be sent
      as securities are available for trading. `A` will be distributed when
      orders can be accepted for queuing in preparation for the market open.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: Timestamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Trading Status message
      - id: stock_symbol
        type: block('printable_ascii', 9, 8)
        doc: Stock symbol right padded with spaces.
      - id: halt_status
        type: block('alpha', 17, 1)
        doc: |-
          A = Accepting Orders for Queuing
          H = Halted
          Q = Quote-Only (Cboe Listings)
          S = Exchange Specific Suspension
          T = Trading
      - id: reg_sho_action
        type: block('numeric', 18, 1)
        doc: |-
          0 = No price test in effect
          1 = Reg SHO price test restriction in effect
      - id: reserved1
        type: block('alpha', 19, 1)
        doc: Reserved
      - id: reserved2
        type: block('alpha', 20, 1)
        doc: Reserved
  symbol_clear_message:
    doc: |-
      The Symbol Clear message instructs feed recipients to clear all orders for
      the Cboe book in the specified symbol. This message will be sent at
      startup each day. It would also be distributed in certain recovery events
      such as a data center fail-over.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: TimeStamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Symbol Clear Message
      - id: stock_symbol
        type: block('printable_ascii', 9, 8)
        doc: Stock symbol right padded with spaces.
  add_order_message_short:
    doc: |-
      An Add Order message represents a newly accepted visible order on the Cboe
      book. It includes a day-specific Order ID assigned by Cboe to the order.
      The Display field is used to reflect whether or not the order can be
      considered a protected quote and thus reportable to the SIP.

      NOTE: If an order’s Price or Display values change within the Cboe
      matching engine, a Cancel Order Message will be immediately followed by a
      new Add Order message with the same Order ID as the original order. An
      order that changes its Display value from “N” to “Y” will not lose its
      priority.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: Timestamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Add Order message (short)
      - id: order_id
        type: block('base_36_numeric', 9, 12)
        doc: Day-specific identifier assigned to this order
      - id: side_indicator
        type: block('alpha', 21, 1)
        doc: |-
          B = Buy Order
          S = Sell Order
      - id: shares
        type: block('numeric', 22, 6)
        doc: |
          Number of shares being added to the book (may be less than the number of shares
          entered).
      - id: stock_symbol
        type: block('printable_ascii', 28, 6)
        doc: Stock symbol right padded with spaces.
      - id: price
        type: block('price', 34, 10)
        doc: The limit order price
      - id: display
        type: block('alpha', 44, 1)
        doc: Y = The order is aggregated in the Cboe SIP quote.
  auction_update_message:
    doc: |-
      Auction Update messages are used to disseminate Cboe price and size
      information during auctions for Cboe listed securities. The Auction Update
      messages are sent every five seconds during a Halt/IPO Quote-Only period.
      Opening Auction Update messages are disseminated every five seconds
      between 9:28 and 9:30 a.m. Closing Auction Update messages are distributed
      every five seconds between 3:55 and 4:00 p.m.

      Cboe Auction Update messages support the Cboe Opening, Closing, Halt and
      IPO Auctions on the BZX Exchange. Refer to the Cboe US Equities Auction
      Process specification for more information on Cboe Auctions.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: Timestamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Auction Update message
      - id: stock_symbol
        type: block('printable_ascii', 9, 8)
        doc: Stock symbol right padded with spaces.
      - id: auction_type
        type: block('alpha', 17, 1)
        doc: |-
          O = Opening Auction
          C = Closing Auction
          H = Halt Auction
          I = IPO Auction
      - id: reference_price
        type: block('price', 18, 10)
        doc: BBO Collared auction price (see Auction Process Spec).
      - id: buy_shares
        type: block('numeric', 28, 10)
        doc: Number of shares on the buy side at the Reference Price.
      - id: sell_shares
        type: block('numeric', 38, 10)
        doc: Number of shares on the sell side at the Reference Price.
      - id: indicative_price
        type: block('price', 48, 10)
        doc: Price at which the auction book and the continuous book would match.
      - id: auction_only_price
        type: block('price', 58, 10)
        doc: |-
          Price at which the auction book would match using only Eligible
          Auction Orders (see Auction Process Spec).
  trade_message_short:
    doc: |-
      The Trade message provides information about executions of non-displayed
      orders or shares on the Cboe book and routed orders. Trade messages are
      necessary to calculate Cboe execution based data. Trade messages do not
      alter the book and can be ignored if you are just building a book.

      No Add Order message is sent for non-displayed and routed orders, and
      thus, no modify order messages may be sent when non-displayed orders are
      executed. Instead, a Trade message is sent whenever a hidden or routed
      order is executed in whole or in part. A Trade message is also sent when
      there is an execution against any non-displayed portion of a reserve
      order. As with visible orders, hidden orders may be executed in parts. A
      complete view of all Cboe executions can be built by combining all Order
      Executed messages and Trade messages.

      The OrderID of a non-displayed order is obfuscated by default in the Trade
      message, but may be optionally disseminated for a member’s own orders upon
      request. As such, partial executions against the same hidden order will by
      default have different OrderIDs.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: Timestamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Trade message (short)
      - id: order_id
        type: block('base_36_numeric', 9, 12)
        doc: Obfuscated Order ID or Order ID of the executed order
      - id: side_indicator
        type: block('alpha', 21, 1)
        doc: Always B = Buy Order regardless of side of resting order
      - id: shares
        type: block('numeric', 22, 6)
        doc: Incremental Number of shares executed
      - id: stock_symbol
        type: block('printable_ascii', 28, 6)
        doc: Stock symbol right padded with spaces.
      - id: price
        type: block('price', 34, 10)
        doc: The execution price of the order
      - id: execution_id
        type: block('base_36_numeric', 44, 12)
        doc: |-
          Cboe generated day-unique execution identifier of this trade.
          Execution ID is also referenced in the Trade Break message.
  retail_price_improvement_message:
    doc: |-
      The Retail Price Improvement message is only available on the BYX
      Exchange. This message is a Retail Liquidity Indicator (RLI) that includes
      symbol and side, but not price and size. An RLI will be disseminated when
      there is a Retail Price Improving (RPI) order present for a symbol on the
      BYX Exchange order book OR to indicate a RPI order is no longer available.
      RPI orders offer price improvement in increments of $.001 to Retail Member
      Organizations.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: TimeStamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Retail Price Improvement message
      - id: stock_symbol
        type: block('printable_ascii', 9, 8)
        doc: Symbol
      - id: retail_price_improvement
        type: block('alpha', 17, 1)
        doc: |-
          B = Buy Side RPI
          S = Sell Side RPI
          A = Buy & Sell RPI
          N = No RPI
  trade_message_long:
    doc: |-
      The Trade message provides information about executions of non-displayed
      orders or shares on the Cboe book and routed orders. Trade messages are
      necessary to calculate Cboe execution based data. Trade messages do not
      alter the book and can be ignored if you are just building a book.

      No Add Order message is sent for non-displayed and routed orders, and
      thus, no modify order messages may be sent when non-displayed orders are
      executed. Instead, a Trade message is sent whenever a hidden or routed
      order is executed in whole or in part. A Trade message is also sent when
      there is an execution against any non-displayed portion of a reserve
      order. As with visible orders, hidden orders may be executed in parts. A
      complete view of all Cboe executions can be built by combining all Order
      Executed messages and Trade messages.

      The OrderID of a non-displayed order is obfuscated by default in the Trade
      message, but may be optionally disseminated for a member’s own orders upon
      request. As such, partial executions against the same hidden order will by
      default have different OrderIDs.

      NOTE: The long version of the Trade message has been made available to
      accommodate larger symbol sizes possible through the ISRA plan.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: Timestamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Trade message (long)
      - id: order_id
        type: block('base_36_numeric', 9, 12)
        doc: Obfuscated Order ID or Order ID of the executed order.
      - id: side_indicator
        type: block('alpha', 21, 1)
        doc: Always B = Buy Order regardless of side of resting order
      - id: shares
        type: block('numeric', 22, 6)
        doc: Incremental Number of shares executed
      - id: stock_symbol
        type: block('printable_ascii', 28, 8)
        doc: Stock symbol right padded with spaces.
      - id: price
        type: block('price', 36, 10)
        doc: The execution price of the order
      - id: execution_id
        type: block('base_36_numeric', 46, 12)
        doc: |-
          Cboe generated day-unique execution identifier of this trade.
          Execution ID is also referenced in the Trade Break message.
  order_executed_message:
    doc: |-
      Order Executed messages are sent when a visible order on the Cboe book is
      executed in whole or in part. The execution price equals the limit order
      price found in the original Add Order message.

      NOTE:  Order Modification messages (4.4.x) refer to an Order ID previously
      sent with an Add Order message. Multiple Order Modification messages may
      modify a single order and the effects are cumulative. Order Modification
      messages always reduce the remaining shares in the referenced open order
      by the number of shares indicated. When the remaining shares for an order
      reach zero, the order is dead and should be removed from the book.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: Timestamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Order Executed message
      - id: order_id
        type: block('base_36_numeric', 9, 12)
        doc: Order ID of a previously sent Add Order Message that was executed.
      - id: executed_shares
        type: block('numeric', 21, 6)
        doc: Number of shares executed
      - id: execution_id
        type: block('base_36_numeric', 27, 12)
        doc: |-
          Cboe generated day-unique execution identifier of this execution.
          Execution ID is also referenced in the Trade Break Message.
  add_order_message_long:
    doc: |-
      An Add Order message represents a newly accepted visible order on the Cboe
      book. It includes a day-specific Order ID assigned by Cboe to the order.
      The Display field is used to reflect whether or not the order can be
      considered a protected quote and thus reportable to the SIP.

      The long version of the Add Order message has been made available to
      accommodate larger symbol sizes possible through the ISRA plan.

      NOTE: If an order’s Price or Display values change within the Cboe
      matching engine, a Cancel Order Message will be immediately followed by a
      new Add Order message with the same Order ID as the original order. An
      order that changes its Display value from “N” to “Y” will not lose its
      priority.
    seq:
      - id: timestamp
        type: block('timestamp', 0, 8)
        doc: Timestamp
      - id: message_type
        type: block('alpha', 8, 1)
        doc: Add Order message (long)
      - id: order_id
        type: block('base_36_numeric', 9, 12)
        doc: Day-specific identifier assigned to this order
      - id: side_indicator
        type: block('alpha', 21, 1)
        doc: |-
          B = Buy Order
          S = Sell Order
      - id: shares
        type: block('numeric', 22, 6)
        doc: |-
          Number of shares being added to the book (may be less than the
          number of shares entered).
      - id: stock_symbol
        type: block('printable_ascii', 28, 8)
        doc: Stock symbol right padded with spaces.
      - id: price
        type: block('price', 36, 10)
        doc: The limit order price
      - id: display
        type: block('alpha', 46, 1)
        doc: Y = The order is aggregated in the Cboe SIP quote.
      - id: participantid
        type: block('alpha', 47, 4)
        doc: |-
          Optionally specified. If specified, MPID or RTAL for  retail
          specified orders (equities) of firm attributed to this quote. Space
          filled otherwise.
