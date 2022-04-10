/***************************************************************************
 *
 * File:        $RCSfile: apb_trans.sv,v $
 * Revision:    $Revision: 1.5 $  
 * Date:        $Date: 2003/07/02 15:47:08 $
 *
 *******************************************************************************
 *
 * APB Transaction Structure
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */
`ifndef APB_IF_DEFINE
`define APB_IF_DEFINE

`include "root.sv"

class apb_trans;
   
    rand bit [3:0] cmd; //COMMAND
    rand bit [31:0] data; //DATA #1 
    rand bit [31:0] data2; // DATA #2
    bit [1:0] tag; //identifies the command when the response is received.
    rand bit [4:0] port;

    static int count=0; //counter
    int id, trans_cnt; //ID and Transaction Count

  function new;
    id = count++;
    tag = id;
  endfunction

// Displays inputted name, command and data
  function void display(string name);
  $display("-----------------");
  $display("- %s ", name, "- CMD: %0d ,  DATA1 : %0d , Data2: %0d: ", cmd, data, data2);
  endfunction

// Testing Individual Ports
  constraint isolateport1 { port == 1; }
  constraint isolateport2 { port == 2; }
  constraint isolateport3 { port == 3; }
  constraint isolateport4 { port == 4; }

// Testing Individual Commands
  constraint isolateAdd { cmd == 1} //Add
  constraint isolateSub { cmd == 2} //Sub
  constraint isolateLSL { cmd == 5} //Shift Right
  constraint isolateLSR { cmd == 6} //Shift Left


  //Copy Constructor
  function apb_trans copy(); 
      apb_trans to   = new();
      to.cmd        = this.cmd;
      to.data        = this.data;
      to.data2 	  = this.data2
      to.tag = this.tag;
      to.port = this.port;
      copy = to;
  endfunction: copy
    
endclass

`endif


