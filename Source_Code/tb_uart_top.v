`timescale 1ns/1ps
// =====================================================
// Testbench for: uart_top  (115200 baud, 100 MHz clock)
// Verilog-2001 only; prints key DUT internals
// =====================================================
module tb_uart_top;

  // ---- DUT I/O ----
  reg  clk_i    = 1'b0;  // 100 MHz
  reg  rst_ni   = 1'b0;  // active-low reset
  reg  uart_rxi = 1'b1;  // UART line idle is HIGH
  wire uart_txo;

  // ---- Instantiate DUT (instance name 'dut') ----
  uart_top dut (
    .clk_i    (clk_i),
    .rst_ni   (rst_ni),
    .uart_rxi (uart_rxi),
    .uart_txo (uart_txo)
  );

  // ---- 100 MHz clock ----
  always #5 clk_i = ~clk_i;   // 10 ns period

  // ---- UART timing (115200 baud) ----
  integer BIT_NS;
  initial BIT_NS = 8681;  // ~1/115200 s in ns

  // Wait N bit-times
  task wait_bits;
    input integer n; integer k;
    begin
      for (k = 0; k < n; k = k + 1) #(BIT_NS);
    end
  endtask

  // Drive one UART byte on RX (8-N-1, LSB first)
  task drive_rx_byte;
    input [7:0] b; integer i;
    begin
      uart_rxi = 1'b0; wait_bits(1);        // start
      for (i = 0; i < 8; i = i + 1) begin   // data (LSB first)
        uart_rxi = b[i]; wait_bits(1);
      end
      uart_rxi = 1'b1; wait_bits(1);        // stop
      wait_bits(1);                          // gap
    end
  endtask

  // Capture one byte from TX (sample mid-bit)
  task capture_tx_byte;
    output [7:0] b; integer i;
    begin
      b = 8'h00;
      @(negedge uart_txo);    // start
      wait_bits(1);           // to middle of first data bit
      for (i = 0; i < 8; i = i + 1) begin
        #(BIT_NS/2); b[i] = uart_txo; #(BIT_NS - (BIT_NS/2));
      end
      wait_bits(1);           // stop
    end
  endtask

  // Send then expect echo back (self-check)
  task send_and_expect;
    input  [7:0] txbyte; reg [7:0] rxbyte;
    begin
      fork
        begin drive_rx_byte(txbyte); end
        begin
          capture_tx_byte(rxbyte);
          if (rxbyte !== txbyte) begin
            $display("[%0t] ERROR: sent 0x%02h, got 0x%02h", $time, txbyte, rxbyte);
            $finish;
          end else begin
            $display("[%0t] OK: echo 0x%02h", $time, rxbyte);
          end
        end
      join
    end
  endtask

  // ---------------- MONITOR: print key DUT objects ----------------
  // Shorthand to DUT scope
  `define D tb_uart_top.dut

  // Optional: derive a boolean "rx_busy" from state (without editing DUT)
  function rx_busy_fn;
    input [1:0] st;
    begin
      // Busy when not IDLE
      rx_busy_fn = (st != `D.RX_IDLE);
    end
  endfunction

  initial begin
    $display(" time(ns) | rst rx tx | baud_cnt baud_tick | state bit_idx rx_busy rx_done rx_shift rx_data | tx_cnt tx_busy tx_shift tx_reg");
    $display("----------+-----------+--------------------+-----------------------------------------------+----------------------------------");
  end

  // print at each baud boundary
  always @(posedge `D.baud_tick) begin
    $display("%9t |  %0d  %0d  %0d | %6d       %0d |   %1d     %1d       %0d      %0d    0x%02h    0x%02h |   %2d     %0d    0x%03h     %0d",
      $time, rst_ni, uart_rxi, uart_txo,
      `D.baud_cnt, `D.baud_tick,
      `D.state, `D.bit_idx, rx_busy_fn(`D.state), `D.rx_done, `D.rx_shift, `D.rx_data,
      `D.tx_cnt, `D.tx_busy, `D.tx_shift, `D.tx_reg
    );
  end

  // markers for RX/TX events
  reg tx_busy_q;
  always @(posedge clk_i) begin
    tx_busy_q <= `D.tx_busy;
    if (`D.rx_done)
      $display("%9t | RX_DONE byte=0x%02h  (rx_shift=0x%02h)", $time, `D.rx_data, `D.rx_shift);
    if (!tx_busy_q && `D.tx_busy)
      $display("%9t | TX_START shift=0x%03h cnt=%0d", $time, `D.tx_shift, `D.tx_cnt);
    if (tx_busy_q && !`D.tx_busy)
      $display("%9t | TX_DONE", $time);
  end
  // -------------------------------------------------------------------

  // ---- Test sequence ----
  integer i; reg [7:0] rand_b;
  initial begin
    // Reset
    rst_ni = 1'b0; repeat (20) @(posedge clk_i); rst_ni = 1'b1;

    // Give DUT some cycles
    #(50_000);

    // Directed bytes
    send_and_expect(8'h55);
    send_and_expect(8'hAA);
    send_and_expect(8'h00);
    send_and_expect(8'hFF);
    send_and_expect(8'h41); // 'A'

    // Random burst
    for (i = 0; i < 8; i = i + 1) begin
      rand_b = $random;
      send_and_expect(rand_b);
    end

    $display("\nAll UART echo checks PASSED");
    #(100_000); $finish;
  end

  // Optional VCD for other simulators
  initial begin
    if ($test$plusargs("dumpvcd")) begin
      $dumpfile("uart_tb.vcd");
      $dumpvars(0, tb_uart_top);
    end
  end

endmodule
