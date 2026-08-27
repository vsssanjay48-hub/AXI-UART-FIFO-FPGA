`include "fifo.v"
`include "uart.v"
`include "handshake_fsm.v"
module project(
    input wire clk,
    input wire rst,
    input wire [7:0]data_in,
    input wire wi_en,
    output wire full,
    output wire empty,
    output wire tx_out,
    output wire tx_busy_led

);
wire fifo_empty;
wire fifo_rd_en;
wire [7:0]fifo_dout;
wire tx_busy;
wire tx_done;
wire tx_send;
wire [7:0]uart_din;
assign tx_busy_led=tx_busy;
assign empty = fifo_empty;
fifo inst(
    .rst(rst), .clk(clk), .data_in(data_in), .data_out(fifo_dout), .rd_en(fifo_rd_en), .wi_en(wi_en), .empty(fifo_empty), .full(full)
);
uart instt(
    .rst(rst), .clk(clk), .tx_active(tx_busy), .tx_out(tx_out), .tx_start(tx_send), .tx_data(uart_din), .tx_done(tx_done)
);
handshake_fsm insttt(
    .rst(rst), .clk(clk), .fifo_rd_en(fifo_rd_en), .uart_din(uart_din), .uart_send(tx_send), .tx_done(tx_done), .tx_busy(tx_busy), .fifo_empty(fifo_empty), .fifo_dout(fifo_dout)

);
endmodule



