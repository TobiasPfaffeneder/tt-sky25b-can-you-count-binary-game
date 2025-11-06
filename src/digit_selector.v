`default_nettype none
`ifndef __DIGIT_SELECTOR__
`define __DIGIT_SELECTOR__

module digit_selector (
    input  wire clk,
    input  wire rst,
    input  wire trigger,
    output reg [1:0] state
);

    // interne Signale
    reg [10:0] counter = 0;
    reg pause = 0;
    reg active = 0;       // läuft gerade eine Sequenz?
    reg [1:0] digit = 0;  // merkt sich, welche Stelle aktiv ist

    // Zeiten (bei z. B. 1 kHz Takt)
    localparam DISPLAY_TIME = 1000; // 1 Sekunde
    localparam PAUSE_TIME   = 500;  // 0.5 Sekunden

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            pause   <= 0;
            active  <= 0;
            digit   <= 0;
            state   <= 3; // Ruhezustand
        end else begin
            if (!active) begin
                // warten auf Trigger
                if (trigger) begin
                    active  <= 1;
                    pause   <= 0;
                    digit   <= 0;
                    state   <= 0;
                    counter <= 0;
                end
            end else begin
                // Sequenz läuft
                counter <= counter + 1;

                if ((!pause && counter >= DISPLAY_TIME) || (pause && counter >= PAUSE_TIME)) begin
                    counter <= 0;

                    if (!pause) begin
                        // Anzeigezeit vorbei → kurz Pause (Display aus)
                        pause <= 1;
                        state <= 3;
                    end else begin
                        // Pause vorbei → nächste Ziffer
                        pause <= 0;

                        if (digit == 2) begin
                            // Letzte Ziffer war aktiv → Sequenz beenden
                            active <= 0;
                            state  <= 3;
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
