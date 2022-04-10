/***************************************************************************
 *
 * File:        $RCSfile: apb_if.sv,v $
 * Revision:    $Revision: 1.3 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Generic APB interface
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
*/



`ifndef APB_IF_DEFINE
`define APB_IF_DEFINE

`include "root.sv"

interface apb_if(input PClk);
  
  	logic [4-1:0] PCmd;
	logic [32-1:0] PData;
	logic [1:0] PTag;
	
	    //Input for DUT (4x4x4)
    	logic [4-1:0] req1_cmd_in;
    	logic [4-1:0] req2_cmd_in;
    	logic [4-11:0] req3_cmd_in;
    	logic [4-1:0] req4_cmd_in;

		logic [32-1:0]  req1_data_in;
		logic [32-1:0]  req2_data_in;
		logic [32-1:0]  req3_data_in;
		logic [32-1:0]  req4_data_in;

    	logic [1:0]  req1_tag_in;
    	logic [1:0]  req2_tag_in;
    	logic [1:0]  req3_tag_in;
    	logic [1:0]  req4_tag_in;

	    logic reset; // RESET

		//Output for DUT (2 BIT WIRES)
		wire [1:0]  out_resp1;
		wire [1:0]  out_resp2;
		wire [1:0]  out_resp3;
		wire [1:0]  out_resp4;

		//Output Data for DUT (2 BIT WIRES)
    	wire [32-1:0]  out_data1;
    	wire [32-1:0]  out_data2;
    	wire [32-1:0]  out_data3;
    	wire [32-1:0]  out_data4;   
    
		//Output Tag for DUT (2 BIT WIRES)
    	wire [1:0]  out_tag1;
    	wire [1:0]  out_tag2;
    	wire [1:0]  out_tag3;
    	wire [1:0]  out_tag4;


// Clocking Block
  always @ (posedge PClk) begin
	  // Assigning Variable names
        req1_cmd_in <= PCmd;
        req2_cmd_in <= PCmd;
        req3_cmd_in <= PCmd;
        req4_cmd_in <= PCmd;
    
        req1_data_in <= PData;
        req2_data_in <= PData;
        req3_data_in <= PData;
        req4_data_in <= PData;

        req1_tag_in <= PTag;
        req2_tag_in <= PTag;
        req3_tag_in <= PTag;
        req4_tag_in <= PTag;
    end

	// Master Clocking Block
	modport Master(input PClk, output PCmd, PData, PTag, reset);

	// Monitor Clocking Block
  	modport Monitor(input PClk, out_resp1, out_resp2, out_resp3, out_resp4,
                        out_data1, out_data2, out_data3, out_data4,
                        out_tag1, out_tag2, out_tag3, out_tag4
                        );
  
	// Slave Clocking Block
  	modport Slave(input   req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in,
                        req1_data_in, req2_data_in, req3_data_in, req4_data_in,
                        req1_tag_in, req2_tag_in, req3_tag_in, req4_tag_in,
                  output  out_resp1, out_resp2, out_resp3, out_resp4,
                        out_data1, out_data2, out_data3, out_data4,
                        out_tag1, out_tag2, out_tag3, out_tag4
                );
  

endinterface

`endif    


