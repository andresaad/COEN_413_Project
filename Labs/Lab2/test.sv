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


program automatic test(apb_if.Master apb);

`include "apb_trans.sv"
`include "apb_if.sv"
`include "apb_master.sv"
`include "apb_gen.sv"

  apb_gen     gen;
  apb_master  mst;

  // APB transaction mailbox. Used to pass transaction
  // from APB gen to APB master (Layered approach)
  mailbox #(apb_trans) apb_mbox;


initial begin
// LAB: Initialize apb_mbox 

// LAB: Call constructor for gen with 3 random transactions, verbose on

// LAB: Call constructor for mst, verbose on


// LAB: Call reset method of mst object


  fork
// LAB: Call main method of mst
// LAB: Call main method of gen  
  join_none

// LAB: Wait mailbox is not empty, block on @apb.cb


  // Wait some more clock cycles just to be sure
  repeat(10) @apb.cb;  

  $finish;
end 
endprogram
