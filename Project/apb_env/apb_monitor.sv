/***************************************************************************
 *
 * Author:      Fabian Delguste 
 * File:        $RCSfile: apb_monitor.sv,v $
 * Revision:    $Revision: 1.2 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Basic Transaction Monitoring Module
 *
 * This transactor constantly watches the APB bus.
 * When a transaction is received, it is sent to the scoreboard.
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */

`define APB_MONITOR_IF	apb_monitor_if.monitor_cb
`include "apb_env/apb_trans.sv"


class apb_monitor;

  bit verbose;
  
  // Data member in charge of holding monitored transaction
  apb_trans tr;

  // APB Interface (Monitor side)
  virtual apb_if.Monitor apb_monitor_if;

  // Monitor to scoreboard mailbox
  mailbox #(apb_trans) mon2scb;

    
  function new(virtual apb_if.Monitor apb_monitor_if, mailbox #(apb_trans) mon2scb, bit verbose=0);
    this.apb_monitor_if = apb_monitor_if;
    this.verbose = verbose;
    this.mon2scb = mon2scb;
  endfunction: new

  task main();
bit Sel;
    forever begin

      // Wait for the device to be selected
      Sel = `APB_MONITOR_IF.PSel;
      if(Sel === 0) 
         @(posedge `APB_MONITOR_IF.PSel);
	#100;
      // Wait for latch enable
      @(posedge `APB_MONITOR_IF.PEnable);

      // Read/Write cycle decision
      this.tr = new;

      if(`APB_MONITOR_IF.PWrite) 
      begin
        // Store current transaction parameters 
        tr.transaction = WRITE;
        tr.data = `APB_MONITOR_IF.PWData;
        tr.addr = `APB_MONITOR_IF.PAddr;
      end
      else 
      begin
        // Read cycle
        // Store current transaction parameters 
        tr.transaction = READ;
        tr.data = `APB_MONITOR_IF.PRData;
        tr.addr = `APB_MONITOR_IF.PAddr;
      end
      
      // Pass the transaction to the scoreboard
      mon2scb.put(tr);
      
      if(verbose)
        tr.display("Monitor");

    end // forever
  endtask: main

endclass: apb_monitor


