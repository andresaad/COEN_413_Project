/***************************************************************************
 *
 * File:        $RCSfile: test_02_constrained.sv,v $
 * Revision:    $Revision: 1.2 $
 * Date:        $Date: 2003/07/15 15:18:54 $
 *
 *******************************************************************************
 *
 * This test shows how to create directed test by generating
 * transactions on-the-fly (e.g on-demand).
 *
 * Basically, a apb_trans object is directly generated
 * throughout the simulation run with specific constraints
 * set in order to create a directed test.
 *
 * The scenario implemented here performs the following
 * transactions:
 *    - Constrained generation of object during simulation
 *    - Generates 32 WRITE cycles at address [0..31]
 *      with random data
 *    - Generates 32 READ cycles at address [0..31]
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */


parameter TEST_LENGTH = 64;


program automatic test(apb_if aif);

`include "env/env.sv"


// Extends the apb_trans to provide test-specific implementation
  class my_trans extends apb_trans;

// LAB: Create constraint block to generate 32 write transactions then
// 32 read transactions.  Use the "if" construct to test trans_cnt.

endclass


// Top level environment
env the_env;

// Instanciate the customized generator
my_trans my_tr;

initial begin
  // Instanciate the top level
  the_env = new(aif);
  the_env.gen.max_trans_cnt = TEST_LENGTH;
  
  my_tr = new;

  // LAB: Plug the new transaction into the generator's rand_tr


  // Kick off the test now
  the_env.run();

  $finish;
end

endprogram

