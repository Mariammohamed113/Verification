module ALSU(ALSU_IF.OUT AL_if);

parameter INPUT_PRIORITY="A"; 
parameter FULL_ADDER="ON";

logic cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
logic [2:0] opcode_reg;
logic signed [2:0] A_reg, B_reg;
logic invalid_red_op, invalid_opcode, invalid;

// Invalid reduction and invalid opcode
assign invalid_red_op = (red_op_A_reg & red_op_B_reg) | (opcode_reg[1] | opcode_reg[2]);
assign invalid_opcode = opcode_reg[0] & opcode_reg[2];
assign invalid = invalid_red_op | invalid_opcode;

// Registering inputs
always @(posedge AL_if.clk or posedge AL_if.reset) begin
    if(AL_if.reset) begin
        cin_reg <=0;
        red_op_A_reg <= 0;
        red_op_B_reg <=0;
        bypass_A_reg <=0;
        bypass_B_reg <=0;
        direction_reg <=0;
        serial_in_reg <=0;
        opcode_reg <=0;
        A_reg <=0;
        B_reg <=0;
    end
    else begin
        cin_reg <= AL_if.cin;
        red_op_A_reg <= AL_if.red_op_A;
        red_op_B_reg <= AL_if.red_op_B;
        bypass_A_reg <= AL_if.bypass_A;
        bypass_B_reg <= AL_if.bypass_B;
        direction_reg <= AL_if.direction;
        serial_in_reg <= AL_if.serial_in;
        opcode_reg <= AL_if.opcode;
        A_reg <= AL_if.A;
        B_reg <= AL_if.B;
    end
end

// LED logic
always @(posedge AL_if.clk or posedge AL_if.reset) begin
    if(AL_if.reset)
        AL_if.leds <=0;
    else begin
        if(invalid)
            AL_if.leds <= ~AL_if.leds;
    end
end

// ALU main logic
always @(posedge AL_if.clk or posedge AL_if.reset) begin
    if(AL_if.reset) begin
        AL_if.out <=0;
    end
    else begin
        if(invalid)
            AL_if.out <=0;
        else begin
            if (bypass_A_reg & bypass_B_reg)
                AL_if.out <= (INPUT_PRIORITY == "A") ? A_reg : B_reg;
            else if (bypass_A_reg)
                AL_if.out <= A_reg;
            else if (bypass_B_reg)
                AL_if.out <= B_reg;
            else begin
                case(opcode_reg)
                    3'h0: begin
                        if(red_op_A_reg & red_op_B_reg)
                            AL_if.out <= (INPUT_PRIORITY=="A") ? A_reg : B_reg;
                        else if(red_op_A_reg)
                            AL_if.out <= |A_reg;
                        else if(red_op_B_reg)
                            AL_if.out <= |B_reg;
                        else
                            AL_if.out <= A_reg & B_reg;
                    end

                    3'h1: begin
                        if(red_op_A_reg & red_op_B_reg)
                            AL_if.out <= (INPUT_PRIORITY=="A") ? A_reg : B_reg;
                        else if(red_op_A_reg)
                            AL_if.out <= ^A_reg;
                        else if(red_op_B_reg)
                            AL_if.out <= ^B_reg;
                        else
                            AL_if.out <= A_reg | B_reg;
                    end

                    3'h2: begin
                        if(red_op_A_reg & red_op_B_reg)
                            AL_if.out <= (INPUT_PRIORITY=="A") ? A_reg : B_reg;
                        else if(red_op_A_reg)
                            AL_if.out <= &A_reg;
                        else if(red_op_B_reg)
                            AL_if.out <= &B_reg;
                        else
                            AL_if.out <= A_reg ^ B_reg;
                    end

                    3'h3: begin
                        if(FULL_ADDER=="ON")
                            AL_if.out <= A_reg + B_reg + cin_reg;
                        else
                            AL_if.out <= A_reg + B_reg;
                    end

                    3'h4: begin
                        if(direction_reg)
                            AL_if.out <= {AL_if.out[4:0], serial_in_reg};
                        else
                            AL_if.out <= {serial_in_reg, AL_if.out[5:1]};
                    end

                    3'h5: begin
                        if(direction_reg)
                            AL_if.out <= {AL_if.out[4:0], AL_if.out[5]};
                        else
                            AL_if.out <= {AL_if.out[0], AL_if.out[5:1]};
                    end

                    default: AL_if.out <=0;
                endcase
            end
        end
    end
end

endmodule