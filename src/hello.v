`default_nettype none
`ifndef __COUNTER__
`define __COUNTER__

module hello (A, B);
	input  A;
	output B;

	assign B = A;

endmodule

`endif
`default_nettype wire