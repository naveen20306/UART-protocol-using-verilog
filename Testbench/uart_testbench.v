module uart_top_tb;

    reg clk;
    reg rst;
    reg clk_tick;
    reg tx_data_avail;
    reg [7:0] tx_data_byte;

    wire [8:0] rx_data_byte;
    wire error;
    wire rx_data_avail;
    wire tx_active;
    wire tx_done;

    uart_top uut (
        .clk(clk),
        .rst(rst),
        .clk_tick(clk_tick),
        .tx_data_avail(tx_data_avail),
        .tx_data_byte(tx_data_byte),
        .rx_data_byte(rx_data_byte),
        .error(error),
        .rx_data_avail(rx_data_avail),
        .tx_active(tx_active),
        .tx_done(tx_done)
    );

    initial clk = 0;
    always #5 clk = ~clk;



    initial begin
        rst = 1;
        tx_data_avail = 0;
        tx_data_byte = 8'h00;

         // Hold reset for 5 clock cycles
        repeat (5)@(posedge clk);
        rst = 0;

        // Wait some cycles after reset
        repeat (10) @(posedge clk);
        // Send first byte
        tx_data_byte = 8'h54;
        tx_data_avail = 1'b1;
        @(posedge clk);
        tx_data_avail = 0;

        @(posedge tx_done);

        // Wait for receiver data available
        @(posedge rx_data_avail);
        @(posedge clk);
        $display("Received byte = %b , Parity error = %b", rx_data_byte, error);

        // Send second byte
        tx_data_byte = 8'hAA;
        tx_data_avail = 1;
        @(posedge clk);
        tx_data_avail = 0;

        @(posedge tx_done);

        @(posedge rx_data_avail);
        @(posedge clk);
        $display("Received byte = %b , Parity error = %b", rx_data_byte, error);

        // Finish simulation
        repeat (100) @(posedge clk);
        $finish;
    end

   

endmodule