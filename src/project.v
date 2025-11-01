/*
 * Top-level module for the "dip_switch_game" project
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

// Vizualization
`include "sevenseg_decoder.v"
//`include "bcd_splitter.v"
//`include "digit_selector.v"
//`include "sevenseg_display_controller.v"

module tt_um_dip_switch_game_TobiasPfaffeneder (
    input  wire [7:0] ui_in,     // Dedicated input pins
    output wire [7:0] uo_out,    // Dedicated output pins
    input  wire [7:0] uio_in,    // Bidirectional IO input path
    output wire [7:0] uio_out,   // Bidirectional IO output path
    output wire [7:0] uio_oe,    // Bidirectional IO output enable (1 = output)
    input  wire ena,             // Always high when powered
    input  wire clk,             // Clock input (unused)
    input  wire rst_n            // Active-low reset (unused)
);

    // Instantiate the modules
    // sevenseg_display_controller sevenseg_display_controller_inst (
    //     .clk(clk),
    //     .value(ui_in[7:0]),
    //     .seg(uo_out[6:0])
    // );

    sevenseg_decoder sevenseg_decoder_inst (
        .digit(ui_in[3:0]),
        .seg(uo_out[6:0])
    );

    // Set unused output bits to 0
    assign uio_out      = 0;
    assign uio_oe       = 0;
    assign uo_out[7]    = 0;

    // Tie off unused inputs to avoid warnings
    wire _unused = &{ui_in[7:4], uio_in, ena, clk rst_n};

endmodule
