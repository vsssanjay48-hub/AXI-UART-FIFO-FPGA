# UART + FIFO on Real FPGA — Progress Report

**BITS Pilani Goa · EEE · 2nd Year · Sem 3 Project**
Continuation of a 75-day Verilog sprint, following the *UART+FIFO FPGA 8-Week Execution Plan* (Aug 1 – Sep 25).

> **Status: Phase 1 complete (Weeks 1–2 of 8).** Design is simulated, synthesized, implemented, timing-clean,
> and a bitstream has been generated for the ZedBoard. Hardware flashing (Week 3 onward) has not been done yet.
> This README documents exactly what's done, with evidence, and what's left — it does not claim more than that.

---

## 1. What this project is

An autonomous UART transmit pipeline: a byte written into a synchronous FIFO is automatically popped and shifted
out serially over UART, entirely in hardware, coordinated by a small handshake FSM — no software/CPU involved.

```
 data_in[7:0] ──▶ ┌────────┐        ┌───────────────┐        ┌──────┐
   wi_en ────────▶│  FIFO  │──────▶ │ handshake_fsm │──────▶ │ UART │──────▶ tx_out
   rst ───────────▶│(8 deep)│◀────── │  (pop/load)   │◀────── │  TX  │
                   └────────┘ full/  └───────────────┘ tx_busy└──────┘
                              empty
```

Four modules: `fifo.v`, `uart.v`, `handshake_fsm.v`, wired together by the top-level `project.v`.

## 2. Target hardware & toolchain

| | |
|---|---|
| Board | Digilent **ZedBoard** (the plan's default board is Basys3/Nexys A7; this build was retargeted to ZedBoard) |
| Chip | Xilinx Zynq-7000 **XC7Z020-CLG484** |
| Tool | **Vivado 2020.1** |
| Design scope | 100% PL (Programmable Logic) — the PS/ARM core is not used |
| Clock | 100 MHz onboard oscillator (pin Y9) |
| Baud rate | 9600, divisor = 10417 |

## 3. Progress against the 8-week plan

| Week | Plan goal | Status | Evidence in this repo |
|---|---|---|---|
| **1** | Vivado setup, import UART+FIFO, behavioral sim, first synthesis + utilization report | ✅ Done | `practice/and_gate/` (Monday setup test) · `reports/synthesis_log.txt` (clean synth, 0 errors) |
| **2** | Write XDC, map pins, clock constraint, full clean run to bitstream | ✅ Done | `constraints/zynq_uart_fifo.xdc` · `reports/utilization.rpt` · `reports/timing_summary.rpt` — bitstream generated (`write_bitstream Complete`, per Vivado screenshots dated Aug 22) |
| **3** | Flash to board, verify over PuTTY/TeraTerm | ⬜ Not started | No hardware programming session recorded yet |
| **4** | Add UART RX, internal loopback, 7-segment display | ⬜ Not started | — |
| **5** | Timing closure deep dive, push clock to 150 MHz, pipelining | ⬜ Not started | Current design already meets timing comfortably at 100 MHz (see §4) but hasn't been pushed to 150 MHz |
| **6** | SystemVerilog rewrite + assertions | ⬜ Not started | — |
| **7–8** | AXI4-Lite wrapper, IP packaging | ⬜ Not started (one exploratory attempt) | A screenshot (`Screenshot 2026-08-21 151346.png`, to be placed under your `/docs/screenshots`) shows an early, unresolved attempt at an AXI GPIO IP integrator block (`design_1_axi_gpio_1_1` port mismatch) — this was exploratory, not the structured Week 7–8 deliverable, and wasn't pursued further. |

## 4. Results from the completed phase

**Synthesis** — 0 errors, 0 critical warnings (`reports/synthesis_log.txt`):

| Cell type | Count |
|---|---|
| LUTs (1–6 input) | 49 |
| CARRY4 | 4 |
| RAM32M (FIFO memory) | 2 |
| FDRE (flip-flops) | 60 |
| IBUF / OBUF | 11 / 4 |

**Implementation (place & route)** — `reports/utilization.rpt`, `reports/timing_summary.rpt`:

| Metric | Value |
|---|---|
| Slice LUTs used | 41 / 53200 (0.08%) |
| Slice Registers used | 60 / 106400 (0.06%) |
| Worst Negative Slack (WNS) | **+5.843 ns** (positive = timing met) |
| Failing timing endpoints | 0 / 172 |
| Target clock | 100 MHz (10.000 ns period) |

**DRC** — 1 warning only (`reports/drc.rpt`): *"PS7 block required"* — expected and harmless for a pure-PL
design that doesn't instantiate the Zynq Processing System (see §2).

**Bitstream** — `write_bitstream Complete` (Vivado status bar, Aug 22 2026 screenshots).

### Design bugs found and fixed along the way
Three real functional bugs were found and corrected during bring-up (not yet reflected upstream in
`baud_rate_gen`/practice files, only in the core `src/`):
1. `uart_send`/`tx_start` was asserted once and never deasserted — fixed to a proper one-cycle pulse.
2. `handshake_fsm` captured `fifo_dout` one cycle too early (before the FIFO's registered read output had
   settled), causing every transmitted byte to actually be the *previous* byte — fixed by adding a buffer state.
3. Mixed blocking/nonblocking assignments in `uart.v`'s stop state — a simulator-dependent race hazard, fixed
   to consistent nonblocking assignments.
All three were verified by simulation (a software UART decoder correctly read back 0x01, 0x02, 0x03, 0x04
in order after the fix).

## 5. Practice / exploratory work (not the core deliverable)

These were early self-contained exercises, kept separate from the main design:

| Folder | What it is | Result |
|---|---|---|
| `practice/and_gate/` | Week 1 Monday "confirm the tool works" exercise | Synthesized cleanly |
| `practice/gray_code/` | Binary-to-Gray-code converter, self-study exercise | Synthesized; **implementation failed** (placer could not place all instances) — unresolved |
| `practice/baud_rate_gen/` | Standalone baud-rate divisor module, precursor to the one now inside `uart.v` | Synthesized; **bitstream failed** (no timing constraints were ever added to this standalone project) |

## 6. Repository layout

```
.
├── README.md
├── src/                    core deliverable RTL
│   ├── project_top.v       top-level module (ports: clk, rst, wi_en, data_in, full, empty, tx_out, tx_busy_led)
│   ├── fifo.v
│   ├── uart.v
│   └── handshake_fsm.v
├── sim/
│   └── tb_project.v        testbench used for behavioral simulation
├── constraints/
│   └── zynq_uart_fifo.xdc  pin/timing constraints for the ZedBoard
├── reports/
│   ├── synthesis_log.txt   full Vivado synthesis log
│   ├── utilization.rpt     post-implementation utilization report
│   ├── timing_summary.rpt  post-implementation timing report
│   ├── drc.rpt             design rule check report
│   └── io_pin_table.xlsx   exported I/O pin planning table
├── docs/
│   ├── UART_FIFO_FPGA_8Week_Plan.pdf   the plan this project follows
│   └── screenshots/        ← put your Vivado/hardware screenshots here (see note below)
└── practice/                exploratory exercises, not part of the core deliverable
    ├── and_gate/
    ├── gray_code/
    └── baud_rate_gen/
```

> **Note on screenshots:** you mentioned you'll add screenshots and other supporting material yourself —
> drop them in `docs/screenshots/` following the naming pattern `YYYY-MM-DD_description.png` (e.g.
> `2026-08-22_bitstream-complete.png`) so they sort chronologically and match the dates referenced in §3.

## 7. How to reproduce

1. Open Vivado 2020.1, create a new RTL project targeting **xc7z020clg484-1**.
2. Add all files under `src/` as design sources, `sim/tb_project.v` as a simulation source, and
   `constraints/zynq_uart_fifo.xdc` as a constraints file.
3. Set `project_top` as the top module.
4. Run Synthesis → Implementation → Generate Bitstream. All three should complete with no errors, matching
   the reports in `reports/`.

## 8. Next steps (Weeks 3–8, not yet done)

- [ ] Flash `project.bit` to the ZedBoard via Hardware Manager, verify `tx_busy_led`/`full`/`empty` respond
- [ ] Bridge `tx_out` to a USB-UART adapter and confirm bytes in a serial terminal (PuTTY/TeraTerm, 9600 8N1)
- [ ] Add UART RX + internal loopback, display received byte
- [ ] Push clock constraint to 150 MHz, identify and pipeline the critical path
- [ ] Rewrite core modules in SystemVerilog with assertions
- [ ] Wrap the design as a proper AXI4-Lite slave (the earlier AXI GPIO attempt was exploratory only)
