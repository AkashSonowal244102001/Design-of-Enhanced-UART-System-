# Design-of-Enhanced-UART-System-
Configurable UART Transmitter (TX), Receiver (RX), and Baud Generator with parameterizable TX/RX FIFOs. Includes a SystemVerilog verification environment with scoreboard, constrained-random stimulus, and corner-case coverage.

⸻

📘 Overview

This project implements an Enhanced UART IP Core designed for FPGA/ASIC integration. It supports reliable data transfer through configurable FIFOs, handles corner cases like overflow/underflow, and is fully verified using modern SystemVerilog testbench practices.

The motivation was to build a reusable, robust, and parameterized UART that can be plugged into larger SoCs or FPGA designs while showcasing design + verification skills.

⸻

<h2>✨ Features</h2>
<ul>
  <li>UART Transmitter (TX) and Receiver (RX)</li>
  <li>Baud Generator with configurable divisor</li>
  <li>Parameterizable TX and RX FIFOs (synchronous)</li>
  <li>FIFO full/empty/overflow logic with flags</li>
  <li>Clean valid/ready-style streaming interface</li>
  <li>Verification Environment</li>
  <li>Verilog Testbench</li>
  <li>Scoreboard-based checking</li>
  <li>Constrained-random stimulus</li>
  <li>Corner-case coverage (underflow, overflow, simultaneous read/write)</li>
</ul>

<!-- UART IP Block Diagram (inline SVG for GitHub README) -->
<svg xmlns="http://www.w3.org/2000/svg" width="960" height="420" viewBox="0 0 960 420" role="img" aria-label="Enhanced UART IP Block Diagram">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="8" refX="8" refY="4" orient="auto">
      <path d="M0,0 L10,4 L0,8 Z" fill="black"></path>
    </marker>
    <style>
      .blk { fill:#f7f7f7; stroke:#000; stroke-width:1.2; rx:10; ry:10; }
      .title { font: 700 14px sans-serif; }
      .label { font: 12px sans-serif; }
      .pin { font: 12px monospace; }
      .wire { stroke:#000; stroke-width:1.2; fill:none; marker-end:url(#arrow); }
      .dashed { stroke-dasharray:5 4; }
    </style>
  </defs>

  <!-- Titles -->
  <text x="480" y="24" text-anchor="middle" class="title">Enhanced UART IP with FIFOs & Verification</text>

  <!-- Left host interface labels -->
  <text x="20" y="120" class="pin">TX_HOST (tx_data_i, tx_valid_i, tx_ready_o)</text>
  <text x="20" y="300" class="pin">RX_HOST (rx_data_o, rx_valid_o, rx_ready_i)</text>

  <!-- TX path blocks -->
  <rect x="190" y="80"  width="120" height="60" class="blk"></rect>
  <text x="250" y="110" text-anchor="middle" class="title">TX_IF</text>

  <rect x="340" y="80"  width="140" height="60" class="blk"></rect>
  <text x="410" y="105" text-anchor="middle" class="title">TX_FIFO</text>
  <text x="410" y="123" text-anchor="middle" class="label">depth=N, full/empty</text>

  <rect x="520" y="80"  width="130" height="60" class="blk"></rect>
  <text x="585" y="110" text-anchor="middle" class="title">UART_TX</text>

  <!-- TX line -->
  <rect x="680" y="80" width="120" height="60" class="blk"></rect>
  <text x="740" y="110" text-anchor="middle" class="title">TX Line</text>

  <!-- RX path blocks -->
  <rect x="680" y="260" width="120" height="60" class="blk"></rect>
  <text x="740" y="290" text-anchor="middle" class="title">RX Line</text>

  <rect x="520" y="260" width="130" height="60" class="blk"></rect>
  <text x="585" y="290" text-anchor="middle" class="title">UART_RX</text>

  <rect x="340" y="260" width="140" height="60" class="blk"></rect>
  <text x="410" y="285" text-anchor="middle" class="title">RX_FIFO</text>
  <text x="410" y="303" text-anchor="middle" class="label">depth=M, ovf/udf</text>

  <rect x="190" y="260" width="120" height="60" class="blk"></rect>
  <text x="250" y="290" text-anchor="middle" class="title">RX_IF</text>

  <!-- Baud Generator and CLK/RST -->
  <rect x="520" y="170" width="130" height="60" class="blk"></rect>
  <text x="585" y="200" text-anchor="middle" class="title">Baud Gen</text>

  <rect x="340" y="170" width="140" height="60" class="blk"></rect>
  <text x="410" y="195" text-anchor="middle" class="title">CLK / RST</text>
  <text x="410" y="213" text-anchor="middle" class="label">clk_i, rst_ni</text>

  <!-- Wires: host to TX_IF and RX_IF to host -->
  <path class="wire" d="M140,110 L190,110"></path>
  <path class="wire" d="M190,290 L140,290"></path>

  <!-- TX pipeline wires -->
  <path class="wire" d="M310,110 L340,110"></path>
  <path class="wire" d="M480,110 L520,110"></path>
  <path class="wire" d="M650,110 L680,110"></path>

  <!-- RX pipeline wires -->
  <path class="wire" d="M680,290 L650,290"></path>
  <path class="wire" d="M520,290 L480,290"></path>
  <path class="wire" d="M340,290 L310,290"></path>

  <!-- Serial crossover: TX Line -> RX Line (loopback for diagram) -->
  <path class="wire dashed" d="M800,110 C860,110 860,290 800,290"></path>
  <text x="865" y="205" class="label" transform="rotate(90 865 205)">serial</text>

  <!-- Baud Gen connections to TX/RX (ticks) -->
  <path class="wire" d="M585,170 L585,140"></path>
  <path class="wire" d="M585,230 L585,260"></path>

  <!-- CLK/RST to TX/RX/Baud (fanout) -->
  <path class="wire" d="M480,200 L520,200"></path>
  <path class="wire" d="M410,170 L410,140"></path>
  <path class="wire" d="M410,230 L410,260"></path>

  <!-- Side labels -->
  <text x="95" y="105" text-anchor="end" class="label">TX host</text>
  <text x="95" y="295" text-anchor="end" class="label">RX host</text>

  <!-- Notes -->
  <text x="250" y="360" text-anchor="middle" class="label">TX path: TX_IF → TX_FIFO → UART_TX → TX Line</text>
  <text x="710" y="360" text-anchor="middle" class="label">RX path: RX Line → UART_RX → RX_FIFO → RX_IF</text>
</svg>
<h2>⚙️ Parameters</h2>
<table>
  <tr>
    <th>Parameter</th>
    <th>Default</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>CLK_FREQ_HZ</td>
    <td>50e6</td>
    <td>Input clock frequency</td>
  </tr>
  <tr>
    <td>BAUD_RATE</td>
    <td>115200</td>
    <td>UART baud rate</td>
  </tr>
  <tr>
    <td>DATA_BITS</td>
    <td>8</td>
    <td>Number of data bits (7/8/9)</td>
  </tr>
  <tr>
    <td>PARITY_MODE</td>
    <td>0</td>
    <td>0 = none, 1 = even, 2 = odd</td>
  </tr>
  <tr>
    <td>STOP_BITS</td>
    <td>1</td>
    <td>Number of stop bits (1 or 2)</td>
  </tr>
  <tr>
    <td>TX_FIFO_DEPTH</td>
    <td>16</td>
    <td>TX FIFO depth</td>
  </tr>
  <tr>
    <td>RX_FIFO_DEPTH</td>
    <td>16</td>
    <td>RX FIFO depth</td>
  </tr>
</table>

<h2>🔌 Interfaces (Top Module: uart_top.sv)</h2>

<h3>Clocks & Reset</h3>
<ul>
  <li><b>clk_i</b> – Input clock</li>
  <li><b>rst_ni</b> – Active-low reset</li>
</ul>

<h3>TX Host Side</h3>
<ul>
  <li><b>tx_data_i [7:0]</b> – Data input</li>
  <li><b>tx_valid_i</b> – TX valid</li>
  <li><b>tx_ready_o</b> – TX ready</li>
  <li><b>tx_fifo_full_o</b> – TX FIFO full flag</li>
</ul>

<h3>RX Host Side</h3>
<ul>
  <li><b>rx_data_o [7:0]</b> – Data output</li>
  <li><b>rx_valid_o</b> – RX valid</li>
  <li><b>rx_ready_i</b> – RX ready</li>
  <li><b>rx_fifo_empty_o</b> – RX FIFO empty flag</li>
</ul>

<h3>UART Pins</h3>
<ul>
  <li><b>uart_txo</b> – UART TX line output</li>
  <li><b>uart_rxi</b> – UART RX line input</li>
</ul>

<h2>🧪 Verification</h2>
<ul>
  <li><b>Scoreboard</b> – Ensures TX input sequence matches RX output sequence</li>
  <li><b>Random Stimulus</b> – Stresses FIFOs and UART line with randomized data</li>
  <li><b>Corner Case Tests</b> – Includes overflow, underflow, and simultaneous read/write scenarios</li>
  <li><b>Assertions</b> – Protocol checks for FIFO read/write rules and UART frame structure</li>
  <li><b>Functional Coverage</b> – 
    <ul>
      <li>Data pattern bins (00h, FFh, alternating, random)</li>
      <li>Parity modes (none, even, odd)</li>
      <li>Stop bits (1 or 2)</li>
      <li>FIFO states (empty, full, transitions, simultaneous read/write)</li>
      <li>Error injection coverage (framing errors, parity errors)</li>
    </ul>
  </li>
</ul>

<h2>📊 Example Results</h2>
<ul>
  <li>✅ Smoke test passes with TX → RX loopback</li>
  <li>✅ FIFO overflow and underflow correctly flagged in simulation</li>
  <li>✅ Random stimulus achieves full functional coverage bins</li>
  <li>✅ UART line verified for parity and stop-bit variations</li>
</ul>


