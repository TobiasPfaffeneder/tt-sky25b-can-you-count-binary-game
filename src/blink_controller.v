`default_nettype none
`ifndef __BLINKCONTROLLER__
`define __BLINKCONTROLLER__

module blink_controller (
    input  wire       clk,
    input  wire       rst,
    input  wire       enable,
    input  wire [7:0] timer_value,   // umbenannt von 'time'
    input  wire [7:0] MAXTIME,
    output reg        point_state    // kein Initialwert hier!
);
    reg [15:0] blink_counter = 0;
    wire [15:0] blink_threshold;
    wire [7:0] remaining = MAXTIME - timer_value;
    wire [7:0] third = MAXTIME / 3;

    assign blink_threshold = (remaining <= third)       ? 16'd200 :
                             (remaining <= 2*third)     ? 16'd500 :
                                                          16'd1000;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            point_state <= 1'b0;
            blink_counter <= 16'd0;
        end else if (enable) begin
            if (blink_counter >= blink_threshold) begin
                blink_counter <= 16'd0;
                point_state <= ~point_state;
            end else begin
                blink_counter <= blink_counter + 1;
            end
        end else begin
            point_state <= 1'b0;
            blink_counter <= 16'd0;
        end
    end
endmodule

`endif
`default_nettype wire
