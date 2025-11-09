`default_nettype none
`ifndef __RANDOMNUMBERGENERATOR__
`define __RANDOMNUMBERGENERATOR__


module random_number_generator (
    input  wire        clk,
    input  wire        rst,
    output reg  [7:0]  random = 8'hA5
);

    wire feedback = random[7] ^ random[5] ^ random[4] ^ random[3];

    always @(posedge clk or posedge rst) begin
        if (rst)
            random <= 8'hA5;
        else
            random <= {random[6:0], feedback};
    end
endmodule

`endif
`default_nettype wire