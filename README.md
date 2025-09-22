# Design-of-Enhanced-UART-System-
Five-word heading suggestion: Enhanced UART IP with Verification

A clean, modular UART IP core featuring UART TX, UART RX, and a Baud Generator, with parameterizable TX/RX FIFOs (synchronous; full/empty/overflow logic). The package includes SystemVerilog verification with a scoreboard, constrained-random stimulus, protocol checks, and coverage for corner cases.

Key Features
	•	UART TX/RX: 8-N-1 by default; configurable data bits, parity, stop bits.
	•	Baud Generator: Programmable divider; fractional support optional.
	•	Parameterizable FIFOs: Independent TX FIFO and RX FIFO; depth and width set via params.
	•	Robust FIFO Logic: Full/empty/overflow/underflow flags; optional almost-full/almost-empty.
	•	Clean Interfaces: Simple streaming (valid/ready) on TX/RX sides.
	•	Verification: SystemVerilog testbench, scoreboard, random stimulus, self-checking, functional coverage
