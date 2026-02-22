module priority_enc (
    input clk,
    input rst,
    input [3:0] D,
    output reg [1:0] Y,
    output reg valid
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Y <= 2'b00;   // Reset output Y
        valid <= 1'b0; // Reset valid signal
    end else begin
        // Priority encoding
        casex (D)
            4'b1xxx: Y <= 2'b00; // Highest priority
            4'b01xx: Y <= 2'b01;
            4'b001x: Y <= 2'b10;
            4'b0001: Y <= 2'b11;
            default: Y <= 2'b00; // No valid input
        endcase
        valid <= (|D) ? 1'b1 : 1'b0; // Set valid based on non-zero D
    end
end

endmodule