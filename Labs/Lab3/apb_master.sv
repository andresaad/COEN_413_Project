/***************************************************************************
 *
 * File:        $RCSfile: apb_master.sv,v $
 * Revision:    $Revision: 1.8 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Basic Transaction Verification Module aimed at
 * creating read() and write() transactions based
 * on APB management Interface
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */


`define APB_MASTER_IF	apb_master_if.master_cb
`include "apb_env/apb_trans.sv"

  
class apb_master;

// LAB: Create a virtual APB Interface (Master side) called apb_master_if


    // APB Transaction mailboxes
    mailbox #(apb_trans) gen2mas, mas2scb;

    // Verbosity level
    bit verbose;

// LAB: Initialize apb_master_if with value passed in
    // Constructor
    function new(/*LAB*/ , 
                 mailbox #(apb_trans) gen2mas, mas2scb,
                 bit verbose=0);
      this.gen2mas       = gen2mas;
      this.mas2scb       = mas2scb;
      this.verbose       = verbose;
    endfunction: new
    

    // Main daemon. Runs forever to switch APB transaction to
    // corresponding read/write/idle command
    task main();
       apb_trans tr;

       if(verbose)
         $display($time, ": Starting apb_master");

       forever begin
        // Wait & get a transaction
        gen2mas.get(tr);
  
        // Decide what to do now with the incoming transaction
        case (tr.transaction)
          // Read cycle
          READ:
            read(tr);

          // Write cycle
          WRITE:
            write(tr);

          // Idle cycle
          default:
            idle();
        endcase

        if(verbose)
          tr.display("Master");
      end

       if(verbose)
         $display($time, ": Ending apb_master");

    endtask: main


    // Reset the DUT then go to active mode
    task reset();
      `APB_MASTER_IF.Rst <= 0;
      idle();
      #500 `APB_MASTER_IF.Rst <= 1;
   endtask: reset


    // Put the APB Bus in idle mode
    task idle();
      `APB_MASTER_IF.PAddr   <= 0;
      `APB_MASTER_IF.PSel    <= 0;
      `APB_MASTER_IF.PWData  <= 0;
      `APB_MASTER_IF.PEnable <= 0;
      `APB_MASTER_IF.PWrite  <= 0;
      #100 `APB_MASTER_IF.PWrite  <= 0;
   endtask: idle


   // Implementation of the read() method
   //    - drives the address bus,
   //    - select the  bus,
   //    - assert Penable signal,
   //    - read the data and return it.
   task read(apb_trans tr);
     // Drive Control bus
     `APB_MASTER_IF.PAddr  <= tr.addr;
     `APB_MASTER_IF.PWrite <= 1'b0;
     `APB_MASTER_IF.PSel   <= 1'b1;

     // Assert Penable
     #100 `APB_MASTER_IF.PEnable <= 1'b1;

     // Deassert Penable & return the read data
     #100 `APB_MASTER_IF.PEnable <= 1'b0;
     tr.data = `APB_MASTER_IF.PRData;
     mas2scb.put(tr);
  endtask: read
        

  // Perform a write cycle
   //    - Drive the address bus,
   //    - Select the  bus,
   //    - Drive data bus
   //    - Assert Penable signal,
  task  write(apb_trans tr);
     // Drive Control bus
     `APB_MASTER_IF.PAddr  <= tr.addr;
     `APB_MASTER_IF.PWData <= tr.data;
     `APB_MASTER_IF.PWrite <= 1'b1;
     `APB_MASTER_IF.PSel   <= 1'b1;

     // Assert Penable
     #100 `APB_MASTER_IF.PEnable <= 1'b1;

     // Deassert it
     #100 `APB_MASTER_IF.PEnable <= 1'b0;
     mas2scb.put(tr);
  endtask: write

endclass: apb_master

