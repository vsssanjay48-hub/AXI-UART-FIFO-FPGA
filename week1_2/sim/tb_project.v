`timescale 1ns / 1ps

module tb_project;

    // 1. Interface Wires
    reg        clk;
    reg        rst;
    reg  [7:0] data_in;
    reg        wi_en;
    wire       full;
    wire       empty;
    wire       tx_out;

    // 2. Instantiate Device Under Test (DUT)
    project uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .wi_en(wi_en),
        .full(full),
        .empty(empty),
        .tx_out(tx_out)
    );

    // 3. 50 MHz System Clock Generator
    always #10 clk = ~clk;

    // 4. Main Verification Block
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_project);

        // Initialize inputs
        clk     = 0;
        rst     = 1;
        wi_en   = 0;
        data_in = 8'd0;
        
        // NEW STRATEGY: Directly block the FSM from pulling data out of the FIFO
        force uut.fifo_rd_en = 1'b0;

        #60;
        @(posedge clk);
        rst = 0; // Release system reset normally
        
        // =====================================================================
        // BURST WRITE
        // =====================================================================
        $display("[TB] Initiating inline 10-byte burst write on falling edges...");
        
        @(negedge clk); 
        wi_en = 1;       
        
        data_in = 8'h01; @(negedge clk); 
        data_in = 8'h02; @(negedge clk); 
        data_in = 8'h03; @(negedge clk); 
        data_in = 8'h04; @(negedge clk); 
        data_in = 8'h05; @(negedge clk); 
        data_in = 8'h06; @(negedge clk); 
        data_in = 8'h07; @(negedge clk); 
        data_in = 8'h08; @(negedge clk); // FIFO counter will hit 8 here!
        
        // Overflow Boundary Test
        data_in = 8'h09; @(negedge clk); 
        data_in = 8'h0A; @(negedge clk); 
        
        wi_en   = 0;
        data_in = 8'd0;
        
        @(posedge clk);
        #5; 

        // =====================================================================
        // Evaluate Boundary Results
        // =====================================================================
        if (full === 1'b1) begin
            $display("[TB SUCCESS] FIFO full flag is successfully asserted!");
        end else begin
            $display("[TB ERROR] FIFO is not reporting FULL after 8 writes. Current count is %d", uut.inst.count);
        end

        // Release the read enable wire to let the pipeline drain automatically
        $display("[TB] Releasing FSM control. Draining pipeline starting...");
        release uut.fifo_rd_en;

        // Run simulation window to complete UART serialization (~10 ms)
        #10000000;

        $display("[TB SUCCESS] Simulation complete. Verify results in GTKWave!");
        $finish;
    end

endmodule