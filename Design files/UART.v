module uart_top #(
    parameter CLKS_PER_BIT = 10417
)(
    input  wire clk_100mhz,
    input  wire btn_tx_trigger,
    input  wire btn_reset,
    input  wire uart_rxd_in,
    output wire uart_txd_out,
    output wire [7:0] leds,
    output wire led_tx_active,
    output wire led_rx_data_avail
);

    wire [7:0] tx_data_byte_to_send;
    reg  tx_data_avail_trigger;
    wire tx_active_status;
    wire tx_done_status;

    wire rx_data_avail_status;
    wire [7:0] rx_data_byte_received;

    reg [7:0] data_to_transmit = 8'h00;

    // Connect the board's active-high reset button to an active-low reset for submodules
    wire rst_n = ~btn_reset; 

    // --- Transmitter Instance ---
    transmitter #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) u_transmitter (
        .i_data_avail  (tx_data_avail_trigger),
        .i_data_byte   (data_to_transmit),
        .clk           (clk_100mhz),
        .rst_n         (rst_n), // Connect reset
        .o_active      (tx_active_status),
        .o_done        (tx_done_status),
        .o_tx          (uart_txd_out)
    );

    // --- Receiver Instance ---
    receiver #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) u_receiver (
        .clk           (clk_100mhz),
        .rst_n         (rst_n), // Connect reset
        .i_rx          (uart_rxd_in),
        .o_data_avail  (rx_data_avail_status),
        .o_data_byte   (rx_data_byte_received)
    );

    // Assign LEDs to display received data and status
    assign leds = rx_data_byte_received;
    assign led_tx_active = tx_active_status;
    assign led_rx_data_avail = rx_data_avail_status;

    // Logic to control data transmission
    // This FSM ensures that data is sent only when the button is pressed
    // and the transmitter is not already active.
    always @(posedge clk_100mhz or negedge rst_n) begin // Change to negedge rst_n
        if (!rst_n) begin // Active low reset
            tx_data_avail_trigger <= 1'b0;
            data_to_transmit <= 8'h00;
        end else begin
            // Pulse tx_data_avail_trigger when button is pressed and transmitter is idle
            if (btn_tx_trigger && !tx_active_status) begin
                tx_data_avail_trigger <= 1'b1;
                data_to_transmit <= data_to_transmit + 8'b1; // Increment data to send
            end else begin
                tx_data_avail_trigger <= 1'b0; // De-assert after one clock cycle
            end
        end
    end

endmodule