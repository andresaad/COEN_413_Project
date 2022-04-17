
`include "Master.sv"
`include "Monitor.sv"
`include "Transaction.sv"
`include "Rslt.sv"
`include "calc2_if.sv"
`include "Generator.sv"
`include "scoreboard.sv"


class env;

  int tcount = 50;

  Generator gen;
  Master  mst;
  Monitor mon;
  scoreboard scb;



  // APB transaction mailbox. Used to pass transaction
  // from APB gen to APB master, master to scoreboard, and monitor to scoreboard
  mailbox #(Transaction) gen2mas, mas2scb;
  mailbox #(Rslt) mon2scb;

  virtual calc2_if vif;


  function new(virtual calc2_if vif);
    this.vif  = vif;
    gen2mas   = new();
    mas2scb   = new();
    mon2scb   = new();

    mst      = new(this.vif, gen2mas, mas2scb, 1);
    mon      = new(this.vif, mon2scb);
    gen      = new(gen2mas, tcount, 1);
    scb      = new(tcount, mas2scb, mon2scb);
  endfunction: new


  virtual task pre_test();
  
    scb.max_cnt = gen.max_trans_cnt;
    fork
      scb.main();
      mst.main();
      mon.main();
    join_none
  endtask: pre_test


  virtual task test();
    mst.reset();
    fork
      gen.main();
    join_none
  endtask: test


  virtual task post_test();
    fork
      wait(gen.ended.triggered);
      wait(scb.ended.triggered);
    join
  endtask: post_test


  task run();
    pre_test();
    test();
    post_test();
  endtask: run

endclass: env


