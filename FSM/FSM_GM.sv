module FSM_GM(x, clk, rst, y_exp, count_exp);
parameter STORE = 2'b00;
parameter IDLE  = 2'b01;
parameter ZERO  = 2'b10;
parameter ONE   = 2'b11;
input x, clk, rst;
output reg y_exp;
output reg [9:0] count_exp;
reg [1:0] cs, ns;

// Next state logic
always @(cs or x) begin
    case (cs)
        STORE :
            if (x)
                ns = IDLE;
            else
                ns = IDLE;
        IDLE :
            if (x)
                ns = IDLE;
            else
                ns = ZERO;
        ZERO :
            if (x)
                ns = ONE;
            else
                ns = ZERO;
        ONE :
            if (x)
                ns = IDLE;
            else
                ns = ZERO;
        default : ns = STORE;
    endcase
end

// State Memory
always @(posedge clk or posedge rst) begin
    if (rst) begin
        cs <= IDLE;
        count_exp <= 10'b0;
    end else
        cs <= ns;
end

always @(cs) begin
    case (cs)
        STORE : begin
            y_exp = 1;
            count_exp = count_exp + 1;
        end
        IDLE, ZERO, ONE : y_exp = 0;
    endcase
end

endmodule