# Week 4 — UART RX on Hardware + Loopback Test

**Plan phase:** Phase 2 — Hardware Verification (Weeks 3–4)
**Dates:** Aug 22 – Aug 28, 2025 (project files timestamped Aug 28)
**Suggested tag:** `v2.0-hardware`

## Why this folder matches Week 4

The uploaded report (`report_rx/`) contains a **post-implementation Vivado run**
("Implementation Complete") for a project named
`Autonomous_UART_Transmission_Pipeline_rx`, targeting a Zynq-7020
(`xc7z020clg484-1`) part, with source files `project.v`, `uart.v`, `fifo.v`,
`tb_project.v`, and `zynq_uart_fifo.xdc`. The schematic nets include
`tx_send`, `tx_done`, `uart_din`, `data_in`, `data_out`, and **`rx_data`**,
and the I/O Ports view exposes an 8-bit `rx_data` output — i.e. this is the
combined **TX + FIFO + RX** design with the receive path wired in, which is
exactly the Week 4 goal ("Add UART RX to your hardware design... wire
internal loopback... verify sent byte matches received byte").

No separate utilization/XDC-authoring artifacts (Week 1–2) or AXI wrapper
files (Weeks 7–8) are present, and there's no 150 MHz stress-test timing
report (Week 5) — so this batch of files lines up specifically with the
**Week 4 hardware-loopback checkpoint**, not an earlier or later week.

## What's inside

```
week-04-uart-rx-hardware-loopback/
├── README.md
├── project-files/
│   ├── schematic.pdf                          # Post-implementation elaborated schematic (top-level nets/ports)
│   └── vivado-reports/
│       ├── implementation_run_log.vdi         # Vivado batch log: link_design → opt_design → place/route
│       ├── timing_1.rpx                       # Vivado timing report (open in Vivado: File > Open > Report)
│       └── power_1.rpx                        # Vivado power report (open in Vivado: File > Open > Report)
└── results/
    └── screenshots/
        ├── 01_io_ports_package_view.png       # Device/Package view + I/O Ports table (data_in[7:0], rx_data[8])
        ├── 02_power_summary.png                # Power report summary
        └── 03_design_hierarchy.png             # Design hierarchy / leaf-cell breakdown
```

> `.rpx` files are Vivado's native report format — they aren't plain text,
> so open them from Vivado (`File → Open → Report`) rather than a text
> editor to see the full timing/power tables.

## Results captured in this run

- **Implementation status:** Complete, 0 DRC errors (per `implementation_run_log.vdi`)
- **Target device:** `xc7z020clg484-1` (Zynq-7020)
- **Top-level ports seen in I/O Planning:** `clk`, `rst`, `wi_en`, `data_in[7:0]`, `rx_data[8:0]`, all `LVCMOS33`
- **Total on-chip power:** 0.109 W (Dynamic 0.003 W / 3%, Device Static 0.106 W / 97%)
  - Dynamic power split: Clocks 39%, I/O 36%, Logic 11%, Signals 14%
- **Design hierarchy (leaf cells):** 232 total across three sub-blocks (74 / 53 / 62 leaf cells); the 53-cell block includes a `RAM32M` distributed-memory instance — almost certainly the FIFO storage array

## Suggested next steps (per the 8-week plan)

- [ ] Confirm `rx_done` pulse and `rx_data` on LEDs match the byte sent via switches
- [ ] Add the 7-segment hex display of the received byte
- [ ] Record the demo video (switch input → button press → 7-segment update)
- [ ] Verify the RX 16× oversampling divisor for your board clock (100 MHz → 651)
- [ ] Tag this commit `v2.0-hardware` once loopback + display are verified on the board
