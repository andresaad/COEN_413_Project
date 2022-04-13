`ifndef	CALC_IF_DEFINE
`define	CALC_IF_DEFINE

`include "definitions.sv"

//typedef virtual calc_if.DRIVER drv_if;
//typedef virtual calc_if.MONITOR mon_if;

interface calc_if(input wire clk, reset);      // reset controlled in top

	// Port signals
	input_port	in_port[NUM_PORTS];
	output_port	out_port[NUM_PORTS];

	// clocking blocks

	clocking cb @(posedge clk);
		output 	in_port;
		input	out_port;
	endclocking

	// modports				
	modport DRIVER  (clocking cb, input clk, reset);
	modport MONITOR (clocking cb, input clk, reset);

endinterface

`endif