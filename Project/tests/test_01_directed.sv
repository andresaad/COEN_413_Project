/***************************************************************************
 *
 * File:        $RCSfile: test_01_directed.sv,v $
 * Revision:    $Revision: 1.6 $  
 * Date:        $Date: 2003/07/15 15:18:54 $
 *
 *******************************************************************************
 *
 * This test shows how to create directed test by generating
 * transactions on-the-fly (e.g on-demand).
 *
 * Basically, a mem_cell_trans object is directly generated
 * throughout the simulation run set in order to create a
 * directed test.
 *
 * The scenario implemented here performs the following
 * transactions:
 *    - Constrained generation of object during simulation
 *    - Generates 32 WRITE cycles at address [0..31]
 *      with random data
 *    - Generates 32 READ cycles at address [0..31]
 *
 * The virtual methods in l2_gen are here overwritten so
 * to fulfill the above test patterns
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */


parameter TEST_LENGTH = 64;


program automatic test(apb_if aif);

`include "env/env.sv"


class my_gen extends apb_gen;
  
  // Constructor
  function new(mailbox #(apb_trans) apb_mbox, int max_trans_cnt, bit verbose=0);
    super.new(apb_mbox, max_trans_cnt, verbose);
  endfunction


  // Provides a new implementation of get_transaction()
  // This is how the directed testing flavor is performed
  
function apb_trans get_transaction();
    rand_tr = new();

// LAB: Create procedural code to generate 32 write transactions then
// 32 read transactions
    if (trans_cnt < 32) begin
        if (! this.rand_tr.randomize() with {(transaction == WRITE);})
          begin
            $display("apb_gen::randomize failed");
            $finish;
          end
    end
    else if(trans_cnt < 64) begin
        if (! this.rand_tr.randomize() with {(transaction == READ);})
          begin
            $display("apb_gen::randomize failed");
            $finish;
          end
    end

    //get_transaction = tr;
    return rand_tr.copy();
  endfunction
  
endclass: my_gen


// Top level environment
env the_env;

// Instanciate the customized generator
my_gen my_generator;

initial begin
  // Instanciate the top level
  the_env = new(aif);

  // Plug the new generator & config
  my_generator = new(the_env.gen2mas, TEST_LENGTH, 1);
  the_env.gen = my_generator;

  // Kick off the test now
  the_env.run();

  $finish;
end 

endprogram


