// COEN413 - WINTER 2022
// CONCORDIA UNIVERSITY

`ifndef CALC_REQUEST_DEFINE
`define CALC_REQUEST_DEFINE

// TRANSACTION OBJECT
class calc_request;

    // Each transaction will contain a command, Data 1 and Dats 2
    // The 'rand' keywoard is used to randomize the bits
    rand bit [3:0] cmd;    // 4-bit
    rand bit [31:0] data;  // 32-bit
    rand bit [31:0] data2; // 32-bit

      static int count=0;
      bit [1:0] tag;
      int id, trans_cnt;

      function new;
      id = count++;
      tag = id;
      endfunction
 
    // Constraints for Direct Testsing
    constraint addOnly { cmd == 001;} // Tests only addition for a given amount of tests
    constraint easyAdd { data2 == 1;} // Makes data2 = 1 for a given amount of tests


  // COPY CONSTRUCTOR
  function calc_request copy();
    calc_request to   = new();
    to.cmd        = this.cmd;
    to.data        = this.data;
    to.data2        = this.data2;
    copy = to;
  endfunction: copy
    
endclass

`endif


