`timescale 1ns / 1ns
`include "../src/hello.v"

module hello_tb;

reg A;
wire B;

hello uut(A, B);

initial begin
  $dumpfile("hello_tb.vcd");
  $dumpvars(0, hello_tb);

  A = 0;
  #20;  // wait for 20 nanoseconds

  A = 1;
  #20;

  A = 0;
  #20;
  
end
    
endmodule