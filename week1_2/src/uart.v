//baud rate is 9600, uart clk freg is 50Mhz
module uart (
    input wire rst,
    input wire clk, 
    output reg tx_active,
    input wire tx_start,
    output reg tx_done,
    input wire [7:0]tx_data,
    output reg tx_out
);
reg [12:0]baud_count;
wire baud_tick;
reg [1:0]st;
reg [7:0]tx_shift;
reg [3:0]index;
localparam idle=2'b00;
localparam start=2'b01;
localparam data=2'b10;
localparam stop=2'b11;

assign baud_tick=(baud_count==(13'b1010001011000-13'b0000000000001));//here the frist number is 5208
//the baute rate is 9600, freq of uart  clock is 50Mhz, baud rate is 9600, so DIVISOR will be 50MHZ/9600=5208
//f 5208 means the transmitter or receiver spends exactly 5208 clock cycles for every single bit of data
always @(posedge clk) begin
    if(rst) begin
        baud_count<=13'd0;
    end
    else if(tx_active)begin
        if(baud_tick)begin
            baud_count<=13'd0;
        end
        else begin
            baud_count<=baud_count+13'd1;
        end
    end
    else begin
        baud_count<=13'd0;
    end
end
always @(posedge clk) begin
    if(rst)begin
        st<=idle;
        index<=4'd0;
        tx_shift<=8'd0;
        tx_active<=0;
        tx_done<=0;
        tx_out<=1'b0;
    end
    else begin
        case (st)
            idle:begin
                tx_out<=1'b1;
                tx_done<=1'b0;
                if(tx_start)begin
                    tx_active<=1;
                    tx_shift<=tx_data;
                    st<=start;
                end
            end
            start:begin
                tx_out<=0;
                if(baud_tick)begin
                    st<=data;
                    index<=4'd0;
                end
            end
            data:begin
                tx_out<=tx_shift[0];//key line
                if(baud_tick)begin
                    if(index==4'd7)begin
                        st<=stop;
                    end
                    else begin
                        index<=index+4'd1;
                        tx_shift<={1'b1,tx_shift[7:1]};
                    end
                end
            end
            stop:begin
                tx_done<=1'b1;
                tx_out<=1'b1;
                if(baud_tick)begin
                    tx_active<=1'b0;
                    tx_done<=1'b0;
                    st<=idle;
                end
            end
            default:st<=idle;
        endcase
    end
end
//total 8 bits are there so we need to index them from msb to lsb-----index is used
endmodule

