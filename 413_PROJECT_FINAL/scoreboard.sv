`include "calc_request.sv"
`include "calc_result.sv"

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
  mailbox #(calc_request) mas2scb;
  mailbox #(calc_result) mon2scb;   

  //Result of calc_request
  calc_result_check res_check;
  
  //request and result objects
  calc_request mas_tr;
  calc_result mon_tr;
  
  //others   
  bit [31:0] expected_data_array[3:0];
  bit [31:0] exp_val;
  calc_request request_array[3:0];

  bit[3:0] c1;
  bit[31:0] d1;
  bit[31:0] d2;
  


  // Constructor
  function new(int max_trans_cnt, mailbox #(calc_request) mas2scb, mailbox #(calc_result) mon2scb, bit verbose=0);
    this.max_trans_cnt = max_trans_cnt;
	this.mon2scb       = mon2scb;
    this.mas2scb       = mas2scb;
    this.verbose       = verbose;
   
  endfunction
  



  // Method to receive transactions from master and monitor
  task main();
    fork
        forever begin
            mas2scb.get(mas_tr);//input
            
            request_array[mas_tr.tag] = mas_tr;
            
            case(mas_tr.cmd)
        
            //check for addition
            4'b0001:
                begin
                    exp_val = mas_tr.data + mas_tr.data2;
		   expected_data_array[mas_tr.tag] = exp_val;
                   
                end

            //check for sub				
            4'b0010:
                begin
                    exp_val = mas_tr.data - mas_tr.data2;
		   expected_data_array[mas_tr.tag] = exp_val;
                    				
                end

            //check for left shift				
            4'b0101:
                begin
                    exp_val = mas_tr.data << mas_tr.data2[4:0];
		   expected_data_array[mas_tr.tag] = exp_val;

                end

            //check for right shift				
            4'b0110:
                begin
                    exp_val = mas_tr.data >> mas_tr.data2[4:0];
                    expected_data_array[mas_tr.tag] = exp_val;
                   
                end

            
          default:
                begin
                  $display("SCOREBOARD ERROR");
                 
                end
            endcase
        end
        
        forever begin
            mon2scb.get(mon_tr);//output
            

            res_check = CORRECT;
            
          exp_val = expected_data_array[mon_tr.out_Tag];            
            
            if (mon_tr.out_Data !== exp_val) begin
                $display("\n[  ERROR  ]\t Port #: %1d \tExpected value: %d \tReceived Value: %5d \t CMD : %4b \tD1 : %5d \D2 : %d",mon_tr.out_Port,exp_val,   mon_tr.out_Data, request_array[mon_tr.out_Tag].cmd, request_array[mon_tr.out_Tag].data, request_array[mon_tr.out_Tag].data2);
                res_check = INCORRECT;
            end

     
            else if (mon_tr.out_Data == exp_val && exp_val!= 0)begin
                $display("\n[ CORRECT ]\t Port #: %1d \tExpected value: %d \tReceived Value: %5d",mon_tr.out_Port, mon_tr.out_Data, exp_val);
                res_check = CORRECT;
            end

            
            // Determine if the end of test has been reached
            if(--max_trans_cnt<1)
              ->ended;
            
        end // forever
    join_none
    
  endtask

endclass

