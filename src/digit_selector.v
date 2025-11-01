`default_nettype none
`ifndef __DIGITSELECTOR__
`define __DIGITSELECTOR__

module digit_selector (
    input  wire clk,
    output reg [1:0] state = 0
);
    reg [23:0] counter = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 1000) begin 
            counter <= 0;
            state <= state + 1;
        end
        if (state == 3)
            state <= 0;
    end
endmodule

`endif
`default_nettype wire