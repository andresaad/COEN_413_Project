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


`include "apb_env/apb_trans.sv"
`include "apb_env/apb_if.sv"
`include "apb_env/apb_master.sv"
`include "apb_env/apb_monitor.sv"
`include "apb_env/apb_gen.sv"
`include "apb_env/apb_result.sv"
`include "env/scoreboard.sv"


////////////////////////////////////////////////////////////
class test_cfg; // Test Configuration

  // Test terminates when the trans_cnt is greater than max_trans_cnt member
  rand int trans_cnt;

  constraint basic {
    (trans_cnt > 0) && (trans_cnt < 100);
  }
endclass: test_cfg



class env;

  // Test configurations
  test_cfg    tcfg;

  // Transactors
  apb_gen     gen;
  apb_master  mst;
  apb_monitor mon;
  scoreboard  scb;

  // APB transaction mailbox. Used to pass transaction
  // from APB gen to APB master, master to scoreboard, and monitor to scoreboard
  mailbox #(apb_trans) gen2mas, mas2scb;
  mailbox #(calc_result)mon2scb;


  virtual apb_if aif; // Virtual Interface


  function new(virtual apb_if aif);
    this.aif  = aif;
    gen2mas   = new(); //Mailbox between Generator and Master
    mas2scb   = new();
    mon2scb   = new();
    tcfg      = new();

// Checks randomization
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


