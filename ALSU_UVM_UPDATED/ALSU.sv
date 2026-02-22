module ALSU(Al_if, al_if,shift_reg_if sh_if);
    reg red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
    reg cin_reg;
    reg [2:0] opcode_reg;
    reg signed [2:0] A_reg, B_reg;
    reg signed [5:0] out_reg;
    logic invalid_opcode, invalid;
    reg shift_reg_if_out,sh_if_opcode;

assign invalid_opcode = (opcode == 7 || opcode == 6);
assign invalid = (opcode_reg[1] | opcode_reg[2]) | invalid_opcode;

always @(posedge al_if.clk or posedge al_if.reset) begin
    if(al_if.reset) begin
        cin_reg <= 0;
        red_op_A_reg <=0;
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
        cin_reg <= al_if.cin;
        red_op_A_reg <= al_if.red_op_A;
        red_op_B_reg <= al_if.red_op_B;
        bypass_A_reg <= al_if.bypass_A;
        bypass_B_reg <= al_if.bypass_B;
        direction_reg <= al_if.direction;
        serial_in_reg <= al_if.serial_in;
        opcode_reg <= al_if.opcode;
        A_reg <= al_if.A;
        B_reg <= al_if.B;
    end
end

always @(posedge sh_if.clk or posedge al_if.reset) begin
    if(al_if.reset) begin
        al_if.out <= 0;
        al_if.leds <= 0;
    end 
    else begin
        if(invalid)
            al_if.leds <= ~al_if.leds;
        else al_if.leds <= 0;
    end
end

always @(posedge al_if.clk or posedge al_if.reset) begin
    if(al_if.reset) begin
        al_if.out <= 0;
    end
    else begin
        case(opcode_reg)
            3'h0: begin // change the priority or invalid bits after bypass_reg
                if(red_op_A_reg && red_op_B_reg)
                    al_if.out <= (al_if.INPUT_PRIORITY == "A")? A_reg : B_reg;
                else if(red_op_A_reg)
                    al_if.out <= A_reg;
                else if(red_op_B_reg)
                    al_if.out <= B_reg;
                else 
                    al_if.out <= A_reg & B_reg;
            end

            3'h1: begin // change opcode 0 to not AND
                if(red_op_A_reg && red_op_B_reg)
                    al_if.out <= (al_if.INPUT_PRIORITY == "A")? A_reg : B_reg;
                else if(red_op_A_reg)
                    al_if.out <= A_reg;
                else if(red_op_B_reg)
                    al_if.out <= B_reg;
                else 
                    al_if.out <= A_reg | B_reg;
            end

            3'h2: begin // change opcode to map nor OR
                if(red_op_A_reg && red_op_B_reg)
                    al_if.out <= (al_if.INPUT_PRIORITY == "A")? A_reg : B_reg;
                else if(red_op_A_reg)
                    al_if.out <= A_reg;
                else if(red_op_B_reg)
                    al_if.out <= B_reg;
                else 
                    al_if.out <= A_reg ^ B_reg;
            end

            3'h3: begin // change the @and condition to check full adder if ON or OFF
                if(al_if.FULL_ADDER == "ON")
                    al_if.out <= A_reg + B_reg + cin_reg;
                else 
                    al_if.out <= A_reg + B_reg;
            end

            3'h4: begin //shift / rotate
                if(direction_reg)
                    al_if.out <= al_if.out_shift_reg;
                else 
                    al_if.out <= al_if.out_shift_reg;
            end

            3'h5: begin //rotate
                al_if.out <= al_if.out_shift_reg;
            end

        endcase
    end
end

endmodule