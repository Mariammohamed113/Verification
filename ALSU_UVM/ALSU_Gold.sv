module ALSU_Gold (ALSU_if.DUT_GOLD AL_if);
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";

reg cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
reg [2:0] opcode_reg;
reg signed [2:0] A_reg, B_reg;

always @(posedge AL_if.clk or posedge AL_if.reset) begin
    if(AL_if.reset) begin
        cin_reg = 0;
        red_op_A_reg = 0;
        red_op_B_reg = 0;
        bypass_A_reg = 0;
        bypass_B_reg = 0;
        direction_reg = 0;
        serial_in_reg = 0;
        opcode_reg = 0;
        A_reg = 0;
        B_reg = 0;
    end else begin
        cin_reg = AL_if.cin;
        red_op_A_reg = AL_if.red_op_A;
        red_op_B_reg = AL_if.red_op_B;
        bypass_A_reg = AL_if.bypass_A;
        bypass_B_reg = AL_if.bypass_B;
        direction_reg = AL_if.direction;
        serial_in_reg = AL_if.serial_in;
        opcode_reg = AL_if.opcode;
        A_reg = AL_if.A;
        B_reg = AL_if.B;
    end
end

always @(posedge AL_if.clk or posedge AL_if.reset) begin
    if(AL_if.reset) begin
        AL_if.out_G <= 6'h00;
        AL_if.leds_G <= 16'h0000;
    end
    else begin
        case (opcode_reg)
            3'h0: begin
                if(red_op_A_reg && red_op_B_reg)
                    AL_if.out_G <= (INPUT_PRIORITY=="A") ? A_reg : B_reg;
                else if(red_op_A_reg)
                    AL_if.out_G <= |A_reg;
                else if(red_op_B_reg)
                    AL_if.out_G <= |B_reg;
                else
                    AL_if.out_G <= A_reg & B_reg;
            end
            3'h1: begin
                if(red_op_A_reg && red_op_B_reg)
                    AL_if.out_G <= (INPUT_PRIORITY=="A") ? A_reg : B_reg;
                else if(red_op_A_reg)
                    AL_if.out_G <= ^A_reg;
                else if(red_op_B_reg)
                    AL_if.out_G <= ^B_reg;
                else
                    AL_if.out_G <= A_reg | B_reg;
            end
            3'h2: begin
                if(red_op_A_reg && red_op_B_reg)
                    AL_if.out_G <= (INPUT_PRIORITY=="A") ? A_reg : B_reg;
                else if(red_op_A_reg)
                    AL_if.out_G <= &A_reg;
                else if(red_op_B_reg)
                    AL_if.out_G <= &B_reg;
                else
                    AL_if.out_G <= A_reg ^ B_reg;
            end
        endcase
    end
end
        else if (bypass_A_reg) begin
            AL_if.out_G <= A_reg;
        end
    end
    else begin
        case (opcode_reg)
            3'h3: begin
                if(FULL_ADDER=="ON")
                    AL_if.out_G <= A_reg + B_reg + cin_reg;
                else
                    AL_if.out_G <= A_reg + B_reg;
            end

            3'h4: begin
                if(direction_reg)
                    AL_if.out_G <= {AL_if.out_G[4:0], serial_in_reg};
                else
                    AL_if.out_G <= {serial_in_reg, AL_if.out_G[5:1]};
            end

            3'h5: begin
                if(direction_reg)
                    AL_if.out_G <= {AL_if.out_G[4:0], AL_if.out_G[5]};
                else
                    AL_if.out_G <= {AL_if.out_G[0], AL_if.out_G[5:1]};
            end

            default: begin
                if (red_op_A_reg || red_op_B_reg) begin
                    if(red_op_A_reg && red_op_B_reg)
                        AL_if.out_G <= (INPUT_PRIORITY=="A") ? A_reg : B_reg;
                    else if(red_op_A_reg)
                        AL_if.out_G <= A_reg;
                    else
                        AL_if.out_G <= B_reg;
                end
                else if (bypass_A_reg && bypass_B_reg) begin
                    AL_if.out_G <= (INPUT_PRIORITY=="A") ? A_reg : B_reg;
                end
                else if (bypass_A_reg) begin
                    AL_if.out_G <= A_reg;
                end
                else if (bypass_B_reg) begin
                    AL_if.out_G <= B_reg;
                end
                else begin
                    AL_if.out_G <= A_reg & B_reg;
                end
            end
        endcase
    end
end

always @(posedge AL_if.clk or posedge AL_if.reset) begin
    if(AL_if.reset) begin
        AL_if.leds_G <= 16'd0;
    end
    else begin
        if(red_op_A_reg || red_op_B_reg) begin
            AL_if.leds_G <= 16'hA5A5;
        end
        else if(bypass_A_reg || bypass_B_reg) begin
            AL_if.leds_G <= 16'h5A5A;
        end
        else if(opcode_reg==3'h3) begin
            AL_if.leds_G <= 16'h0F0F;
        end
        else if(opcode_reg==3'h4 || opcode_reg==3'h5) begin
            AL_if.leds_G <= 16'hF0F0;
        end
        else begin
            AL_if.leds_G <= 16'hFFFF;
        end
    end
end

endmodule