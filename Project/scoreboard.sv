/***************************************************************************
 *
 * File:        $RCSfile: scoreboard.sv,v $
 * Revision:    $Revision: 1.2 $  
 * Date:        $Date: 2003/07/03 12:21:01 $
 *
 *******************************************************************************
 *
 * Scoreboard module used to verify the
 * incoming and outgoing transactions correctness
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */


`include "apb_trans.sv"
`include "apb_result.sv"


class scoreboard;

  typedef enum {CORRECT, INCORRECT} calc_result_check;

  // Verbosity level
  bit verbose;
  
  // Max # of transactions
  int max_trans_cnt;
  event ended;

  // Number of good matches
  int match;

  // Transaction coming in
  mailbox #(apb_trans) mas2scb, mon2scb;

  //request and result objects
  apb_trans mas_tr;
  apb_result mon_tr;

  //others   
  bit [31:0] expected_data_array[3:0];
  bit [31:0] exp_val;
  apb_trans request_array[3:0];
    

  // Covergroup for command inputs  
	covergroup cg_input;
        //input request
        request_cmd: coverpoint mas_tr.cmd {
          bins a = {4'b0001}; // ADDITION
          bins b = {4'b0010}; // SUBSTRACTION
          bins c = {4'b0101}; // LSL
          bins d = {4'b0110}; //LSR
        }
        request_data: coverpoint mas_tr.data;
        request_data2: coverpoint mas_tr.data2;
  endgroup
    

  //  Covergroup for DUT Outputs
  covergroup cg_output;
        
        //output value
        output_resp: coverpoint mon_tr.out_Resp{
          bins a = {2'b01};
          bins b = {2'b10};
        }
        output_data: coverpoint mon_tr.out_Data;
        //output_correctness: coverpoint res_check;
  endgroup

  // Constructor
  function new(int max_trans_cnt, mailbox #(apb_trans) mas2scb, mon2scb, bit verbose=0);
    this.max_trans_cnt = max_trans_cnt;
	  this.mon2scb       = mon2scb;
    this.mas2scb       = mas2scb;
    this.verbose       = verbose;
    
    cg_input = new();
    cg_output = new();
  endfunction
  



  // Method to receive transactions from master and monitor
  task main();
    fork
        forever begin
            // Receives input from mailbox
            mas2scb.get(mas_tr);
            
            //Perform covergroup sampling using built in sample()
            cg_input.sample(); 
            
            request_array[mas_tr.tag] = mas_tr;
            
            // Swithc for input command
            case(mas_tr.cmd)
        
            //Check for Addition --> cmd = 1
            4'b0001:
                begin
                    exp_val = mas_tr.data + mas_tr.data2;
                    expected_data_array[mas_tr.tag] = exp_val;
                end

            //Check for Subtraction --> cmd = 2		
            4'b0010:
                begin
                    exp_val = mas_tr.data - mas_tr.data2;
                    expected_data_array[mas_tr.tag] = exp_val;				
                end

            //Check for LSL  --> cmd = 5				
            4'b0101:
                begin
                    exp_val = mas_tr.data << mas_tr.data2[4:0];
                    expected_data_array[mas_tr.tag] = exp_val;
                end

            //Check for LRS  --> cmd = 6			
            4'b0110:
                begin
                    exp_val = mas_tr.data >> mas_tr.data2[4:0];
                    expected_data_array[mas_tr.tag] = exp_val;
                end

                  
                default:
                      begin
                        $display("Scoreboard --> Fatal error: Scoreboard received illegal master transaction");
                      end
                  endcase
              end
        
        forever begin
          // 
            mon2scb.get(mon_tr);
      
            exp_val = expected_data_array[mon_tr.out_Tag];
            
            if (mon_tr.out_Data !== exp_val) begin
                $display("@%0d: On port #: %d, Cmd: %40b, Data1: %h, Data2: %h, ERROR monitor data (%h) does not match expected value (%h)",
                    $time, mon_tr.out_Port, request_array[mon_tr.out_Tag].cmd, request_array[mon_tr.out_Tag].data, request_array[mon_tr.out_Tag].data2, mon_tr.out_Data, exp_val);
      
            end
            
            cg_output.sample(); 
        
            if(--max_trans_cnt<1)
              ->ended;
            
        end 
    join_none
    
  endtask

endclass
