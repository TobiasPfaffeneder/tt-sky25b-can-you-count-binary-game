`default_nettype none
`ifndef __DIGIT_SELECTOR__
`define __DIGIT_SELECTOR__

module digit_selector (
    input  wire clk,
    input  wire rst,
    input  wire trigger,
    output reg [1:0] state = 2'b11,
    output reg       done  = 1'b0
);

    reg [10:0] counter = 0;
    reg pause = 0;
    reg active = 0;
    reg [1:0] digit = 0;

    localparam DISPLAY_TIME = 1000; // 1 Sekunde
    localparam PAUSE_TIME   = 500;  // 0.5 Sekunden

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            pause   <= 0;
            active  <= 0;
            digit   <= 0;
            state   <= 2'b11;
            done    <= 1'b0;
        end else begin
            done <= 1'b0;

            if (!active) begin
                if (trigger) begin
                    active  <= 1;
                    pause   <= 0;
                    digit   <= 0;
                    state   <= 2'b00;
                    counter <= 0;
                end
            end else begin
                counter <= counter + 1;

                if ((!pause && counter >= DISPLAY_TIME) || (pause && counter >= PAUSE_TIME)) begin
                    counter <= 0;

                    if (!pause) begin
                        pause <= 1;
                        state <= 2'b11;
                    end else begin
                        pause <= 0;
                        if (digit == 2) begin
                            active <= 0;
                            state  <= 2'b11;
                            done   <= 1'b1;
                        end else begin
                            digit <= digit + 1;
                            state <= digit + 1;
                        end
                    end
                end
            end
        end
    end
endmodule

`endif
`default_nettype wire
