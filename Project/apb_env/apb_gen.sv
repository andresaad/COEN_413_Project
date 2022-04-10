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

  // Random transaction for Calculator
  rand apb_trans rand_tr;

  // Test terminates when the trans_cnt is greater
  // than max_trans_cnt member
  int max_trans_cnt;
  
  // event notifying that all transactions were sent
  event ended;
  
  // Counts the number of performed transactions
  int trans_cnt = 0;

  // Verbosity level
  bit verbose;
  
  // APB Transaction mailbox
  mailbox #(apb_trans) gen2mas;
    
  // Constructor
  function new(mailbox #(apb_trans) gen2mas, int max_trans_cnt, bit verbose=0);
    this.gen2mas       = gen2mas;
    this.verbose       = verbose;
    this.max_trans_cnt = max_trans_cnt;
    rand_tr            = new;
  endfunction


  // Method aimed at Generating transactions
  task main();
    if(verbose)
      $display($time, ": Starting Verifications for %0d transactions", max_trans_cnt);

    while((trans_cnt <= max_trans_cnt))
      begin
        // Declares transaction object
        //apb_trans my_tr;
        rand_tr = new();

        if(!rand_tr.randomize()) $fatal("Generator : Randomization Failed")
      
        // Increment the number of sent transactions
        if(rand_tr != IDLE)
          ++trans_cnt; //Increase Transaction Count
  
        if(verbose)
          rand_tr.display("Generator");

         gen2mas.put(rand_tr);
      end 
        
    if(verbose) 
      $display($time, ": Ending Generator \n");
  
    ->ended;

  endtask
    
endclass

