/*
 * Top-level module for the "dip_switch_game" project
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none
`ifndef __DIPSWITCHGAME__
`define __DIPSWITCHGAME__

`include "sevenseg_display_controller.v"
`include "random_number_generator.v"
`include "timer.v"
`include "blink_controller.v"

module tt_um_dip_switch_game_TobiasPfaffeneder (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire ena,
    input  wire clk,
    input  wire rst_n
);

    wire rst = ~rst_n;

    wire [7:0] user_input = {ui_in[0],ui_in[1],ui_in[2],ui_in[3],ui_in[4],ui_in[5],ui_in[6],ui_in[7]};
    wire [7:0] random_number;
    wire [6:0] seg_display;

    reg trigger_display = 1'b0;
    reg [7:0] current_number = 8'd0;
    reg [7:0] uo_out_reg = 8'b00000000;
    reg [7:0] score = 8'd0;
    wire display_done;

    wire [7:0] timer_value;
    reg restart_timer = 1'b0;

    wire point_state;

    localparam PREGAME = 3'd0;
    localparam GENERATE_RANDOM_NUMBER = 3'd1;
    localparam WAIT_FOR_RANDOM_NUMBER = 3'd2;
    localparam DISPLAY_NUMBER = 3'd3;
    localparam GUESSING = 3'd4;
    localparam SHOW_SCORE = 3'd5;
    localparam GAME_OVER = 3'd6;
    reg [2:0] game_state = PREGAME;

    localparam BASETIME = 8'd30;
    wire [7:0] dynamic_maxtime;
    assign dynamic_maxtime = (score < 10) ? BASETIME - score :
                             (score < 20) ? 20 - (score - 10)/2 :
                             (score < 30) ? 15 - (score - 20)/3 :
                                            10;

    random_number_generator rng (
        .clk(clk),
        .rst(rst),
        .random(random_number)
    );

    sevenseg_display_controller display_ctrl (
        .clk(clk),
        .rst(rst),
        .trigger(trigger_display),
        .value(current_number),
        .seg(seg_display),
        .done(display_done)
    );

    timer tim (
        .clk(clk),
        .rst(rst),
        .restart_timer(restart_timer),
        .timer_value(timer_value)
    );

    blink_controller blink_ctrl (
        .clk(clk),
        .rst(rst),
        .enable(game_state == GUESSING),
        .timer_value(timer_value),
        .MAXTIME(dynamic_maxtime),
        .point_state(point_state)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            trigger_display <= 1'b0;
            restart_timer <= 1'b0;
            current_number <= 8'd0;
            score <= 8'd0;
            uo_out_reg <= 8'b00000000;
            game_state <= PREGAME;
        end else begin
            case (game_state)
                PREGAME: begin
                    if (user_input == 8'b00000001) begin
                        game_state <= GENERATE_RANDOM_NUMBER;
                    end
                end
                GENERATE_RANDOM_NUMBER: begin
                    current_number <= random_number;
                    game_state <= DISPLAY_NUMBER;
                end
                DISPLAY_NUMBER: begin
                    if (!trigger_display && !display_done) trigger_display <= 1'b1;
                    else trigger_display <= 1'b0;

                    if (display_done) begin
                        game_state <= GUESSING;
                        restart_timer <= 1'b1;
                    end
                end
                GUESSING: begin
                    if (trigger_display) trigger_display <= 1'b0;
                    if (restart_timer) restart_timer <= 1'b0;

                    if (timer_value > dynamic_maxtime) begin
                        game_state <= SHOW_SCORE;
                    end else if (user_input == current_number) begin
                        score <= score + 1;
                        game_state <= GENERATE_RANDOM_NUMBER;
                    end
                end
                SHOW_SCORE: begin
                    current_number <= score;
                    trigger_display <= 1'b1;
                    game_state <= GAME_OVER;
                end
                GAME_OVER: begin
                    trigger_display <= 1'b0;
                end
                default: game_state <= PREGAME;
            endcase

            uo_out_reg <= {(game_state == GUESSING) ? point_state : 1'b0, seg_display};
        end
    end

    assign uo_out = uo_out_reg;
    assign uio_out = 8'b0;
    assign uio_oe = 8'b0;

    wire _unused = &{uio_in, ena};

endmodule


`endif
`default_nettype wire
