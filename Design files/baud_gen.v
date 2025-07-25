`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2025 04:24:34 PM
// Design Name: 
// Module Name: baud_gen
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


module baud_gen #(parameter CLK_FREQ=100_000_000,parameter BAUD=10_000_000)(input clk,input rst,output reg clk_tick);
localparam CLK_PER_BIT=CLK_FREQ/BAUD;
localparam WIDTH=$clog2(CLK_PER_BIT);

reg [WIDTH-1:0] counter;

always@(posedge clk  or posedge rst)
begin
    if(rst) begin
        counter<=0;
        clk_tick<=0;
    end
    else begin
            if(counter==CLK_PER_BIT-1)begin
                counter<=0;
                clk_tick<=~clk_tick;
            end
            else 
                counter=counter+1;
     end
end
endmodule
