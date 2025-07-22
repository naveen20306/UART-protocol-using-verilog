`timescale 1ns / 1ps

module uart_top_tb;

    // Parameters
    parameter CLKS_PER_BIT = 10417; // Same as in uart_top

    // Testbench signals
    reg  clk_100mhz;
    reg  btn_tx_trigger;
    reg  btn_reset;
    reg  uart_rxd_in;

    wire uart_txd_out;
    wire [7:0] leds;
    wire led_tx_active;
    wire led_rx_data_avail;

    // Instantiate the Unit Under Test (UUT)
    uart_top #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uut (
        .clk_100mhz        (clk_100mhz),
        .btn_tx_trigger    (btn_tx_trigger),
        .btn_reset         (btn_reset),
        .uart_rxd_in       (uart_rxd_in),
        .uart_txd_out      (uart_txd_out),
        .leds              (leds),
        .led_tx_active     (led_tx_active),
        .led_rx_data_avail (led_rx_data_avail)
    );

    // Clock generation
    initial begin
        clk_100mhz = 0;
        forever #5 clk_100mhz = ~clk_100mhz; // 100 MHz clock (10ns period)
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        btn_tx_trigger = 0;
        btn_reset = 0;
        uart_rxd_in = 1; // UART idle high

        // Dump waves for simulation
        $dumpfile("uart_top.vcd");
        $dumpvars(0, uart_top_tb);

        // Apply reset
        #10; // Wait a bit for initial setup
        btn_reset = 1;
        #20;
        btn_reset = 0;
        #100; // Allow system to stabilize after reset

        $display("--- Starting Transmission Test ---");
        // Trigger a transmission
        // The first data byte sent by uart_top will be 8'h00 (initial value)
        // Then it will increment for subsequent transmissions.
        btn_tx_trigger = 1;
        #10; // Hold trigger for one clock cycle
        btn_tx_trigger = 0;

        // Wait for transmission to complete (approx. 1 start + 8 data + 1 stop bits)
        // 10 bits * CLKS_PER_BIT * 10ns/clk = 10 * 10417 * 10ns = 1041700ns = 1.0417 ms
        # (10 * CLKS_PER_BIT * 10); // Wait for more than one byte transmission time

        $display("--- Starting Reception Test (Sending 'A' = 8'h41) ---");
        // Simulate receiving a byte 'A' (ASCII 0x41 = 01000001 binary)
        // LSB first: 1, 0, 0, 0, 0, 1, 0, 0
        // UART idle is high (1)

        // Start bit (0)
        uart_rxd_in = 0;
        # (CLKS_PER_BIT * 10); // Hold for one bit period

        // Data bits (LSB first) for 'A' (01000001)
        uart_rxd_in = 1; // Bit 0
        # (CLKS_PER_BIT * 10);
        uart_rxd_in = 0; // Bit 1
        # (CLKS_PER_BIT * 10);
        uart_rxd_in = 0; // Bit 2
        # (CLKS_PER_BIT * 10);
        uart_rxd_in = 0; // Bit 3
        # (CLKS_PER_BIT * 10);
        uart_rxd_in = 0; // Bit 4
        # (CLKS_PER_BIT * 10);
        uart_rxd_in = 1; // Bit 5
        # (CLKS_PER_BIT * 10);
        uart_rxd_in = 0; // Bit 6
        # (CLKS_PER_BIT * 10);
        uart_rxd_in = 0; // Bit 7 (MSB)
        # (CLKS_PER_BIT * 10);

        // Stop bit (1)
        uart_rxd_in = 1;
        # (CLKS_PER_BIT * 10);

        // Return to idle (high)
        uart_rxd_in = 1;
        # (CLKS_PER_BIT * 10); // Wait for receiver to process the stop bit and assert data_avail

        $display("--- End of Simulation ---");
        #100; // Small delay before finishing
        $finish; // End simulation
    end

    // Monitor signals for debugging
    initial begin
        $monitor("Time=%0t | clk_100mhz=%b | btn_tx_trigger=%b | btn_reset=%b | uart_rxd_in=%b | uart_txd_out=%b | leds=%h | led_tx_active=%b | led_rx_data_avail=%b | data_to_transmit=%h | rx_data_byte_received=%h",
                 $time, clk_100mhz, btn_tx_trigger, btn_reset, uart_rxd_in, uart_txd_out, leds, led_tx_active, led_rx_data_avail, uut.data_to_transmit, uut.rx_data_byte_received);
    end

endmodule