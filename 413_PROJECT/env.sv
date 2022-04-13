
`include "calc_if.sv"
`include "calc_request.sv"
`include "calc_master.sv"
`include "calc_monitor.sv"
`include "calc_result.sv"
`include "request_gen.sv"
`include "scoreboard.sv"


class test_cfg;

  int trans_cnt = 40;

endclass: test_cfg



class env;

  // Test configurations
  test_cfg    tcfg;

  // Transactors
  request_gen     gen;
  calc_master  mst;
  calc_monitor mon;
  scoreboard  scb;

  // APB transaction mailbox. Used to pass transaction
  // from APB gen to APB master, master to scoreboard, and monitor to scoreboard
  mailbox #(calc_request) gen2mas, mas2scb;
  mailbox #(calc_result) mon2scb;

  virtual calc_if aif;


  function new(virtual calc_if aif);
    this.aif  = aif;
    gen2mas   = new();
    mas2scb   = new();
    mon2scb   = new();
    tcfg      = new();
    
    gen      = new(gen2mas, tcfg.trans_cnt, 1);
    mst      = new(this.aif, gen2mas, mas2scb, 1);
    mon      = new(this.aif, mon2scb);
    scb      = new(tcfg.trans_cnt, mas2scb, mon2scb);
  endfunction: new


  virtual task pre_test();
    // Make sure the same # of transactions are expected by the scoreboard
    scb.max_trans_cnt = gen.max_trans_cnt;
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


