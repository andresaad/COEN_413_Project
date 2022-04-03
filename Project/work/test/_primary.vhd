library verilog;
use verilog.vl_types.all;
entity test is
    generic(
        APB_ADDR_WIDTH  : integer := 16;
        APB_DATA_WIDTH  : integer := 32
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of APB_ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of APB_DATA_WIDTH : constant is 1;
end test;
