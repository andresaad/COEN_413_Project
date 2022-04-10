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
`include "apb_trans.sv"

  
class apb_master;

    // APB Interface (Master side)
    virtual apb_if.Master apb_master_if;

    // APB Transaction mailboxes
    mailbox #(apb_trans) gen2mas, mas2scb;

    // Verbosity level
    bit verbose;

    // Transaction Count
    int trans_cnt;
  
    // Constructor
    function new(virtual apb_if.Master apb_master_if, mailbox #(apb_trans) gen2mas,mas2scb, bit verbose=0);
      this.gen2mas       = gen2mas; // Generator-Master Mailbox
      this.mas2scb       = mas2scb; // Master-Scoreboard Mailbox
      this.apb_master_if = apb_master_if; // Master Interface
      this.verbose       = verbose; // Verbose
    endfunction: new
    

    // Main daemon. Runs forever to switch APB transaction to
    // corresponding read/write/idle command
    task main();
        // Create Transaction Object
       apb_trans tr;

       if(verbose)
         $display($time, " - Starting MASTER - ");

       forever begin

        // Wait & get a transaction from mailbox
        gen2mas.get(tr);
        drive(tr); 
      end

       if(verbose)
         $display($time, "- Ending Master - ");

    endtask: main



  // This task drives the transcation objects to the interface signals
  task  drive(apb_request tr);
  
    // FIRST COMMAND
     @(posedge `APB_IF.PClk)
     `APB_MASTER_IF.PCmd  <= tr.cmd; // COMMAND 
     `APB_MASTER_IF.PData <= tr.data;
     `APB_MASTER_IF.PTag <= tr.tag;
     
     // SEOCND COMMAND
     @(posedge `APB_MASTER_IF.PClk)
     `APB_MASTER_IF.PCmd  <= 4'b0000; // COMMAND = 0
     `APB_MASTER_IF.PData <= tr.data2;
     `APB_MASTER_IF.PTag <= 2'b00;
     
     mas2scb.put(tr); // Putting transaction into Master-Scoreboard Mailbox
     trans_cnt++; // Increasing Transaction Count
  endtask: sendRequest
  
  task idle();
    `APB_MASTER_IF.PCmd  <= 0;
    `APB_MASTER_IF.PData <= 0;
    `APB_MASTER_IF.PTag <= 0;
  endtask: idle

  task reset();
      `APB_MASTER_IF.Rst <= 1;
      `APB_MASTER_IF.PCmd  <= 0;
      `APB_MASTER_IF.PData <= 0;
      `APB_MASTER_IF.PTag <= 0;

      $display("Ports Succesfully Reset")
   endtask: reset

endclass: apb_master


  
    
