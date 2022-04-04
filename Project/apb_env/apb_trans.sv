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

`include "hdl/root.sv"

class apb_trans;
   
    rand bit [3:0] cmd;
    rand bit [31:0] data;
    rand bit [31:0] data2;
    static int count=0;
    bit [1:0] tag;
    int id, trans_cnt;

    function void display(string prefix);
        case (this.transaction)
          READ:
            $display($time, ": %s Read  CMD =0x%02X Data=0x%02X id=%0d",
                   prefix, addr, data, id);
          WRITE:
            $display($time, ": %s Write CMD =0x%02X Data=0x%02X id=%0d",
                   prefix, cmd, data, id);
          default:
            $display($time, ": %s Idle  --------------------------", prefix);
        endcase
  endfunction: display

  function new;
    id = count++;
    tag = id;
    endfunction

    
  function apb_trans copy();
    apb_trans to   = new();
    to.cmd        = this.cmd;
    to.data        = this.data;
    to.data2 	  = this.data2
    copy = to;
  endfunction: copy
    
endclass

`endif


