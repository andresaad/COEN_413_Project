`ifndef	DEFS
`define DEFS

parameter CMD_WIDTH = 4;
parameter DATA_WIDTH = 32;
parameter TAG_WIDTH = 2;
typedef enum bit[CMD_WIDTH-1:0] {   NOOP,       // 0
                                    ADD,        // 1
                                    SUB,        // 2
                                    LSL = 5,    // 5
                                    LSR         // 6
                                } operation;

parameter RESP_WIDTH = 2;

parameter NUM_PORTS = 4;
parameter NUM_TAGS = 2**TAG_WIDTH;

typedef struct{
    logic [CMD_WIDTH-1:0]   cmd_in;
	logic [DATA_WIDTH-1:0]  data_in;
	logic [TAG_WIDTH-1:0] 	tag_in;
} input_port;


typedef struct{
    logic [DATA_WIDTH-1:0]  out_data;  
	logic [TAG_WIDTH-1:0] 	out_tag;
	logic [RESP_WIDTH-1:0]  out_resp;
} output_port;

`endif
