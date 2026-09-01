//Shahd Mahmoud
//Testbench
`timescale 1ns / 1ps

module tb_Clk_div();

    // Parameters
    parameter Div_Ratio_TB = 8,
              CLK_PERIOD   = 10; // 100 MHz Clock

    // Testbench Signals
    reg                       tb_ref_clk;
    reg                       tb_rst_n;
    reg                       tb_clk_en;
    reg  [Div_Ratio_TB-1:0]   tb_div_ratio;

    wire                      tb_div_clk;

    // DUT Instantiation
    Clk_div_50 #(
        .Div_Ratio(Div_Ratio_TB)
    ) u_DUT (
        .i_ref_clk  (tb_ref_clk),
        .i_rst_n    (tb_rst_n),
        .i_clk_en   (tb_clk_en),
        .i_div_ratio(tb_div_ratio),
        .o_div_clk  (tb_div_clk)
    );

    // Clock Generation 
    always #(CLK_PERIOD/2) tb_ref_clk = ~tb_ref_clk;
    
    //Monitor Waveform Signals in Console
    initial begin
        $monitor("Time=%0t | rst_n=%b | clk_en=%b | div_ratio=%0d | o_div_clk=%b", 
                 $time, tb_rst_n, tb_clk_en, tb_div_ratio, tb_div_clk);
    end

    //////////////////////////////////////////////////////////
    //////////////////////// Tasks ///////////////////////////
    //////////////////////////////////////////////////////////
initial 
  begin
    intialization();

    // Test Even Division (Ratio = 2, 4, 8)
        CLK_DIVIDER('d2, 1'b1);
        CLK_DIVIDER('d4, 1'b1);
        CLK_DIVIDER('d8, 1'b1);

    // Test Odd Division (Ratio = 3, 5)
        CLK_DIVIDER('d3, 1'b1);
        CLK_DIVIDER('d5, 1'b1);
    
    // Test Bypass Mode (Ratio = 1)
        CLK_DIVIDER('d1, 1'b1);

    // Test Bypass Mode (Ratio = 0)
        CLK_DIVIDER('d0, 1'b1);

    // Test Clock Disable
        CLK_DIVIDER('d4, 1'b0);
    $finish;
  end

task intialization;
  begin
   // 1. Initialize Signals
        tb_ref_clk   = 1'b0;
        tb_rst_n     = 1'b0;
        tb_clk_en    = 1'b0;
        tb_div_ratio = 'b0;

        // Apply Reset
        #(CLK_PERIOD*2); 
        tb_rst_n = 1'b1; // Release reset

  end
endtask

task CLK_DIVIDER(
    input [Div_Ratio_TB-1:0] div_ratio,
    input clk_en
);
begin
    tb_div_ratio = div_ratio;
    tb_clk_en    = clk_en;
    #(CLK_PERIOD*40);
end
endtask


endmodule