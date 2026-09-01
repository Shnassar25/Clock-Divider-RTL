//Shahd Mahmoud
//Clk Divider Block
module Clk_div #(
    parameter Div_Ratio = 8
)(
    input  wire                  i_ref_clk,
    input  wire                  i_rst_n,
    input  wire                  i_clk_en,
    input  wire [Div_Ratio-1:0]  i_div_ratio,

    output wire                  o_div_clk
);
//internal signals
wire [Div_Ratio-1:0] Half_Even;
wire [Div_Ratio-1:0] Half_Odd;
wire                 Odd;
wire                 ClK_DIV_EN;

reg                  o_reg_div_clk;
reg                  Flag;
reg  [Div_Ratio-1:0] counter;
  
// Internal Assignments
assign Half_Even  = i_div_ratio >> 1;
assign Half_Odd   = i_div_ratio - Half_Even ;

assign ClK_DIV_EN = i_clk_en && (i_div_ratio > 1'b1);
assign Odd        = i_div_ratio[0];

//Output
assign o_div_clk  = (!ClK_DIV_EN ) ? i_ref_clk : o_reg_div_clk;

always @(posedge i_ref_clk  or negedge i_rst_n) begin
    if(!i_rst_n) begin
        counter       <= {Div_Ratio{1'b0}};
        o_reg_div_clk <= 1'b0;
        Flag          <= 1'b1;
    end
    else if(ClK_DIV_EN) begin
        // Even Div_Ratio
        if((counter == Half_Even -1) && !Odd ) begin
            o_reg_div_clk <= !o_reg_div_clk;
            counter       <= {Div_Ratio{1'b0}};
        end
        // Odd Div_Ratio
        else if(Odd && (((counter == Half_Even-1 )&& Flag)||((counter == Half_Odd-1)&& !Flag)))begin
             o_reg_div_clk <= !o_reg_div_clk;
             counter       <= {Div_Ratio{1'b0}};
             Flag          <= !Flag;
        end
    else begin
        counter <= counter+1'b1;
    end
end
    else begin
        counter       <= {Div_Ratio{1'b0}};
       // o_reg_div_clk <= i_ref_clk ;
        Flag          <= 1'b1;
    end
end


endmodule