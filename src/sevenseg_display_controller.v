`default_nettype none
`ifndef __SEVENSEGDISPLAYCONTROLLER__
`define __SEVENSEGDISPLAYCONTROLLER__

`default_nettype none
`include "bcd_splitter.v"
`include "digit_selector.v"
`include "sevenseg_decoder.v"

module sevenseg_display_controller(
    input  wire       clk,
    input  wire [7:0] value,
    output wire [6:0] seg
);
    wire [3:0] hundreds, tens, ones;
    wire [1:0] state;
    reg  [3:0] current_digit;

    bcd_splitter splitter(.value(value), .hundreds(hundreds), .tens(tens), .ones(ones));
    digit_selector selector(.clk(clk), .state(state));

    always @(*) begin
        case (state)
            2'd0: current_digit = hundreds;
            2'd1: current_digit = tens;
            2'd2: current_digit = ones;
            default: current_digit = ones;  // state is 3 is present for a short time when state switches from 2 to 0 
        endcase
    end

    sevenseg_decoder decoder(.digit(current_digit), .seg(seg));
endmodule

`endif
`default_nettype wire