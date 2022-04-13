/***************************************************************************
 *
 * File:        $RCSfile: test_03_cvr_driven.sv,v $
 * Revision:    $Revision: 1.2 $  
 * Date:        $Date: 2003/07/15 15:18:54 $
 *
 *******************************************************************************
 *
 * This test shows how to create coverage-driven test by generating
 * random transactions (e.g on-demand) until an expected
 * coverage goal is achieved.
 *
 * Basically, an apb_trans object is randomly generated
 * throughout the simulation run set in order to create a
 * directed test.
 *
 * A coverage group is attached to my_gen class and is used
 * to measure that the following conditions are met:
 *
 *   - All addresses
 *   - All READ,WRITE transactions
 *   - All possible data inside [0x00, 0x55, 0xAA, 0xFF]
 *
 * The virtual methods in my_gen are here overwritten so
 * to fulfill the above test patterns
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */

parameter TEST_LENGTH = 64;


program automatic test(apb_if hif);

`include "env/env.sv"

class my_gen extends apb_gen;
  
  // Define a coverage group aimed at ensuring that all
  // addresses, data and transactions are hit
  covergroup TransCov;

// LAB: Cover the transaction type 

// LAB: Cover the address values
    // All addresses
    
// LAB: Cover selected data values
    // Select data (4 values)


// LAB: Now perform cross coverage
    // Define a cross container based upon the 3 previous samples. 
    // Ensures that corner cases are also hit.
    tr_data_addr: cross trans, addr, data;

  endgroup


  // Constructor
  function new(mailbox #(apb_trans) apb_mbox=null, int max_trans_cnt, bit verbose=0);
    super.new(apb_mbox, max_trans_cnt, verbose);
    TransCov = new();
  endfunction


  function apb_trans get_transaction();
    int s;
    s = this.rand_tr.randomize() with {data inside {8'h00, 8'h55, 8'haa, 8'hff};
                                       transaction != IDLE;};
    if (!s) begin
      $display("apb_gen::randomize failed");
      $finish;
    end
    
    TransCov.sample;
    return rand_tr.copy();
  endfunction
  
endclass: my_gen


// Top level environment
env the_env;

// Instanciate the customized generator
my_gen my_generator;


initial begin
  // Instanciate the top level
  the_env = new(hif);

  // Plug the new generator
  my_generator = new(the_env.gen2mas, TEST_LENGTH, 1);
  the_env.gen  = my_generator;

  // Kick off the test now
  the_env.run();

  $finish;
end 

endprogram

