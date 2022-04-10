
`include "env/env.sv"

program automatic test(apb_if aif);

// Top level environment
env env;

initial begin
  

// Simple Test
$display(" Begining Simple Test...")
env = new (aif);
env.gen.rand_tr.constraint_mode(0); // Disable Constraints
env.gen.max_trans_cnt = 20;
env.run();

end

endprogram


