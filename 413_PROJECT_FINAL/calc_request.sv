// COEN413 - WINTER 2022
// CONCORDIA UNIVERSITY
// U-G1

`ifndef CALC_REQUEST_DEFINE
`define CALC_REQUEST_DEFINE

typedef enum {defo, AL, AH, AO, SL, SH, SO, easyA, easyS, BC} mode_t;

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

    mode_t mode = defo;
 
    // Constraints for Addition Direct Testsing
    //constraint badCommand{ (mode==BC) -> cmd == 111;}
    //constraint addLow{ (mode==AL) -> cmd == 001; data == 0; data2 ==0;}
    //constraint addHigh{ (mode==AH) -> cmd == 001; data == 32'hFFFFFFFF; data2 ==32'hFFFFFFFF;}
    //constraint addOverflow{(mode==AO) -> cmd == 001; data == 32'hFFFFFFFFA; data2 ==32'hFFFFFFFFA;}

    // Constraints for Subraction Direct Testsing
    //constraint subLow{ (mode==SL) -> cmd == 010; data == 0; data2 ==0;}
    //constraint subHigh{ (mode==SH) -> cmd == 010; data == 32'hFFFFFFFF; data2 ==32'hFFFFFFFF;}
    //constraint subOverflow{(mode==SO) -> cmd == 010; data == 32'h00000000; data2 ==32'hFFFFFFFF;}


    constraint d{ (mode==defo) -> data <=10; data2 == 10;} 
    //constraint easyAdd { (mode==easyA) -> cmd == 001; data == 10; data2 ==10;} 


  // COPY CONSTRUCTOR
  function calc_request copy();
    calc_request to   = new();
    to.cmd        = this.cmd;
    to.data        = this.data;
    to.data2        = this.data2;
    to.mode = this.mode;
    copy = to;
  endfunction: copy
    
endclass

`endif


