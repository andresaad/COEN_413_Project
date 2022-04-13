// converts high level to low level?

`include "transaction.sv"

class agent;
    mailbox #(transaction) gen2agt, agt2scb, agt2drv;
    transaction tr;

	function new(mailbox #(transaction) gen2agt, agt2scb, agt2drv);
		this.gen2agt = gen2agt;
		this.agt2scb = agt2scb;
		this.agt2drv = agt2drv;
	endfunction

	// function build?

	task main;
	forever begin
		gen2agt.get(tr);
    	//$display("Gen to agent cmd: %d", tr.cmd);
		agt2scb.put(tr);	// forward as is to scb and driver
		agt2drv.put(tr);

	end	
	endtask

	// task wrapup?
endclass