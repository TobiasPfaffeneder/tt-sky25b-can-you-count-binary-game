`default_nettype none
`ifndef __BCDSPLITTER__
`define __BCDSPLITTER__

module bcd_splitter (
    input wire [7:0] value,
    output wire [3:0] hundreds,
    output wire [3:0] tens,
    output wire [3:0] ones
);
    // xxxx_full wires are required because for example "hundreds = (value / 8'd100)[3:0]" leads to an error (Linter warnings can be ignored)
    wire [7:0] hundreds_full = value / 8'd100;
    wire [7:0] tens_full = (value / 8'd10) % 8'd10;
    wire [7:0] ones_full = value % 8'd10;

    assign hundreds = hundreds_full[3:0];
    assign tens = tens_full[3:0];
    assign ones = ones_full[3:0];
endmodule

`endif
`default_nettype wire
