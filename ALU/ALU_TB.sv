module ALU_TB(A, B, cin, serial_in, red_op_A, red_op_B, opcode, bypass_A, bypass_B, clk, rst, direction, leds, out, leds_expected, out_expected);

input clk, rst;
input red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
input signed [2:0] opcode;
input signed [7:0] A, B;
input cin;
output signed [7:0] out_expected;
output [15:0] leds_expected;

reg cin_reg;
reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg [2:0] opcode_reg;
reg signed [7:0] A_reg, B_reg;

wire invalid_red_op, invalid_opcode, invalid;

assign invalid_red_op = (red_op_A_reg | red_op_B_reg) & (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[1] | opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        cin_reg <= 0;
        red_op_A_reg <= 0;
        red_op_B_reg <= 0;
        bypass_A_reg <= 0;
        bypass_B_reg <= 0;
        direction_reg <= 0;
        serial_in_reg <= 0;
        opcode_reg <= 0;
        A_reg <= 0;
        B_reg <= 0;
    end
    else begin
        cin_reg <= cin;
        red_op_A_reg <= red_op_A;
        red_op_B_reg <= red_op_B;
        bypass_A_reg <= bypass_A;
        bypass_B_reg <= bypass_B;
        direction_reg <= direction;
        serial_in_reg <= serial_in;
        opcode_reg <= opcode;
        A_reg <= A;
        B_reg <= B;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)
        leds_expected <= 0;
    else begin
        if(invalid)
            leds_expected <= ~leds_expected;
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)
        out_expected <= 0;
    else begin
        if(invalid)
            out_expected <= 0;
        else begin
            if (bypass_A_reg && bypass_B_reg)
                out_expected <= A_reg ;
            else if (bypass_A_reg)
                out_expected <= A_reg ;
            else if (bypass_B_reg)
                out_expected <= B_reg ;
            else begin
                case (opcode)
                    3'h0: begin
                        if (red_op_A_reg && red_op_B_reg)
                            out_expected <= A_reg ;
                        else if (red_op_A_reg)
                            out_expected <= A_reg ;
                        else if (red_op_B_reg)
                            out_expected <= B_reg ;
                        else
                            out_expected <= A_reg & B_reg ;
                    end

                    3'h1: begin
                        if (red_op_A_reg && red_op_B_reg)
                            out_expected <= A_reg ;
                        else if (red_op_A_reg)
                            out_expected <= A_reg ;
                        else if (red_op_B_reg)
                            out_expected <= B_reg ;
                        else
                            out_expected <= A_reg | B_reg ;
                    end

                    3'h2: begin
                        if (red_op_A_reg && red_op_B_reg)
                            out_expected <= A_reg ;
                        else if (red_op_A_reg)
                            out_expected <= A_reg ;
                        else if (red_op_B_reg)
                            out_expected <= B_reg ;
                        else
                            out_expected <= A_reg ^ B_reg ;
                    end

                    3'h3: begin
                        out_expected <= A_reg & B_reg ;
                    end

                    3'h2: out_expected <= A_reg;
                    3'h2: out_expected <= A_reg + B_reg + cin_reg ;
                    3'h3: out_expected <= A_reg + B_reg ;

                    3'h4: begin
                        if (direction_reg)
                            out_expected <= {out_expected[4:0], serial_in_reg};
                        else
                            out_expected <= {serial_in_reg, out_expected[5:1]};
                    end

                    3'h5: begin
                        if (direction_reg)
                            out_expected <= {out_expected[4:0], out_expected[5]};
                        else
                            out_expected <= {out_expected[0], out_expected[5:1]};
                    end

                    default: out_expected <= 0 ;
                endcase
            end
        end
    end
end

endmodule
``