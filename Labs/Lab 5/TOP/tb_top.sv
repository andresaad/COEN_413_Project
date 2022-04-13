/*testbench top connects dut+tb
	declare+generate clock+reset
	create interface
	create design instance, connect if signals
	create test instance, pass if handle
	Add logic to generate the dump?
	*/


`include "tests.sv"
`include "calc2_top.v"
`include "interface.sv"

module tb_top;

	// declare clock, reset
	logic clk, reset;

	// generate clock
	initial begin
		reset = 0;
		clk = 0;

		// generate reset
		#5ns reset = 1;
		#5ns clk = 1;
		#5ns clk = 0;
		#5ns clk = 1;
		#5ns clk = 0;
		#5ns clk = 1;
		#5ns clk = 0;
		#5ns clk = 1;

		#5ns reset = 0;
		clk = 0;
		
		forever
			#5ns clk = ~clk;
	end
	

	// interface instance
	calc_if intf(clk,reset);

	// test instance
	tests t1(intf);

	// dut instance, connect if signals
	calc2_top DUT(	.c_clk(clk),
					.reset(reset),

					.req1_data_in(intf.in_port[0].data_in),
					.req2_data_in(intf.in_port[1].data_in),
					.req3_data_in(intf.in_port[2].data_in),
					.req4_data_in(intf.in_port[3].data_in),
					.req1_cmd_in(intf.in_port[0].cmd_in),
					.req2_cmd_in(intf.in_port[1].cmd_in),
					.req3_cmd_in(intf.in_port[2].cmd_in),
					.req4_cmd_in(intf.in_port[3].cmd_in),
					.req1_tag_in(intf.in_port[0].tag_in),
					.req2_tag_in(intf.in_port[1].tag_in),
					.req3_tag_in(intf.in_port[2].tag_in),
					.req4_tag_in(intf.in_port[3].tag_in),

					.out_data1(intf.out_port[0].out_data),
					.out_data2(intf.out_port[1].out_data),
					.out_data3(intf.out_port[2].out_data),
					.out_data4(intf.out_port[3].out_data),
					.out_resp1(intf.out_port[0].out_resp),
					.out_resp2(intf.out_port[1].out_resp),
					.out_resp3(intf.out_port[2].out_resp),
					.out_resp4(intf.out_port[3].out_resp),
					.out_tag1(intf.out_port[0].out_tag),
					.out_tag2(intf.out_port[1].out_tag),
					.out_tag3(intf.out_port[2].out_tag),
					.out_tag4(intf.out_port[3].out_tag)
				);

	// enable dump?


endmodule: tb_top
