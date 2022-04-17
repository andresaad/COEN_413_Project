// COEN413 - WINTER 2022
// CONCORDIA UNIVERSITY
// U-G1


`include "Transaction.sv"
`include "Rslt.sv"

class scoreboard;

  // Verbosity level
  bit verbose;
  
  // Max # of transactions
  int max_cnt;
  event ended;

  // Number of good matches
  int match;

  // Transaction coming in
  mailbox #(Transaction) mas2scb;
  mailbox #(Rslt) mon2scb;   

  
  //request and result objects
  Transaction mas_tr;
  Rslt mon_tr;
  
  //others   
  bit [31:0] expected_data[3:0];
  bit [31:0] exp_val;
  Transaction request_array[3:0];

  logic [3:0] c1;
  logic [31:0] d1;
  bit[31:0] d2;

	int correct = 0;
        int error = 0;
  


  // Constructor
  function new(int max_trans_cnt, mailbox #(Transaction) mas2scb, mailbox #(Rslt) mon2scb, bit verbose=0);
    this.max_cnt       = max_cnt;
    this.mon2scb       = mon2scb;
    this.mas2scb       = mas2scb;
    this.verbose       = verbose;
   
  endfunction
  


  task main();
    fork
        forever begin
            mas2scb.get(mas_tr); //input
            request_array[mas_tr.tag] = mas_tr;
            
            case(mas_tr.cmd)
 	 
	   //LSL				
            4'b0101:
                begin
                    exp_val = mas_tr.data << mas_tr.data2[4:0];
		   expected_data[mas_tr.tag] = exp_val;

                end

            //LRS				
            4'b0110:
                begin
                    exp_val = mas_tr.data >> mas_tr.data2[4:0];
                    expected_data[mas_tr.tag] = exp_val;
                   
                end
        
            //ADD
            4'b0001:
                begin
                    exp_val = mas_tr.data + mas_tr.data2;
		   expected_data[mas_tr.tag] = exp_val;
                   
                end

            //SUB				
            4'b0010:
                begin
                    exp_val = mas_tr.data - mas_tr.data2;
		   expected_data[mas_tr.tag] = exp_val;
                    				
                end

           
          default:
                begin
                  $display("\n\n   \t\t\t\t\t---   INVALID COMMAND   ---   \n");
                 
                end
            endcase
        end
        
        forever begin
            mon2scb.get(mon_tr);//output
            
            
          exp_val = expected_data[mon_tr.out_Tag];            
            
            if (mon_tr.out_Data !== exp_val) begin
                $display("\n[  ERROR  ]\t Port #: %1d \tExpected value: %d \tReceived Value: %5d \t CMD : %4b \tD1 : %5d \D2 : %d",mon_tr.out_Port,exp_val,   mon_tr.out_Data, request_array[mon_tr.out_Tag].cmd, request_array[mon_tr.out_Tag].data, request_array[mon_tr.out_Tag].data2);
$display("\n \n Total Errors: %d", error++);
              
            end

     
            else if (mon_tr.out_Data == exp_val && exp_val!= 0)begin
                $display("\n[ CORRECT ]\t Port #: %1d \tExpected value: %d \tReceived Value: %5d",mon_tr.out_Port, mon_tr.out_Data, exp_val);

               
            end
		
            // Determine if the end of test has been reached
            if(--max_cnt<1)
              ->ended;
            
        end // forever
    join_none
    
  endtask

endclass

