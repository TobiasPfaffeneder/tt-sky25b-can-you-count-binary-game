`default_nettype none
`ifndef __SEVENSEGDISPLAYCONTROLLER__
`define __SEVENSEGDISPLAYCONTROLLER__

`include "bcd_splitter.v"
`include "digit_selector.v"
`include "sevenseg_decoder.v"

module sevenseg_display_controller(
    input  wire       clk,
    input  wire       rst,
    input  wire       trigger,
    input  wire [7:0] value,
    output wire [6:0] seg
);
    // BCD-Signale
    wire [1:0] state;
    wire [3:0] hundreds, tens, ones;
    reg  [3:0] current_digit;

    localparam DISPLAY_OFF = 4'd10;

    // Instanziierungen
    bcd_splitter splitter (
        .value(value),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );

    digit_selector selector (
        .clk(clk),
        .rst(rst),
        .trigger(trigger),
        .state(state)
    );

    // Auswahl des aktuellen BCD-Digits je nach Zustand
    always @(*) begin
        case (state)
            2'd0: current_digit = hundreds;
            2'd1: current_digit = tens;
            2'd2: current_digit = ones;
            2'd3: current_digit = DISPLAY_OFF;
            default: current_digit = DISPLAY_OFF;
        endcase
    end

    // 7-Segment-Dekoder
    sevenseg_decoder decoder (
        .digit(current_digit),
        .seg(seg)
    );

endmodule

`endif
`default_nettype wire
