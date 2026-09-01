library verilog;
use verilog.vl_types.all;
entity tb_Clk_div is
    generic(
        Div_Ratio_TB    : integer := 8;
        CLK_PERIOD      : integer := 10
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Div_Ratio_TB : constant is 1;
    attribute mti_svvh_generic_type of CLK_PERIOD : constant is 1;
end tb_Clk_div;
