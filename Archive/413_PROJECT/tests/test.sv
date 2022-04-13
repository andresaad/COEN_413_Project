`include "env.sv"


program automatic test(calc_if hif);


// Top level environment
env env;

initial begin

  // Random Test#1
  $display("\n ***** START: Random Test #1 ***** \n");
  env = new(hif);
  env.gen.my_tr.constraint_mode(0);
  env.gen.max_trans_cnt = 20;
  env.run();

  // Direct Test#1
  $display("\n ***** START: Direct Test #1 ***** \n");
  env.gen.my_tr.constraint_mode(0);
  env.gen.max_trans_cnt = 20;
  env.run();

  $finish;
end 

endprogram

