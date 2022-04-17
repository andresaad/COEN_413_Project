// COEN413 - WINTER 2022
// CONCORDIA UNIVERSITY


`ifndef CALC2_IF_DEFINE
`define CALC2_IF_DEFINE

`include "root.sv"

interface calc2_if(input PClk);
    logic [CALC_CMD_WIDTH-1:0]  PCmd;
    logic [CALC_DATA_WIDTH-1:0]  PData;
    logic [1:0] PTag;

    logic Rst;

            // PORT 1
            logic [CALC_CMD_WIDTH-1:0] req1_cmd_in;
            logic [CALC_DATA_WIDTH-1:0]  req1_data_in;
            logic [1:0]  req1_tag_in;
            wire [1:0]  out_resp1;
            wire [CALC_DATA_WIDTH-1:0]  out_data1;
            wire [1:0]  out_tag1;


            // PORT 2
            logic [CALC_CMD_WIDTH-1:0] req2_cmd_in;
            logic [CALC_DATA_WIDTH-1:0]  req2_data_in;
            logic [1:0]  req2_tag_in;
            wire [1:0]  out_resp2;
            wire [CALC_DATA_WIDTH-1:0]  out_data2;
            wire [1:0]  out_tag2;


            // PORT 3
            logic [CALC_CMD_WIDTH-1:0] req3_cmd_in;
            logic [CALC_DATA_WIDTH-1:0]  req3_data_in;
            logic [1:0]  req3_tag_in;
            wire [1:0]  out_resp3;
            wire [CALC_DATA_WIDTH-1:0]  out_data3;
            wire [1:0]  out_tag3;

            // PORT 4
            logic [CALC_CMD_WIDTH-1:0] req4_cmd_in;
            logic [CALC_DATA_WIDTH-1:0]  req4_data_in;
            logic [1:0]  req4_tag_in;
            wire [1:0]  out_resp4;
            wire [CALC_DATA_WIDTH-1:0]  out_data4;   
            wire [1:0]  out_tag4;
   

    always @ (negedge PClk) begin
        
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

  

  // Master Modport for Clock input, Command, Data, Tag and Reset
  modport Master(input PClk, output PCmd, PData, PTag, Rst);


 // Slave Modport for Outputs
  modport Slave(input   req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in,
                        req1_data_in, req2_data_in, req3_data_in, req4_data_in,
                        req1_tag_in, req2_tag_in, req3_tag_in, req4_tag_in,
                output  out_resp1, out_resp2, out_resp3, out_resp4,
                        out_data1, out_data2, out_data3, out_data4,
                        out_tag1, out_tag2, out_tag3, out_tag4
                );
  

endinterface

`endif    


