library verilog;
use verilog.vl_types.all;
entity holdreg is
    port(
        hold_data1      : out    vl_logic_vector(0 to 31);
        hold_data2      : out    vl_logic_vector(0 to 31);
        hold_prio_req   : out    vl_logic_vector(0 to 3);
        hold_prio_tag   : out    vl_logic_vector(0 to 1);
        scan_out        : out    vl_logic;
        req_cmd_in      : in     vl_logic_vector(0 to 3);
        req_data_in     : in     vl_logic_vector(0 to 31);
        req_tag_in      : in     vl_logic_vector(0 to 1);
        reset           : in     vl_logic;
        scan_in         : in     vl_logic;
        a_clk           : in     vl_logic;
        b_clk           : in     vl_logic;
        c_clk           : in     vl_logic
    );
end holdreg;
