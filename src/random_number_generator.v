`default_nettype none
`ifndef __RANDOMNUMBERGENERATOR__
`define __RANDOMNUMBERGENERATOR__


module random_number_generator (
    input  wire        clk,
    input  wire        rst,
    input  wire        trigger,     // 1 Takt lang aktiv → neue Zahl
    output reg  [7:0]  random_out
);

    // === LFSR-Generator (läuft ständig) ===
    reg [7:0] lfsr;
    wire feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= 8'hA5;  // Seed (fester Startwert)
        else
            lfsr <= {lfsr[6:0], feedback};
    end

    // === Zufallszahl bei Trigger übernehmen ===
    always @(posedge clk or posedge rst) begin
        if (rst)
            random_out <= 8'd0;
        else if (trigger)
            random_out <= lfsr;
    end

endmodule

`endif
`default_nettype wire