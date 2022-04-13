`include "calc_request.sv"

class request_gen;

  // Random APB transaction
  rand calc_request rand_tr;

  calc_request my_tr;

  int max_trans_cnt;
  
  // event notifying that all transactions were sent
  event ended;
  
  // Counts the number of performed transactions
  int trans_cnt = 0;

  // Verbosity level
  bit verbose;
  
  // APB Transaction mailbox
  mailbox #(calc_request) gen2mas;
    
  // Constructor
  function new(mailbox #(calc_request) gen2mas, int max_trans_cnt, bit verbose=0);
    this.gen2mas       = gen2mas;
    this.verbose       = verbose;
    this.max_trans_cnt = max_trans_cnt;
    rand_tr            = new;
    my_tr = new;
  endfunction

  // Method aimed at generating transactions
  task main();

 
    while(trans_cnt <= max_trans_cnt)
      begin
       
        my_tr = get_transaction();
        ++trans_cnt;
  

        gen2mas.put(my_tr);
      end 
        
  
    ->ended;

  endtask

    
  virtual function calc_request get_transaction();
    rand_tr.trans_cnt = trans_cnt;
    if (! this.rand_tr.randomize() with {rand_tr.cmd dist{4'b0001 := 25, 4'b0010 := 25, 4'b0101 := 25, 4'b0110 := 25};})
      begin
        $display("apb_gen::randomize failed");
        $finish;
      end
      
    return rand_tr.copy();
  endfunction
    
endclass

