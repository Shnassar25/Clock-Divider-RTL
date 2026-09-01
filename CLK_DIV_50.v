//Shahd Mahmoud
//Clk Divider Block with 50%
module Clk_div_50 #(
    parameter Div_Ratio = 8
)(
    input  wire                 i_ref_clk,
    input  wire                 i_rst_n,
    input  wire                 i_clk_en,
    input  wire [Div_Ratio-1:0] i_div_ratio,

    output wire                 o_div_clk
);
// Internal Signals
    reg  [Div_Ratio-1:0] counter;
    reg                  q1; // Pos-edge D-FF
    reg                  q2; // Neg-edge D-FF
    wire                 d1;
    wire                 Odd;
    wire                 ClK_DIV_EN;


assign Odd = i_div_ratio[0];
assign ClK_DIV_EN = i_clk_en && (i_div_ratio > 1'b1);

// 2. D-FF Input Data Logic
assign d1 = (counter < (i_div_ratio >> 1));

// 1. Counter Logic
always @(posedge i_ref_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            counter <= {Div_Ratio{1'b0}};
        end else if (ClK_DIV_EN) begin
            if (counter >= i_div_ratio - 1'b1)
                counter <= {Div_Ratio{1'b0}};
            else
                counter <= counter + 1'b1;
        end else begin
            counter <= {Div_Ratio{1'b0}};
        end
    end

// 3. Positive Edge D Flip-Flop (q1)
    always @(posedge i_ref_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            q1 <= 1'b0;
        end else if (ClK_DIV_EN) begin
            q1 <= d1;
        end
    end

   // Negative Edge D Flip-Flop (q2) 
    always @(negedge i_ref_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            q2 <= 1'b0;
        end else if (ClK_DIV_EN) begin
            q2 <= q1;
        end
    end

    // Output Selection: Odd uses OR logic for 50%, Even uses q1 directly
    assign o_div_clk = (!ClK_DIV_EN ) ? i_ref_clk : 
                       (Odd ? (q1 | q2) : q1);
    endmodule