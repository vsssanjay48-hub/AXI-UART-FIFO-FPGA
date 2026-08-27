`timescale 1ns / 1ps

module baud_rate #(
    parameter FREQ    = 100000000, 
    parameter BAUD    = 9600,
    parameter DIVISOR = FREQ / BAUD 
)(
    input  wire rst,
    input  wire clk,
    output wire baud_tick
);

    reg [31:0] baud_count;

    
    assign baud_tick = (baud_count == (DIVISOR - 1));

    always @(posedge clk) begin
        if (rst) begin
            baud_count <= 32'd0;
        end
        else if (baud_tick) begin
            baud_count <= 32'd0;
        end
        else begin
            baud_count <= baud_count + 32'd1;
        end
    end

endmodule