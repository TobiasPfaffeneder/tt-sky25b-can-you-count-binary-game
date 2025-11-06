`default_nettype none
`ifndef __BCDSPLITTER__
`define __BCDSPLITTER__

module bcd_splitter (
    input  wire [7:0] value,
    output wire [3:0] hundreds,
    output wire [3:0] tens,
    output wire [3:0] ones
);
    assign hundreds = (value / 8'd100) % 10;
    assign tens     = (value / 8'd10)  % 10;
    assign ones     = value % 10;
endmodule

`endif
`default_nettype wire
