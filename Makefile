FILES =  tb_top.sv root.sv priority.v adder.v alu_input_stage.v alu_output_stage.v holdreg.v mux_out.v shifter.v scoreboard.sv apb_trans.sv apb_master.sv apb_if.sv apb_gen.sv apb_monitor.sv apb_result.sv env.sv testbench.sv 
TOPLEVEL = calc2_top

include Makefiles/non_DPI/Makefile_non_DPI