/*
 * Testbench for project module
 */
`timescale 1ns / 1ns

module tb;

    // Inputs to the DUT
    reg [7:0] ui_in   = 8'h00;
    reg [7:0] uio_in  = 8'h00;
    reg       ena     = 1'b1;
    reg       clk     = 1'b0;
    reg       rst_n   = 1'b0;

    // Outputs from the DUT
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instantiate the Device Under Test (DUT)
    project dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .ena(ena),
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generator (not required for hello.v but included for completeness)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        // Release reset
        #10 rst_n = 1;

        // Apply test sequence to ui_in[0]
        #10 ui_in[0] = 0;
        #20 ui_in[0] = 1;
        #20 ui_in[0] = 0;
        #20 $finish;
    end

endmodule
