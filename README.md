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
  <li>SystemVerilog Testbench</li>
  <li>Scoreboard-based checking</li>
  <li>Constrained-random stimulus</li>
  <li>Corner-case coverage (underflow, overflow, simultaneous read/write)</li>
</ul>

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
