`default_nettype none
`ifndef __TIMER__
`define __TIMER__

module timer (
    input wire clk,
    input wire rst,
    input wire restart_timer,
    output reg [7:0] timer_value  
);

    localparam TIMER_DURATION = 10'd1000; // 1 second
    reg [9:0] counter = 0;
    reg active = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            active <= 0;
            timer_value <= 8'd0;
        end else begin
            if (restart_timer) begin
                active <= 1;
                counter <= 0;
                timer_value <= 8'd0;
            end else if (active) begin
                counter <= counter + 1;
                if (counter >= TIMER_DURATION) begin
                    counter <= 0;
                    timer_value <= timer_value + 1;
                end
            end
        end
    end
endmodule

`endif
`default_nettype wire
