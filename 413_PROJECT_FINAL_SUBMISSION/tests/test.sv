`include "env.sv"


//typedef enum {defo, easyA, easyS} mode_t;

program automatic test(calc2_if hif);


env env;

initial begin

  // Direct Test#1
  $display("\n ***** START OF DIRECT TESTS \n");
  env = new(hif);
  env.tcount = 100;
  
  env.run();


  $display("\n ***** END OF DIRECTED TEST ***** \n");


  $finish;
end 

endprogram

