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

    // APB Interface (Master side)
    virtual apb_if.Master apb_master_if;

    // APB Transaction mailboxes
    mailbox #(apb_trans) gen2mas, mas2scb;

    // Verbosity level
    bit verbose;
  
    // Constructor
    function new(virtual apb_if.Master apb_master_if, 
                 mailbox #(apb_trans) gen2mas, mas2scb,
                 bit verbose=0);

      this.gen2mas       = gen2mas;
      this.mas2scb       = mas2scb;    
      this.apb_master_if = apb_master_if;
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


  // Sent the calc request to all 4 ports of the Calc
  task  sendRequest(apb_request tr);
     // Drive Control bus
     @(posedge `APB_IF.PClk)
     //#50;
     `APB_MASTER_IF.PCmd  <= tr.cmd;
     `APB_MASTER_IF.PData <= tr.data;
     `APB_MASTER_IF.PTag <= tr.tag;
     
     @(posedge `APB_MASTER_IF.PClk)
     //#50;
     `APB_MASTER_IF.PCmd  <= 4'b0000;
     `APB_MASTER_IF.PData <= tr.data2;
     `APB_MASTER_IF.PTag <= 2'b00;
     
     mas2scb.put(tr);
  endtask: sendRequest
  
  task reset();
      `APB_MASTER_IF.Rst <= 1;
      `APB_MASTER_IF.PCmd  <= 0;
      `APB_MASTER_IF.PData <= 0;
      `APB_MASTER_IF.PTag <= 0;
      repeat(4) @(posedge `CALC_MASTER_IF.PClk);
      //#20 `CALC_MASTER_IF.Rst <= 0;
      `CALC_MASTER_IF.Rst <= 0;
   endtask: reset

endclass: apb_master


  
    
