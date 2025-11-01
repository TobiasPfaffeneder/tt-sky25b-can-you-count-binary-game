/*
 * Top-level module for the "dip_switch_game" project
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

`include "sevenseg_decoder.v"

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
    sevenseg_decoder sevenseg_decoder_inst (
        .digit(ui_in[3:0]),
        .seg(seg_w)
    );

    // Ausgabe vollständig definiert (8 Bit)
    assign uo_out = {1'b0, seg_w};

    // Unbenutzte Ports deterministisch binden
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Vermeidung von "floating" Inputs im GL-Test
    wire [3:0] unused_ui_in = ui_in[7:4];
    wire _unused_ok = &{unused_ui_in, uio_in, ena, clk, rst_n};

endmodule
