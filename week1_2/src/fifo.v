//here depth is 8 ,means 8 slots 
//width is also 8 the size of data getting in and out
module fifo (
    input wire       clk,
    input wire       rst,
    input wire       wi_en,      // Write Enable from testbench
    input wire       rd_en,      // Read Enable from Handshake FSM
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output wire      empty,
    output wire      full
);

    // Memory array for 8 items
    reg [7:0] mem [0:7];

    // 3-bit pointers safely index memory slots 0 through 7
    reg [2:0] wr_ptr; 
    reg [2:0] rd_ptr;

    // 4-bit wide counter holds values from 0 up to 8 safely
    reg [3:0] count;  

    // Continuous assignments for status flags
    assign empty = (count == 4'd0);
    assign full  = (count == 4'd8); 

    // 1. Write Logic (with Overflow Guarding)
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 3'b000;
        end 
        else if (wi_en && !full) begin
            mem[wr_ptr] <= data_in;
            wr_ptr      <= wr_ptr + 3'b001;
        end
    end

    // 2. Read Logic (with Underflow Guarding)
    always @(posedge clk) begin
        if (rst) begin
            rd_ptr   <= 3'b000;
            data_out <= 8'd0;
        end 
        else if (rd_en && !empty) begin
            data_out <= mem[rd_ptr];
            rd_ptr   <= rd_ptr + 3'b001;
        end
    end

    // 3. Dynamic Occupancy Counter (Ultra-Robust If-Else Layout)
    always @(posedge clk) begin
        if (rst) begin
            count <= 4'd0;
        end 
        else begin
            // Simultaneous valid Write and Read -> Net Neutral change
            if ((wi_en && !full) && (rd_en && !empty)) begin
                count <= count;
            end
            // Pure Valid Write operation -> Increment
            else if (wi_en && !full) begin
                count <= count + 4'd1;
            end
            // Pure Valid Read operation -> Decrement
            else if (rd_en && !empty) begin
                count <= count - 4'd1;
            end
        end
    end

endmodule