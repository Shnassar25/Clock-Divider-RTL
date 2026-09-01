module odd_clk_divider #(
    parameter N = 5,                         // Must be an odd number
    parameter WIDTH = $clog2(N)             // Automatically calculates required counter bits
)(
    input  wire clk_ref,                     // Reference Clock
    input  wire rst_n,                       // Active-low Reset
    input  wire clk_en,                      // Clock Enable
    output wire clk_out                      // Output clock with 50% duty cycle
);

    // Internal Signals
    reg [WIDTH-1:0] count;
    reg q1, q2;

    // ==========================================
    // 1. Counter Always Block (Positive Edge)
    // ==========================================
    always @(posedge clk_ref or negedge rst_n) begin
        if (!rst_n) begin
            count <= {WIDTH{1'b0}};
        end else if (clk_en) begin
            if (count == N - 1)
                count <= {WIDTH{1'b0}};
            else
                count <= count + 1'b1;
        end
    end

    // ==========================================
    // 2. First FF (Positive Edge)
    // ==========================================
    always @(posedge clk_ref or negedge rst_n) begin
        if (!rst_n) begin
            q1 <= 1'b0;
        end else if (clk_en) begin
            if (count == (N - 1) / 2)
                q1 <= 1'b1;
            else if (count == N - 1)
                q1 <= 1'b0;
        end
    end

    // ==========================================
    // 3. Second FF (Negative Edge)
    // ==========================================
    always @(negedge clk_ref or negedge rst_n) begin
        if (!rst_n) begin
            q2 <= 1'b0;
        end else if (clk_en) begin
            if (count == (N - 1) / 2)
                q2 <= 1'b1;
            else if (count == N - 1)
                q2 <= 1'b0;
        end
    end

    // ==========================================
    // 4. Combining Outputs (OR Gate)
    // ==========================================
    assign clk_out = q1 | q2;

endmodule