
`define CALC_MONITOR_IF	calc_monitor_if
`include "calc_result.sv"


class calc_monitor;

  bit verbose;
  
  // Data member in charge of holding monitored transaction
  calc_result tr;

  // Calc Interface (Monitor side)
  virtual calc_if.Monitor calc_monitor_if;

  // Monitor to scoreboard mailbox
  mailbox #(calc_result) mon2scb;

    
  function new(virtual calc_if.Monitor calc_monitor_if, mailbox #(calc_result) mon2scb, bit verbose=0);
    this.calc_monitor_if = calc_monitor_if;
    this.verbose = verbose;
    this.mon2scb = mon2scb;
  endfunction: new

  task main();
    bit [3:0] dummy;
    forever begin
      @(posedge calc_monitor_if.PClk)
      //@(`CALC_MONITOR_IF.out_resp1 != 2'b00, `CALC_MONITOR_IF.out_resp2 != 2'b00, `CALC_MONITOR_IF.out_resp3 != 2'b00, `CALC_MONITOR_IF.out_resp4 != 2'b00)
      
      //@(`CALC_MONITOR_IF.out_resp1, `CALC_MONITOR_IF.out_resp2, `CALC_MONITOR_IF.out_resp3, `CALC_MONITOR_IF.out_resp4)
      // Check for response from port 1
      
      
      if (`CALC_MONITOR_IF.out_resp1 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `CALC_MONITOR_IF.out_resp1;
        tr.out_Data = `CALC_MONITOR_IF.out_data1;
        tr.out_Tag = `CALC_MONITOR_IF.out_tag1;
        tr.out_Port = 1; 
        
        // Pass the transaction to the scoreboard
        mon2scb.put(tr);
      end
      
      // Check for response from port 2
      if (`CALC_MONITOR_IF.out_resp2 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `CALC_MONITOR_IF.out_resp2;
        tr.out_Data = `CALC_MONITOR_IF.out_data2;
        tr.out_Tag = `CALC_MONITOR_IF.out_tag2;
        tr.out_Port = 2; 
        
        // Pass the transaction to the scoreboard
        mon2scb.put(tr);
      end
      
      // Check for response from port 3
      if (`CALC_MONITOR_IF.out_resp3 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `CALC_MONITOR_IF.out_resp3;
        tr.out_Data = `CALC_MONITOR_IF.out_data3;
        tr.out_Tag = `CALC_MONITOR_IF.out_tag3;
        tr.out_Port = 3; //out_Port should be an integer
        
        // Pass the transaction to the scoreboard
        mon2scb.put(tr);
      end
      
      // Check for response from port 1
      if (`CALC_MONITOR_IF.out_resp4 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `CALC_MONITOR_IF.out_resp4;
        tr.out_Data = `CALC_MONITOR_IF.out_data4;
        tr.out_Tag = `CALC_MONITOR_IF.out_tag4;
        tr.out_Port = 4; //out_Port should be an integer
        
        // Pass the transaction to the scoreboard
        mon2scb.put(tr);
      end

    end // forever
  endtask: main

endclass: calc_monitor


