`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2025 17:29:31
// Design Name: 
// Module Name: receiver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module receiver #(parameter CLKS_PER_BIT=10417)(
    input clk,
    input i_rx,
    output o_data_avail,
    output [7:0]o_data_byte
    );
    
    reg rx_buf;
    reg rx;
    reg data_avail;
    reg[7:0]data_byte;
    reg [1:0]state;
    reg[15:0]counter;
    reg [2:0]index;
    
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
        case(state)
            IDLE:begin
                counter<=0;
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
                if(counter==(CLKS_PER_BIT-1)/2)begin
                    if(rx==0)begin
                        counter<=0;
                        state<=GET_BIT;
                        end
                    else begin
                        state<=IDLE;
                        end
                    end
                else begin
                    counter<=counter+16'b1;
                end
            end
            
            GET_BIT:begin
                if(counter<CLKS_PER_BIT-1)begin
                    counter<=counter+16'b1;
                    state<=GET_BIT;
                    end
                 else begin
                    counter<=0;
                    data_byte[index]<=rx;
                    if(index<7)begin
                        index<=index+3'b1;
                        state<=GET_BIT;
                        end
                    else begin
                        index<=0;
                        state<=STOP;
                        end
                     end
            end
            
            STOP:begin
                if(counter<CLKS_PER_BIT-1)begin
                    counter<=counter+1;
                    state<=STOP;
                    end
                else begin
                    data_avail<=1'b1;
                    counter<=0;
                    state<=IDLE;
                    end
            end
            
            default:state<=IDLE;
            
        endcase
        
    end
    
endmodule