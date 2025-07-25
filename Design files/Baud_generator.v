`timescale 1ns / 1ps
module Baud_generator#(
    parameter CLK_FREQ = 100_000_000, // System clock frequency in Hz (e.g., 100 MHz)
    parameter BAUD_RATE = 10_000_000       // Desired baud rate (e.g., 9600 bps)
)(
    input clk,     // System clock
    input reset,   // System reset
    //output reg baud_tick, // Toggles at the baud rate
    // Output the calculated CLKS_PER_BIT value as a parameter.
    // The size of this output is determined by the maximum possible CLKS_PER_BIT value.
    output [($clog2(CLK_FREQ/BAUD_RATE)>1?$clog2(CLK_FREQ/BAUD_RATE):1)-1:0] clks_per_bit_val
);

    // Calculate CLKS_PER_BIT based on clock frequency and baud rate
    localparam CLKS_PER_BIT_CALC = CLK_FREQ / BAUD_RATE;
    // Determine the necessary bit width for the baud_counter
    localparam counter_size = (CLKS_PER_BIT_CALC > 1) ? $clog2(CLKS_PER_BIT_CALC) : 1;

    reg [counter_size-1:0] baud_counter; // Counter for baud rate generation

    // Assign the calculated CLKS_PER_BIT_CALC to the output port
    assign clks_per_bit_val = CLKS_PER_BIT_CALC;

    // Main always block for baud rate generation
   /*always@(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers on system reset
            baud_counter <= 0;
            baud_tick <= 0;
        end else begin
            // Increment baud_counter until it reaches CLKS_PER_BIT_CALC - 1
            if (baud_counter == CLKS_PER_BIT_CALC - 1) begin
                baud_counter <= 0;        // Reset counter
                baud_tick <= ~baud_tick;  // Toggle baud_tick
            end else begin
                baud_counter <= baud_counter + 1; // Increment counter
            end
        end
    end*/

endmodule
