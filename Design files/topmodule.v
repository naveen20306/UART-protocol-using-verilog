`timescale 1ns / 1ps

module uart_top (
    input        clk,
    input        rst,
    input        clk_tick,
    input        parity,
    input        tx_data_avail,
    input  [7:0] tx_data_byte,
    output [8:0] rx_data_byte,
    output       error,
    output       rx_data_avail,
    output       tx_active,
    output       tx_done
);

    // Internal UART line connecting transmitter output to receiver input
    wire uart_line;

    // Transmitter Instance
    transmitter  transmitter_inst (
        .clk(clk),
        .rst(rst),
        .clk_tick(clk_tick),
        .parity(parity),
        .i_data_avail(tx_data_avail),
        .i_data_byte(tx_data_byte),
        .o_active(tx_active),
        .o_done(tx_done),
        .o_tx(uart_line)
    );

    // Receiver Instance
    receiver  receiver_inst (
        .clk(clk),
        .clk_tick(clk_tick),
        .i_rx(uart_line),
        .rst(rst),
        .o_data_avail(rx_data_avail),
        .o_data_byte(rx_data_byte)
    );
    
    parity_gen generator(
        .in(tx_data_byte),
        .parity(parity) );
        
    parity_checker check(
        .in(rx_data_byte),
         .error(error));
    
    baud_gen  #(.CLK_FREQ(100_000_000),.BAUD (10_000_000)) baud (
    .clk(clk),
    .rst(rst),
    .clk_tick(clk_tick)); 

endmodule