/***************************************************************************
 *
 * File:        $RCSfile: env.v,v $
 * Revision:    $Revision: 1.3 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Verification environment
 * Instanciates following modules:
 * 	- APB Generator
 * 	- APB Master
 * 	- APB Monitor
 * 	- Scoreboard
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */


`include "Calc_env/calc_if.sv"
`include "Calc_env/calc_request.sv"
`include "Calc_env/calc_master.sv"
`include "Calc_env/calc_monitor.sv"
`include "Calc_env/calc_result.sv"
`include "Calc_env/request_gen.sv"
`include "env/scoreboard.sv"

////////////////////////////////////////////////////////////
class test_cfg;

  // Test terminates when the trans_cnt is greater than max_trans_cnt member
  //rand int trans_cnt;
  int trans_cnt = 400;

  //constraint basic {
  //  (trans_cnt > 0) && (trans_cnt < 100);
  //}
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
    if (!tcfg.randomize()) 
      begin
        $display("test_cfg::randomize failed");
        $finish;
      end
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


