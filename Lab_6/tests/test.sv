/***************************************************************************
 *
 * File:        $RCSfile: test_00_debug.sv,v $
 * Revision:    $Revision: 1.2 $  
 * Date:        $Date: 2003/07/15 15:18:54 $
 *
 *******************************************************************************
 *
 * This test shows how to run sanity check (purely random)
 * based upon the default verif environment.
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */


`include "env/env.sv"


program automatic test(calc_if hif);


// Top level environment
env the_env;

initial begin
  // Instanciate the top level
  $display("TEST START");
  the_env = new(hif);

  // Kick off the test now
  the_env.run();

  $finish;
end 

endprogram

