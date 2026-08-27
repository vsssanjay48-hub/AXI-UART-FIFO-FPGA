`timescale 1ns / 1ps
module gray_code(
    input wire [3:0]bin,
    input wire clk,
    input wire rst,
    output reg [3:0]gray

);
always @(posedge clk) begin
    if (rst==1) begin
        gray<=4'b0000;
    end
    else begin
        gray = bin ^ (bin >> 1);
    end
end
endmodule


//here gray will depend on the bin so to avoid this we can put bin<= bin+1; 
//inside the clk and wire--->reg
