# Design-of-Enhanced-UART-System-
Configurable UART Transmitter (TX), Receiver (RX), and Baud Generator with parameterizable TX/RX FIFOs. Includes a SystemVerilog verification environment with scoreboard, constrained-random stimulus, and corner-case coverage.

⸻

📘 Overview

This project implements an Enhanced UART IP Core designed for FPGA/ASIC integration. It supports reliable data transfer through configurable FIFOs, handles corner cases like overflow/underflow, and is fully verified using modern SystemVerilog testbench practices.

The motivation was to build a reusable, robust, and parameterized UART that can be plugged into larger SoCs or FPGA designs while showcasing design + verification skills.

⸻

✨ Features
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
