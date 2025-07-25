module transmitter(
    input i_data_avail,
    input [7:0] i_data_byte,
    input clk,
    input rst, // Add asynchronous reset input (active low)
    input clk_tick,
    input parity,
    output reg o_active,
    output reg o_done,
    output reg o_tx
);
    
    reg [7:0]data_byte;
    reg [1:0]state;
    reg [2:0]index;
        
    localparam IDLE=2'b00;
    localparam START=2'b01;
    localparam SEND_BIT=2'b10;
    localparam STOP=2'b11;
    
    
    always@(posedge clk or negedge rst_n)begin // Add rst_n to sensitivity list
        if (rst) begin // Asynchronous reset for all registers
            index <= 0;
            o_done <= 0;
            o_active <= 0; // Ensure active is reset
            o_tx <= 1'b1; // UART idle high
            state <= IDLE;
            data_byte <= 8'h00; // Initialize data_byte
        end else begin
            case(state)
                IDLE:begin
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
                    if(clk_tick)begin
                        state<=SEND_BIT;
                    end             
                end
                
                SEND_BIT:begin
                    o_tx<=data_byte[index];
                     if(clk_tick)begin
                        if(index<8)begin // Iterate through data bits 0 to 7 (total 8 bits)
                            index<=index+3'b1;
                            state<=SEND_BIT;
                        end
                        else if (index == 8) begin // After sending 8 data bits, send parity bit
                            index <= index + 3'b1; // Increment for stop bit
                            state <= STOP;
                        end
                        else begin // Should ideally go to STOP state after parity
                            index<=0;
                            o_tx<=1'b1;
                            state<=STOP;
                        end
                    end
                end
                
                STOP:begin 
                    o_tx<=1'b1;
                    if(clk_tick)begin
                        o_active<=0;
                        o_done<=1;
                        state<=IDLE;
                    end
                end
                
                default:state<=IDLE;
                         
            endcase
        end // end if(!rst_n)
    end // end always
endmodule