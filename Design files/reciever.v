`timescale 1ns / 1ps


module receiver (
    input clk,
    input clk_tick,
    input i_rx,
    input rst,
    output o_data_avail,
    output [8:0]o_data_byte
    );
    
    reg rx_buf;
    reg rx;
    reg data_avail;
    reg[8:0]data_byte;
    reg [1:0]state;
    reg [3:0]index;
    
    assign o_data_avail=data_avail;
    assign o_data_byte=data_byte;
    
    localparam IDLE=2'b00;
    localparam START=2'b01;
    localparam GET_BIT=2'b10;
    localparam STOP=2'b11;
    
    
    always@(posedge clk)begin
        rx_buf<=i_rx;
        rx<=rx_buf;
    end
    
    always@(posedge clk)begin
        if(rst)begin
            data_avail<=0;
            data_byte<=0;
            index<=0;
            rx_buf<=0;
            rx<=0;
            state<=IDLE;
            end
        else begin
            case(state)
                IDLE:begin
                    index<=0;
                    data_avail<=0;
                    
                    if(rx==0)begin
                        state<=START;
                        end
                    else begin
                        state<=IDLE;
                        end
                end
                
                START:begin
                    if(clk_tick)begin
                        if(rx==0)begin
                            state<=GET_BIT;
                            end
                        else begin
                            state<=IDLE;
                            end
                        end
                end
                
                GET_BIT:begin
                    if(clk_tick) begin
                        data_byte[index]<=rx;
                        if(index<8)begin
                            index<=index+4'b1;
                            state<=GET_BIT;
                            end
                        else begin
                            index<=0;
                            state<=STOP;
                            end
                         end
                end
                
                STOP:begin
                    if(clk_tick)begin
                        data_avail<=1'b1;
                        state<=IDLE;
                        end
                end
                
                default:state<=IDLE;
                
            endcase
        end
    end
    
endmodule