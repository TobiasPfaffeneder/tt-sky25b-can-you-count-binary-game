/*
 * Top-level module for the "dip_switch_game" project
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

`include "sevenseg_display_controller.v"

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

    // interne Verbindung
    wire [6:0] seg_w;

    // Decoder-Instanz
    sevenseg_display_controller sevenseg_display_controller_inst (
        .clk(clk),
        .value(ui_in[7:0]),
        .seg(uo_out[6:0])
    );

    // Ausgabe vollständig definiert (8 Bit)
    assign uo_out = {1'b0, seg_w};

    // Unbenutzte Ports deterministisch binden
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Vermeidung von "floating" Inputs im GL-Test
    wire _unused_ok = &{uio_in, ena, rst_n};

endmodule
