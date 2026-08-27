`timescale 1ns / 1ps
module tb_gray_code;
    reg clk;
    reg [3:0]bin;
    reg rst;
    wire [3:0]gray;

    gray_code uut(
        .clk(clk), .rst(rst), .bin(bin), .gray(gray)
    );
    always #5 clk=~clk;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0,tb_gray_code);
        rst=0;clk=0;#2;
        rst=1;#5;
        rst=0;bin=4'b0101;#15;
        bin=4'b1111;#15;
        bin=4'b0101;#15;
        $finish;
    end
endmodule

