/*
	Environment class contains instances of testbench components
		- generator, agent, driver, scoreboard, checker, monitor
		- interface passed through constructor (in tests)
		- mailboxes for intercomponent thread communication
		- instantiate in new()
*/

/*
                                              
    Generator and Driver activity can be divided and controlled in three methods.
        pre_test() � Method to call Initialization. i.e, reset method.           
        test() � Method to call Stimulus Generation and Stimulus Driving.        
        post_test() � Method to wait the completion of generation and driving.   
    run task to call methods, $finish; to end simulation                         
*/

`include "generator.sv"
`include "transaction.sv"
`include "agent.sv"
`include "driver.sv"
`include "monitor.sv"
`include "checker.sv"
`include "scoreboard.sv"
`include "interface.sv"


class environment;
	int repeat_count = 30;
	int finish_count = 0;

	// testbench components
	generator 	gen;
	agent		agt;
	scoreboard	scb;
	check		chk;
	driver		drv;
	monitor		mon;

	// interface ports
	virtual calc_if intf;
	
	// mailboxes for ipc
	mailbox #(transaction) gen2agt, agt2drv, agt2scb;
	mailbox #(output_transaction) scb2chk, mon2chk;

	event gen_ended;

	// constructor gets interfaces from tests object
	function new(virtual calc_if intf);
		this.intf = intf;
		
		gen2agt = new();
		agt2scb = new();
		scb2chk = new();
		agt2drv = new();
		mon2chk = new();

		gen = new(gen2agt, repeat_count, gen_ended);
		agt = new(gen2agt, agt2scb, agt2drv);
		scb = new(agt2scb, scb2chk);
		chk = new(scb2chk, mon2chk);
		drv = new(intf, agt2drv);
		mon = new(intf, mon2chk);

		//drv = new[NUM_PORTS];
		//mon = new[NUM_PORTS];

	endfunction


	// tasks for pre_test, test, post_test, run?
	task pre_test();
		// initialization, reset n stuf
		//drv.reset;

	endtask

	task do_test();
		// fork main()s
		fork
			gen.main;
			agt.main;
			drv.main;
			scb.main;
			mon.main;
			chk.main;
		join_any
	endtask

	task post_test();
		wait(gen.ended.triggered());
		//wait(gen.repeat_count == drv.trans_count);
		//$display("CB WATCH ABOUT TO BE CREATED %d", finish_count);
		finish_count = 0;
		fork
		  cb_watch;
		  mon_watch;
		join_any
		
		//$display("CB WATCH ENDED %d", finish_count);
		
		//wait(gen.repeat_count == chk.ac_count);
	endtask
	
	task cb_watch();
  forever begin
    @(intf.MONITOR.cb.out_port)
      if (finish_count > 30)
       break;
      finish_count = 0;
      //$display(" finish RESET %d", finish_count);
      
  end
	endtask

  task mon_watch();	
		forever begin 
	  @(posedge intf.MONITOR.clk)
      finish_count++;
      //$display(" finish incremented %d", finish_count);
    if (finish_count > 30)
       break;
  end
endtask;
	

	task run;
		pre_test();
		do_test();
		post_test();
	endtask

endclass
