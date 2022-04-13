`include "env.sv"


program automatic test(calc_if hif);


env env;

initial begin

  // Direct Test#1
  $display("\n ***** START OF DIRECT TESTS \n");
  env = new(hif);
  env.gen.my_tr.constraint_mode(1);
  env.run();
  $display("\n ***** END OF DIRECTED TEST ***** \n");


  $finish;
end 

endprogram

