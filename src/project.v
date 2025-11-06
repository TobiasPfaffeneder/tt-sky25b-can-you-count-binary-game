/*
 * Top-level module for the "dip_switch_game" project
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none
`ifndef __DIPSWITCHGAME__
`define __DIPSWITCHGAME__

`include "sevenseg_display_controller.v"
`include "random_number_generator.v"

module tt_um_dip_switch_game_TobiasPfaffeneder (
    input  wire [7:0] ui_in,     // DIP-Schalter
    output wire [7:0] uo_out,    // 7-Segment Display
    input  wire [7:0] uio_in,    // Unused
    output wire [7:0] uio_out,   // Unused
    output wire [7:0] uio_oe,    // Unused
    input  wire ena,             // Always high
    input  wire clk,             // System clock
    input  wire rst_n            // Active-low reset
);

    // === interne Signale ===
    wire        rst = ~rst_n;
    wire [7:0]  user_input = ui_in;
    wire [7:0]  random_number;
    wire [6:0]  seg_display;
    wire [1:0]  display_state;  // optional für Testbench
    reg         trigger = 0;
    reg         trigger_r = 0;   // gepuffertes Trigger-Signal für current_number
    reg  [7:0]  current_number = 0;
    reg         game_active = 0;

    // === Zufallszahlgenerator ===
    random_number_generator rng (
        .clk(clk),
        .rst(rst),
        .trigger(trigger),
        .random_out(random_number)
    );

    // === 7-Segment-Anzeige ===
    sevenseg_display_controller display_ctrl (
        .clk(clk),
        .rst(rst),
        .trigger(trigger_r),
        .value(current_number),
        .seg(seg_display)
    );

    // === 1. Trigger-Generierung & Puffer ===
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            trigger    <= 0;
            trigger_r  <= 0;
            game_active <= 0;
        end else begin
            trigger <= 0;

            // --- Startbedingung ---
            if (!game_active && ui_in == 8'b00000001) begin
                trigger <= 1;
                game_active <= 1;
            end

            // --- Trefferbedingung ---
            if (game_active && (user_input == current_number)) begin
                trigger <= 1;
            end

            // --- 1-Takt-Puffer ---
            trigger_r <= trigger;
        end
    end

    // === 2. Übernahme der Zufallszahl nach 1 Takt ===
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_number <= 0;
        else if (trigger_r)
            current_number <= random_number;
    end

    // === Ausgänge ===
    assign uo_out = {1'b0, seg_display}; // Punkt nicht genutzt
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // === Floating Inputs vermeiden ===
    wire _unused = &{uio_in, ena};

endmodule

`endif
`default_nettype wire
