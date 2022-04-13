// COEN413 - WINTER 2022
// CONCORDIA UNIVERSITY

`define CALC_MONITOR_IF	calc_monitor_if
`include "calc_result.sv"

class calc_monitor;

  bit verbose;
  
  // Result Object
  calc_result tr;

  virtual calc_if.Monitor calc_monitor_if;
  mailbox #(calc_result) mon2scb;

    
  function new(virtual calc_if.Monitor calc_monitor_if, mailbox #(calc_result) mon2scb, bit verbose=0);
    this.mon2scb = mon2scb;
    this.calc_monitor_if = calc_monitor_if;
    this.verbose = verbose;
  endfunction: new

  task main();

    forever begin
      @(posedge calc_monitor_if.PClk)
      
      if (`CALC_MONITOR_IF.out_resp1 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `CALC_MONITOR_IF.out_resp1;
        tr.out_Data = `CALC_MONITOR_IF.out_data1;
        tr.out_Tag = `CALC_MONITOR_IF.out_tag1;
        tr.out_Port = 1; 
        
        mon2scb.put(tr);
      end
      
  
      if (`CALC_MONITOR_IF.out_resp2 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `CALC_MONITOR_IF.out_resp2;
        tr.out_Data = `CALC_MONITOR_IF.out_data2;
        tr.out_Tag = `CALC_MONITOR_IF.out_tag2;
        tr.out_Port = 2; 

        mon2scb.put(tr);
      end
      

      if (`CALC_MONITOR_IF.out_resp3 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `CALC_MONITOR_IF.out_resp3;
        tr.out_Data = `CALC_MONITOR_IF.out_data3;
        tr.out_Tag = `CALC_MONITOR_IF.out_tag3;
        tr.out_Port = 3; 
      
        mon2scb.put(tr);
      end
      
      
      if (`CALC_MONITOR_IF.out_resp4 !== 2'b00) begin
        this.tr = new;
        tr.out_Resp = `CALC_MONITOR_IF.out_resp4;
        tr.out_Data = `CALC_MONITOR_IF.out_data4;
        tr.out_Tag = `CALC_MONITOR_IF.out_tag4;
        tr.out_Port = 4; 
      
        mon2scb.put(tr);
      end

    end 
  endtask: main

endclass: calc_monitor

