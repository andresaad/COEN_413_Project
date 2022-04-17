`include "Transaction.sv"

class Generator;

  rand Transaction rand_tr;

  Transaction my_tr;

  int max_trans_cnt;
  

  event ended;
  
  // Counts the number of performed transactions
  int trans_cnt = 0;

  bit verbose;
  
  mailbox #(Transaction) gen2mas;
    
  // Constructor
  function new(mailbox #(Transaction) gen2mas, int max_trans_cnt, bit verbose=0);
    this.gen2mas       = gen2mas;
    this.verbose       = verbose;
    this.max_trans_cnt = max_trans_cnt;
    rand_tr            = new;
    my_tr = new;
  endfunction



  task main();

	addRand();  ++trans_cnt;
	addLow();  ++trans_cnt;
	addHigh();  ++trans_cnt;
	addOverflow();  ++trans_cnt;
	subLow();  ++trans_cnt;
	subHigh();  ++trans_cnt;
	invalidCommand();  ++trans_cnt;
	
    while(trans_cnt <= max_trans_cnt)
      begin

	// Generating Random Transactions
        my_tr = randomizeTrans();
        gen2mas.put(my_tr);
        
        ++trans_cnt;
      end 
        
  
    ->ended;

  endtask


task addLow();
	Transaction tr = new;
	tr.cmd = 4'b0001;
	tr.data = 32'h00000001;
	tr.data2 = 32'h00000001;
	gen2mas.put(tr);
endtask

task addRand();
	Transaction tr = new;
	tr.cmd = 4'b0001;
	tr.data = 32'h00000004;
	tr.data2 = 32'h00000004;
	gen2mas.put(tr);
endtask

task addHigh();
	Transaction tr = new;
	tr.cmd = 4'b0001;
	tr.data = 32'hFFFFFFFF;
	tr.data2 = 32'hFFFFFFFF;
	gen2mas.put(tr);
endtask

task addOverflow();
	Transaction tr = new;
	tr.cmd = 4'b0001;
	tr.data = 32'h1000000001;
	tr.data2 = 32'hFFFFFFFFF;
	gen2mas.put(tr);
endtask

task subLow();
	Transaction tr = new;
	tr.cmd = 4'b0010;
	tr.data = 32'd0;
	tr.data2 = 32'd0;
	gen2mas.put(tr);
endtask

task subHigh();
	Transaction tr = new;
	tr.cmd = 4'b0010;
	tr.data = 32'd0;
	tr.data2 = 32'd5;
	gen2mas.put(tr);
endtask

task invalidCommand();
	Transaction tr = new;
	tr.cmd = 4'b0011;
	tr.data = 32'd1;
	tr.data2 = 32'd1;
	gen2mas.put(tr);
endtask



  virtual function Transaction randomizeTrans();
    rand_tr.trans_cnt = trans_cnt;
    if (! this.rand_tr.randomize() with {rand_tr.cmd dist{4'b0001 := 1, 4'b0010 := 1, 4'b0101 := 1, 4'b0110 := 1};})
      begin
        // Randomizing Error
        $finish;
      end

    return rand_tr.copy();
  endfunction

    
endclass

