module handshake_fsm(
    output reg fifo_rd_en,
    output reg uart_send,
    output reg [7:0]uart_din,
    input wire tx_done,
    input wire tx_busy,
    input wire fifo_empty,
    input wire [7:0]fifo_dout,
    input wire clk,
    input wire rst
);
reg [1:0]st;
localparam wait_data=2'b00;
localparam pop=2'b01;
localparam load=2'b10;
localparam transmit=2'b11;
always@(posedge clk)begin
    if(rst)begin
        fifo_rd_en<=0;
        uart_send<=0;
        uart_din<=8'd0;
        st<=wait_data;
    end
    else begin
        case(st)
            wait_data:begin
                if(fifo_empty==0 && tx_busy==0)begin
                    st<=pop;
                end
                else begin
                    st<=wait_data;
                end
            end
            pop:begin
                fifo_rd_en<=1;
                st<=load;
            end
            load:begin
                fifo_rd_en<=0;
                uart_din<=fifo_dout;
                uart_send<=1;
                st<=transmit;
            end
            transmit:begin
                uart_send<=0;  
                if(tx_done)begin
                    st<=wait_data;
                end
                else begin
                    st<=transmit;
                end
            end
            default:st<=wait_data;
        endcase 
    end
end
endmodule



