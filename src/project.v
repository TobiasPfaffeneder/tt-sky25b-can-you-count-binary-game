/*
 * Top-level module for the "hello" project
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none
`include "hello.v"

module project (
    input  wire [7:0] ui_in,     // Dedicated input pins
    output wire [7:0] uo_out,    // Dedicated output pins
    input  wire [7:0] uio_in,    // Bidirectional IO input path
    output wire [7:0] uio_out,   // Bidirectional IO output path
    output wire [7:0] uio_oe,    // Bidirectional IO output enable (1 = output)
    input  wire ena,             // Always high when powered
    input  wire clk,             // Clock input (unused)
    input  wire rst_n            // Active-low reset (unused)
);

    // Instantiate the hello module
    // Connect ui_in[0] to input A, and uo_out[0] to output B
    hello hello_inst (
        .A(ui_in[0]),
        .B(uo_out[0])
    );

    // Set unused output bits to 0
    assign uo_out[7:1] = 7'b0;
    assign uio_out     = 8'b0;
    assign uio_oe      = 8'b0;

    // Tie off unused inputs to avoid warnings
    wire _unused = &{uio_in, ena, clk, rst_n};

endmodule
