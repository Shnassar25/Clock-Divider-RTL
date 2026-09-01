library verilog;
use verilog.vl_types.all;
entity odd_clk_divider is
    generic(
        N               : integer := 5;
        WIDTH           : vl_notype
    );
    port(
        clk_ref         : in     vl_logic;
        rst_n           : in     vl_logic;
        clk_en          : in     vl_logic;
        clk_out         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of WIDTH : constant is 3;
end odd_clk_divider;
