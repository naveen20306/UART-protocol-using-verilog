module transmitter#(parameter CLKS_PER_BIT=10417)(
    input i_data_avail,
    input [7:0] i_data_byte,
    input clk,
    input rst_n, // Add asynchronous reset input (active low)
    output reg o_active,
    output reg o_done,
    output reg o_tx
);
    
    reg [7:0]data_byte;
    reg [1:0]state;
    reg [2:0]index;
    reg [15:0]counter;
    
    localparam IDLE=2'b00;
    localparam START=2'b01;
    localparam SEND_BIT=2'b10;
    localparam STOP=2'b11;
    
    always@(posedge clk or negedge rst_n)begin // Add rst_n to sensitivity list
        if (!rst_n) begin // Asynchronous reset for all registers
            counter <= 0;
            index <= 0;
            o_done <= 0;
            o_active <= 0; // Ensure active is reset
            o_tx <= 1'b1; // UART idle high
            state <= IDLE;
            data_byte <= 8'h00; // Initialize data_byte
        end else begin
            case(state)
                IDLE:begin
                    counter<=0;
                    index<=0;
                    o_done<=0;
                    o_tx<=1'b1;
                    if(i_data_avail==1'b1)begin
                        o_active<=1'b1;
                        data_byte<=i_data_byte;
                        state<=START;
                    end
                    else begin
                        state<=IDLE;
                    end
                end
                
                START:begin
                    o_tx<=0;
                    if(counter<CLKS_PER_BIT-1)begin
                        counter<=counter+16'b1;
                        state<=START;
                    end
                    else begin
                        counter<=0;
                        state<=SEND_BIT;
                    end             
                end
                
                SEND_BIT:begin
                    o_tx<=data_byte[index];
                    if(counter<CLKS_PER_BIT-1)begin
                        counter<=counter+16'b1;
                        state<=SEND_BIT;
                    end            
                    else begin
                        counter<=0;
                        if(index<7)begin
                            index<=index+3'b1;
                            state<=SEND_BIT;
                        end
                        else begin
                            index<=0;
                            state<=STOP;
                        end
                    end
                end
                
                STOP:begin 
                    o_tx<=1'b1;
                    if(counter<CLKS_PER_BIT-1)begin
                        counter<=counter+16'b1;
                        state<=STOP;
                    end   
                    else begin
                        o_active<=0;
                        o_done<=1;
                        state<=IDLE;
                    end
                end         
            endcase
        end // end if(!rst_n)
    end // end always
endmodule