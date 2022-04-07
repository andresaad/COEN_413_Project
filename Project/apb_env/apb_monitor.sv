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
  apb_result tr;

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
    bit [3:0] test;

    forever begin
      @(posedge calc_monitor_if.PClk)

      // If output response = 0 
      // // Check for response from port 1
      if (`APB_MONITOR_IF.out_resp1 !== 2'b00) begin
        this.tr = new; //Instantiate New result object
        tr.out_Resp = `APB_MONITOR_IF.out_resp1;
        tr.out_Data = `APB_MONITOR_IF.out_data1;
        tr.out_Tag = `APB_MONITOR_IF.out_tag1;
        tr.out_Port = 1; //out_Port should be an intege
        // Pass the transaction to the scoreboard
        mon2scb.put(tr);
      end
      
      // Check for response from port 2
      if (`APB_MONITOR_IF.out_resp2 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `APB_MONITOR_IF.out_resp2;
        tr.out_Data = `APB_MONITOR_IF.out_data2;
        tr.out_Tag = `APB_MONITOR_IF.out_tag2;
        tr.out_Port = 2; //out_Port should be an integer
        // Pass the transaction to the scoreboard
        mon2scb.put(tr);
      end
      
      // Check for response from port 3
      if (`APB_MONITOR_IF.out_resp3 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `APB_MONITOR_IF.out_resp3;
        tr.out_Data = `APB_MONITOR_IF.out_data3;
        tr.out_Tag = `APB_MONITOR_IF.out_tag3;
        tr.out_Port = 3; //out_Port should be an integer
        // Pass the transaction to the scoreboard
        mon2scb.put(tr);
      end
      
      // Check for response from port 4
      if (`APB_MONITOR_IF.out_resp4 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `APB_MONITOR_IF.out_resp4;
        tr.out_Data = `APB_MONITOR_IF.out_data4;
        tr.out_Tag = `APB_MONITOR_IF.out_tag4;
        tr.out_Port = 4; //out_Port should be an integer
        // Pass the transaction to the scoreboard
        mon2scb.put(tr);
      end

    end // forever
  endtask: main
endclass: apb_monitor


