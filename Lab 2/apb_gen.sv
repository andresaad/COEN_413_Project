/*******************************************************************************
 *
 * File:        $RCSfile: apb_gen.sv,v $
 * Revision:    $Revision: 1.7 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Basic Transaction Generator aimed at randomizing and
 * initiating read() and write() transactions based
 * on APB BFM (apb_master)
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */


`include "apb_env/apb_trans.sv"


class apb_gen;

  // Random APB transaction
  rand apb_trans rand_tr;

  // Test terminates when the trans_cnt is greater
  // than max_trans_cnt member
  int max_trans_cnt;
  
  // Counts the number of performed transactions
  int trans_cnt = 0;

  // Verbosity level
  bit verbose;
  
  // APB Transaction mailbox
  mailbox #(apb_trans) gen2mas;
    

  // Constructor


   function new(mailbox #(apb_trans)gen2mas, int max_trans_cnt, bit verbose=0);
   
     // LAB: Create a constructor that sets the mailbox, transaction count, and
     // verbosity level, and constructs a new transaction.  
     // This is called from tests/test/sv
   endfunction;

  // Method aimed at generating transactions
  task main();
    if(verbose)
      $display($time, ": Starting apb_gen for %0d transactions", 
               max_trans_cnt);
    
    // Run this daemon as long as there is a transaction to be processed
    // LAB: Loop until number of non-IDLE transactions is greater than "max"
    
    while ( //put your condition here)   
     begin
        apb_trans my_tr;
        
        // Wait & Get a transaction
        my_tr = get_transaction();
  
        // Increment the number of sent transactions
        if(my_tr.transaction != IDLE)
          ++trans_cnt;
  
        if(verbose)
          my_tr.display("Generator");

        apb_mbox.put(my_tr);
      end // while (!end_of_test())
        
    if(verbose) 
      $display($time, ": Ending apb_gen\n");
  
  endtask


  // Returns a transaction (associated with tr member)

  function apb_trans get_transaction();
    rand_tr.trans_cnt = trans_cnt;
    if (! this.rand_tr.randomize())
      begin
        $display("apb_gen::randomize failed");
        $finish;
      end
    return rand_tr.copy();
  endfunction
    
endclass
