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

      // Output from Port 1
      if (`APB_MONITOR_IF.out_resp1 !== 2'b00) begin

        // New Transaction
        this.tr = new; 

        $display("Output from Port 1");
        tr.out_Resp = `APB_MONITOR_IF.out_resp1;
        tr.out_Data = `APB_MONITOR_IF.out_data1;
        tr.out_Tag = `APB_MONITOR_IF.out_tag1;
        tr.out_Port = 1; 
        mon2scb.put(tr);
      end
      
      // Output from Port 2
      if (`APB_MONITOR_IF.out_resp2 !== 2'b00) begin

        // New Transaction
        this.tr = new;

        $display("Output from Port 2");
        tr.out_Resp = `APB_MONITOR_IF.out_resp2;
        tr.out_Data = `APB_MONITOR_IF.out_data2;
        tr.out_Tag = `APB_MONITOR_IF.out_tag2;
        tr.out_Port = 2; 
        mon2scb.put(tr);
      end
      
      // Output from Port 3
      if (`APB_MONITOR_IF.out_resp3 !== 2'b00) begin

        // New Transaction
        this.tr = new;

        $display("Output from Port 3");
        tr.out_Resp = `APB_MONITOR_IF.out_resp3;
        tr.out_Data = `APB_MONITOR_IF.out_data3;
        tr.out_Tag = `APB_MONITOR_IF.out_tag3;
        tr.out_Port = 3; 
        mon2scb.put(tr);
      end
      
      // Output from Port 4
      if (`APB_MONITOR_IF.out_resp4 !== 2'b00) begin
        
        // New Transaction
        this.tr = new;

        $display("Output from Port 4");
        tr.out_Resp = `APB_MONITOR_IF.out_resp4;
        tr.out_Data = `APB_MONITOR_IF.out_data4;
        tr.out_Tag = `APB_MONITOR_IF.out_tag4;
        tr.out_Port = 4; 
        mon2scb.put(tr);
      end

    end
  endtask: main
endclass: apb_monitor


