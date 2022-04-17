// COEN413 - WINTER 2022
// CONCORDIA UNIVERSITY

`define CALC_MASTER_IF	calc_master_if
`include "Transaction.sv"

  
class Master;

    bit verbose;
    virtual calc2_if.Master calc_master_if;
    mailbox #(Transaction) gen2mas, mas2scb;

  
    // Master Concstructor -> Virtual IF, Mailbox (gen2mas, mas2scb)
    function new(virtual calc2_if.Master calc_master_if, 
                 mailbox #(Transaction) gen2mas, mas2scb,
                 bit verbose=0);    
      this.verbose        = verbose;
      this.calc_master_if = calc_master_if;
      this.gen2mas        = gen2mas;
      this.mas2scb        = mas2scb;
    endfunction: new
    
    // Main Task for the Master Class
    task main();
       Transaction tr;

       $display("   ---   Beginning Master   ---");

       forever begin
     
        // Retrieve Transaction object from Mailbox then Drive to ports
        gen2mas.get(tr);
        drive(tr);

   
      end

      
    endtask: main
        

// Resets Pins to default
 task reset();
      `CALC_MASTER_IF.Rst <= 1;
      `CALC_MASTER_IF.PCmd  <= 0;
      `CALC_MASTER_IF.PData <= 0;
      `CALC_MASTER_IF.PTag <= 0;
      repeat(4) @(posedge `CALC_MASTER_IF.PClk);
      `CALC_MASTER_IF.Rst <= 0;
   endtask: reset


  // Driver to DUTPorts
  task  drive(Transaction tr);
     // First Command at first clock cycle
     @(negedge `CALC_MASTER_IF.PClk)
     `CALC_MASTER_IF.PCmd  <= tr.cmd;
     `CALC_MASTER_IF.PData <= tr.data;
     `CALC_MASTER_IF.PTag <= tr.tag;
     
     // Second command at following clock cycle
     @(negedge `CALC_MASTER_IF.PClk)
     `CALC_MASTER_IF.PCmd  <= 4'b0000;
     `CALC_MASTER_IF.PData <= tr.data2;
     `CALC_MASTER_IF.PTag <= 2'b00;
     
     // Adding Transaction to Master-Scoreboard Mailbox
     mas2scb.put(tr);

  endtask: drive
  
 

endclass: Master

