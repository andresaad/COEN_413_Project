
`ifndef APB_RESULT_DEFINE
`define APB_RESULT_DEFINE

class apb_result;
    bit [1:0] out_Resp;
    bit [31:0] out_Data;
    bit [1:0] out_Tag;
    integer out_Port;
   

    // function new;
    // id = count++;
    // tag = id;
    // endfunction
    
  function apb_result copy();
    apb_result to = new();
    to.out_Resp = this.out_Resp;
    to.out_Data = this.out_Data;
    to.out_Tag = this.out_Tag;
    to.out_Port = this.out_Port;
    copy = to;
  endfunction: copy
    
endclass

`endif