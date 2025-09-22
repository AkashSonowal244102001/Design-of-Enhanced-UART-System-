# Design-of-Enhanced-UART-System-
Configurable UART Transmitter (TX), Receiver (RX), and Baud Generator with parameterizable TX/RX FIFOs. Includes a SystemVerilog verification environment with scoreboard, constrained-random stimulus, and corner-case coverage.

⸻

📘 Overview

This project implements an Enhanced UART IP Core designed for FPGA/ASIC integration. It supports reliable data transfer through configurable FIFOs, handles corner cases like overflow/underflow, and is fully verified using modern SystemVerilog testbench practices.

The motivation was to build a reusable, robust, and parameterized UART that can be plugged into larger SoCs or FPGA designs while showcasing design + verification skills.

⸻

✨ Features
	 *UART Transmitter (TX) and Receiver (RX)
	 *Baud Generator with configurable divisor
	 *Parameterizable TX and RX FIFOs (synchronous)
	  *FIFO full/empty/overflow logic with flags
	-	Clean valid/ready-style streaming interface
	-	Verification Environment
	-	SystemVerilog Testbench
	-	Scoreboard-based checking
	-	Constrained-random stimulus
	-	Corner-case coverage (underflow, overflow, simultaneous read/write)
