# Design-of-Enhanced-UART-System-
Configurable UART Transmitter (TX), Receiver (RX), and Baud Generator with parameterizable TX/RX FIFOs. Includes a Verilog verification environment with scoreboard, constrained-random stimulus, and corner-case coverage.

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

<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="960" height="420" viewBox="0 0 960 420">
  <!-- Title -->
  <text x="480" y="26" text-anchor="middle" font-family="sans-serif" font-size="16" font-weight="700">
    Enhanced UART IP with FIFOs
  </text>

  <!-- Left labels -->
  <text x="20" y="112" font-family="monospace" font-size="12">TX_HOST (tx_data_i, tx_valid_i, tx_ready_o)</text>
  <text x="20" y="292" font-family="monospace" font-size="12">RX_HOST (rx_data_o, rx_valid_o, rx_ready_i)</text>

  <!-- Boxes -->
  <!-- TX path -->
  <rect x="190" y="80" width="120" height="60" rx="8" ry="8" fill="#f7f7f7" stroke="#000"/>
  <text x="250" y="115" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="700">TX_IF</text>

  <rect x="340" y="80" width="140" height="60" rx="8" ry="8" fill="#f7f7f7" stroke="#000"/>
  <text x="410" y="105" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="700">TX_FIFO</text>
  <text x="410" y="123" text-anchor="middle" font-family="sans-serif" font-size="12">depth=N, full/empty</text>

  <rect x="520" y="80" width="130" height="60" rx="8" ry="8" fill="#f7f7f7" stroke="#000"/>
  <text x="585" y="115" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="700">UART_TX</text>

  <rect x="680" y="80" width="120" height="60" rx="8" ry="8" fill="#f7f7f7" stroke="#000"/>
  <text x="740" y="115" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="700">TX Line</text>

  <!-- RX path -->
  <rect x="680" y="260" width="120" height="60" rx="8" ry="8" fill="#f7f7f7" stroke="#000"/>
  <text x="740" y="295" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="700">RX Line</text>

  <rect x="520" y="260" width="130" height="60" rx="8" ry="8" fill="#f7f7f7" stroke="#000"/>
  <text x="585" y="295" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="700">UART_RX</text>

  <rect x="340" y="260" width="140" height="60" rx="8" ry="8" fill="#f7f7f7" stroke="#000"/>
  <text x="410" y="285" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="700">RX_FIFO</text>
  <text x="410" y="303" text-anchor="middle" font-family="sans-serif" font-size="12">depth=M, ovf/udf</text>

  <rect x="190" y="260" width="120" height="60" rx="8" ry="8" fill="#f7f7f7" stroke="#000"/>
  <text x="250" y="295" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="700">RX_IF</text>

  <!-- Center blocks -->
  <rect x="520" y="170" width="130" height="60" rx="8" ry="8" fill="#f7f7f7" stroke="#000"/>
  <text x="585" y="205" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="700">Baud Gen</text>

  <rect x="340" y="170" width="140" height="60" rx="8" ry="8" fill="#f7f7f7" stroke="#000"/>
  <text x="410" y="195" text-anchor="middle" font-family="sans-serif" font-size="14" font-weight="700">CLK / RST</text>
  <text x="410" y="213" text-anchor="middle" font-family="sans-serif" font-size="12">clk_i, rst_ni</text>

  <!-- Wires (simple arrows using triangles) -->
  <!-- Host -> TX_IF -->
  <line x1="140" y1="110" x2="188" y2="110" stroke="#000" stroke-width="1.2"/>
  <polygon points="188,110 180,106 180,114" fill="#000"/>
  <!-- TX_IF -> TX_FIFO -->
  <line x1="310" y1="110" x2="338" y2="110" stroke="#000" stroke-width="1.2"/>
  <polygon points="338,110 330,106 330,114" fill="#000"/>
  <!-- TX_FIFO -> UART_TX -->
  <line x1="480" y1="110" x2="518" y2="110" stroke="#000" stroke-width="1.2"/>
  <polygon points="518,110 510,106 510,114" fill="#000"/>
  <!-- UART_TX -> TX Line -->
  <line x1="650" y1="110" x2="678" y2="110" stroke="#000" stroke-width="1.2"/>
  <polygon points="678,110 670,106 670,114" fill="#000"/>

  <!-- RX Line -> UART_RX -->
  <line x1="678" y1="290" x2="650" y2="290" stroke="#000" stroke-width="1.2"/>
  <polygon points="678,290 670,286 670,294" fill="#000" transform="rotate(180 664 290)"/>
  <!-- UART_RX -> RX_FIFO -->
  <line x1="518" y1="290" x2="480" y2="290" stroke="#000" stroke-width="1.2"/>
  <polygon points="480,290 488,286 488,294" fill="#000"/>
  <!-- RX_FIFO -> RX_IF -->
  <line x1="338" y1="290" x2="310" y2="290" stroke="#000" stroke-width="1.2"/>
  <polygon points="310,290 318,286 318,294" fill="#000"/>
  <!-- RX_IF -> Host -->
  <line x1="188" y1="290" x2="140" y2="290" stroke="#000" stroke-width="1.2"/>
  <polygon points="140,290 148,286 148,294" fill="#000"/>

  <!-- Baud Gen to TX/RX -->
  <line x1="585" y1="170" x2="585" y2="140" stroke="#000" stroke-width="1.2"/>
  <polygon points="585,140 581,148 589,148" fill="#000"/>
  <line x1="585" y1="230" x2="585" y2="260" stroke="#000" stroke-width="1.2"/>
  <polygon points="585,260 581,252 589,252" fill="#000"/>

  <!-- CLK/RST fanout -->
  <line x1="480" y1="200" x2="520" y2="200" stroke="#000" stroke-width="1.2"/>
  <line x1="410" y1="170" x2="410" y2="140" stroke="#000" stroke-width="1.2"/>
  <line x1="410" y1="230" x2="410" y2="260" stroke="#000" stroke-width="1.2"/>

  <!-- Bottom notes -->
  <text x="250" y="362" text-anchor="middle" font-family="sans-serif" font-size="12">
    TX: TX_IF → TX_FIFO → UART_TX → TX Line
  </text>
  <text x="710" y="362" text-anchor="middle" font-family="sans-serif" font-size="12">
    RX: RX Line → UART_RX → RX_FIFO → RX_IF
  </text>
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


