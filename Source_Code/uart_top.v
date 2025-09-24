`timescale 1ns/1ps
// =====================================================
// UART Top (TX + RX + Baud Gen) - Verilog-2001
// 100 MHz clk, 115200 baud, 8-N-1, echo RX->TX
// =====================================================
module uart_top (
    input  wire clk_i,
    input  wire rst_ni,     // active-low
    input  wire uart_rxi,   // from PC
    output wire uart_txo    // to PC
);

    // ---------------- Params ----------------
    // (pure Verilog: use integer/localparam + clog2 function)
    localparam integer CLK_FREQ  = 100_000_000;   // Hz
    localparam integer BAUD_RATE = 115200;        // bps
    localparam integer DIVISOR   = CLK_FREQ / BAUD_RATE; // 100e6/115200 ≈ 868

    // clog2 helper for vector widths
    function integer clog2;
      input integer value;
      integer v, i;
      begin
        v = value - 1;
        for (i = 0; v > 0; i = i + 1)
          v = v >> 1;
        clog2 = i;
      end
    endfunction

    // -------------- Baud tick --------------
    localparam integer CNT_W = clog2(DIVISOR);
    reg  [CNT_W-1:0] baud_cnt;
    reg              baud_tick;   // 1-cycle pulse each bit period

    always @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        baud_cnt  <= {CNT_W{1'b0}};
        baud_tick <= 1'b0;
      end else if (baud_cnt == DIVISOR-1) begin
        baud_cnt  <= {CNT_W{1'b0}};
        baud_tick <= 1'b1;
      end else begin
        baud_cnt  <= baud_cnt + {{(CNT_W-1){1'b0}}, 1'b1};
        baud_tick <= 1'b0;
      end
    end

    // ----------- RX (mid-bit sample) -----------
    // State encoding (no typedef enum)
    localparam [1:0] RX_IDLE  = 2'd0,
                     RX_START = 2'd1,
                     RX_BITS  = 2'd2,
                     RX_STOP  = 2'd3;

    reg [1:0]        state;
    reg [3:0]        bit_idx;      // 0..7
    reg [CNT_W-1:0]  samp_cnt;     // sub-bit counter
    reg [7:0]        rx_shift;
    reg [7:0]        rx_data;
    reg              rx_done;

    // One half-bit = DIVISOR/2 counts
    localparam integer HALF_DIV = DIVISOR >> 1;

    always @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        state    <= RX_IDLE;
        bit_idx  <= 4'd0;
        samp_cnt <= {CNT_W{1'b0}};
        rx_shift <= 8'h00;
        rx_data  <= 8'h00;
        rx_done  <= 1'b0;
      end else begin
        rx_done <= 1'b0; // default

        case (state)
          RX_IDLE: begin
            // detect start bit (line goes low)
            if (uart_rxi == 1'b0) begin
              state    <= RX_START;
              samp_cnt <= {CNT_W{1'b0}};
            end
          end

          RX_START: begin
            // wait half a bit then go to first data sample
            if (samp_cnt == HALF_DIV) begin
              samp_cnt <= {CNT_W{1'b0}};
              bit_idx  <= 4'd0;
              state    <= RX_BITS;
            end else begin
              samp_cnt <= samp_cnt + {{(CNT_W-1){1'b0}}, 1'b1};
            end
          end

          RX_BITS: begin
            // sample once per full bit
            if (samp_cnt == DIVISOR-1) begin
              samp_cnt                  <= {CNT_W{1'b0}};
              rx_shift[bit_idx[2:0]]    <= uart_rxi; // mid-bit sample
              if (bit_idx == 4'd7) begin
                state <= RX_STOP;
              end else begin
                bit_idx <= bit_idx + 4'd1;
              end
            end else begin
              samp_cnt <= samp_cnt + {{(CNT_W-1){1'b0}}, 1'b1};
            end
          end

          RX_STOP: begin
            // wait one stop bit
            if (samp_cnt == DIVISOR-1) begin
              samp_cnt <= {CNT_W{1'b0}};
              rx_data  <= rx_shift;
              rx_done  <= 1'b1;
              state    <= RX_IDLE;
            end else begin
              samp_cnt <= samp_cnt + {{(CNT_W-1){1'b0}}, 1'b1};
            end
          end

          default: state <= RX_IDLE;
        endcase
      end
    end

    // --------------- TX ----------------
    reg [3:0] tx_cnt;   // 0..9 (start,8 data,stop)
    reg [9:0] tx_shift; // {stop, data[7:0], start}
    reg       tx_busy;
    reg       tx_reg;

    assign uart_txo = tx_reg;

    always @(posedge clk_i or negedge rst_ni) begin
      if (!rst_ni) begin
        tx_cnt   <= 4'd0;
        tx_shift <= 10'h3FF;
        tx_busy  <= 1'b0;
        tx_reg   <= 1'b1; // idle high
      end else if (rx_done && !tx_busy) begin
        // load to transmit what we received
        tx_shift <= {1'b1, rx_data, 1'b0}; // stop + data + start
        tx_cnt   <= 4'd0;
        tx_busy  <= 1'b1;
      end else if (tx_busy && baud_tick) begin
        tx_reg   <= tx_shift[0];
        tx_shift <= {1'b1, tx_shift[9:1]};
        tx_cnt   <= tx_cnt + 4'd1;
        if (tx_cnt == 4'd9) begin
          tx_busy <= 1'b0;
          tx_reg  <= 1'b1; // back to idle
        end
      end
    end

endmodule
