// Driver receives transactions from agent and forwards them to the right ports, based on transaction.ports

`include "transaction.sv"
`include "interface.sv"

class driver;

	int trans_count;
	transaction tr;
	virtual calc_if.DRIVER intf;
	mailbox #(transaction) agt2drv;

	function new(virtual calc_if.DRIVER intf, mailbox #(transaction) agt2drv);
		this.intf = intf;
		this.agt2drv = agt2drv;
		this.trans_count = 0;
	endfunction

	task reset;		// reset port inputs
		for(int i = 0; i<NUM_PORTS; i++) begin
			intf.cb.in_port[i].cmd_in = 0;
			intf.cb.in_port[i].data_in = 0;
			intf.cb.in_port[i].tag_in = 0;
		end
		$display("Driving inputs low");
	endtask

	task main;
		reset;	// drive all inputs low from start
		forever begin
			agt2drv.get(tr);	// wait for a transaction from agent
				fork
					drive_port(0);
					drive_port(1);
					drive_port(2);
					drive_port(3);
				join
			$display("Drove transaction %0s on ports %0b (%0d)", tr.cmd, tr.ports, trans_count);
			trans_count++;
			//$display("Drove transaction %0s on port %0d (%0d)", tr.cmd, tr.ports, trans_count);
		end
	endtask

	task drive_port(int p);		// drives input on port if transaction port matches
		if(tr.ports[p] && (tr.cmd!=0)) begin
		intf.cb.in_port[p].cmd_in		= tr.cmd;
		intf.cb.in_port[p].data_in		= tr.data1;
		intf.cb.in_port[p].tag_in		= tr.tag;
		@(intf.cb);
		intf.cb.in_port[p].cmd_in		= 0;
		intf.cb.in_port[p].data_in		= tr.data2;
		intf.cb.in_port[p].tag_in		= 0;
		@(intf.cb);
		intf.cb.in_port[p].data_in		= 0;
		
		end
	endtask

endclass
