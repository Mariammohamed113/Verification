module dff(clk, rst, d, q, en);
parameter USE_EN = 1'b1;
input clk, rst, d, en;
output reg q;

always @(posedge clk) begin
    if (rst)
        q <= 0;
    else if (USE_EN == 1'b1 && en)
        q <= d;
    else if (USE_EN == 1'b0)
        q <= d;
end

endmodule