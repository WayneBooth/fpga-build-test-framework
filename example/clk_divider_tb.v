
module clk_divider_tb ();

`include "test_include.v"

wire clk_out;

clk_divider #(.DIVIDE_BY(6)) DUT ( .clk_in(clk), .clk_out(clk_out) );

endmodule
