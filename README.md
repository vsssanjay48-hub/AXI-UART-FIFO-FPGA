# AXI-UART-FIFO-FPGA


An industry-grade, memory-mapped **AXI4-Lite UART Transmit/Receive Controller with Synchronous FIFO Buffering** designed in SystemVerilog for AMD Xilinx Artix-7 FPGAs[cite: 1].

This repository tracks the complete hardware development lifecycle from pure Verilog behavioral simulation (`v1.0-sim`)[cite: 1] to physical board verification (`v2.0-hardware`)[cite: 1], culminating in a packaged, timing-closed AXI4-Lite IP core ready for SoC integration (`v3.0-axi`)[cite: 1].

---

##  Project Highlights

* **AXI4-Lite Interface:** Full 5-channel slave interface (`AW`, `W`, `B`, `AR`, `R`) for memory-mapped register access[cite: 1].
* **8x8 Synchronous FIFO Buffer:** Handles backpressure and decouples fast system clock writes from serial line speeds[cite: 1].
* **150 MHz Timing Closure:** Critical path pipelining applied to achieve positive slack ($WNS > 0$) at 150 MHz[cite: 1].
* **SystemVerilog RTL & SVA:** Built using modern SystemVerilog constructs (`always_ff`, `always_comb`, `logic`) and protocol assertions[cite: 1].
* **Packaged Vivado IP:** Includes full `component.xml` manifest for Vivado IP Integrator block designs[cite: 1].

---
