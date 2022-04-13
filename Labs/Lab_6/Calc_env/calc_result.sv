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
`ifndef CALC_RESULT_DEFINE
`define CALC_RESULT_DEFINE

class calc_result;
    bit [1:0] out_Resp;
    bit [31:0] out_Data;
    bit [1:0] out_Tag;
    integer out_Port;
   

    // function new;
    // id = count++;
    // tag = id;
    // endfunction
    
  function calc_result copy();
    calc_result to   = new();
    to.out_Resp        = this.out_Resp;
    to.out_Data        = this.out_Data;
    to.out_Tag         = this.out_Tag;
    to.out_Port        = this.out_Port;
    copy = to;
  endfunction: copy
    
endclass

`endif


