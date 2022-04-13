`include "calc_request.sv"

class request_gen;

  rand calc_request rand_tr;

  calc_request my_tr;

  int max_trans_cnt;
  

  event ended;
  
  // Counts the number of performed transactions
  int trans_cnt = 0;

  bit verbose;
  
  mailbox #(calc_request) gen2mas;
    
  // Constructor
  function new(mailbox #(calc_request) gen2mas, int max_trans_cnt, bit verbose=0);
    this.gen2mas       = gen2mas;
    this.verbose       = verbose;
    this.max_trans_cnt = max_trans_cnt;
    rand_tr            = new;
    my_tr = new;
  endfunction



  task main();
    while(trans_cnt <= max_trans_cnt)
      begin
	// Generating Random Transactions
        
        my_tr = randomizeTrans();
        gen2mas.put(my_tr);
        ++trans_cnt;
      end 
        
  
    ->ended;

  endtask


  virtual function calc_request randomizeTrans();
    rand_tr.trans_cnt = trans_cnt;
    if (! this.rand_tr.randomize() with {rand_tr.cmd dist{4'b0001 := 20, 4'b0010 := 1, 4'b0101 := 1, 4'b0110 := 1};})
      begin
        // Randomizing Error
        $finish;
      end

    return rand_tr.copy();
  endfunction

    
endclass

