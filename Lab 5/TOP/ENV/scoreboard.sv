/*
scoreboard receives packet from agent, predicts results 	   
	declare mailbox + counting variable, connect in constructor
	logic to generate expected result   					   
	(example has checker code, move it there)   			   
*/

`include "transaction.sv"

class scoreboard;
	mailbox #(transaction) agt2scb;
	mailbox #(output_transaction) scb2chk;
	int trans_count;
	transaction tr;
	output_transaction otr;
	logic [32:0] sum;


	function new(mailbox #(transaction) agt2scb, mailbox #(output_transaction) scb2chk);
		this.scb2chk = scb2chk;
		this.agt2scb = agt2scb;
		this.otr = new();
	endfunction


	// get transaction, generate expected result, send to checker
	task main;
		forever begin
			agt2scb.get(tr);			// get transaction from agent
			expected_output(tr, otr);	// generate result
			scb2chk.put(otr);   		// send expected output to checker
		end
	endtask

	function void expected_output(transaction tr, output_transaction otr);
		otr.tr = tr;
		trans_count++;
		otr.out_tag = tr.tag;
		otr.ports = tr.ports;
		
		case(tr.cmd)
			NOOP:	begin
						otr.out_resp = 0;
					  	otr.out_data = 0;
					end

			ADD:	begin		// add + overflow logic
                		sum = tr.data1 + tr.data2;
						if (sum[32]) begin
							otr.out_data = 0;
							otr.out_resp = 2;
						end
						else begin
							otr.out_data = sum[31:0];
							otr.out_resp = 1;
						end
					end

			SUB:	begin		// sub + underflow logic
						if(tr.data1 < tr.data2) begin
							otr.out_data = 0;
							otr.out_resp = 2;
						end
						else begin
							otr.out_data = tr.data1 - tr.data2;
							otr.out_resp = 1;
						end
					end

			LSL:	begin
						otr.out_resp = 1;
						otr.out_data = tr.data1 << tr.data2[4:0];	// changed from [27:31] because definition is reversed (31:0 instead of 0:31)
					end

			LSR:	begin
						otr.out_resp = 1;
						otr.out_data = tr.data1 >> tr.data2[4:0];
					end

			default:begin
						otr.out_resp = 2;
						otr.out_data = 0;
					end
		endcase
		
	endfunction
	
endclass
