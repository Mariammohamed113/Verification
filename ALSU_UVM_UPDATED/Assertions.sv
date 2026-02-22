module Assertions(ALSU_if alif);
import enums::*;

assign Invalid=(((alif.opcode==3'b110 || alif.opcode==3'b111) || (alif.opcode>3'b101))) || ((alif.red_op_A ||alif.red_op_B));

always_ff@(posedge alif.clk or posedge alif.reset) begin
    reset_check_cover: cover(alif.reset && alif.leds==0);
end

property leds;
    @(posedge alif.clk) disable iff(alif.reset)
    ((Invalid) |=> ##1 alif.leds == ~( $past(alif.leds )) );
endproperty

property reset_out;
    @(posedge alif.clk) disable iff(alif.reset)
    (alif.reset |=> alif.out == 0);
endproperty

property cin(ch);
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.cin == ch) |=> alif.cin == $past(alif.cin,2) );
endproperty

property bypass_A;
    @(posedge alif.clk) disable iff(alif.reset)
    (alif.bypass_A |=> alif.out == $past(alif.A,2) );
endproperty

property bypass_B;
    @(posedge alif.clk) disable iff(alif.reset)
    (alif.bypass_B |=> alif.out == $past(alif.B,2) );
endproperty

property OR_Redop_A;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.opcode==OR && alif.red_op_A) |=> alif.out == $past(alif.A,2) );
endproperty

property OR_Redop_B;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.opcode==OR && alif.red_op_B) |=> alif.out == $past(alif.B,2));
endproperty

property OR_check;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.opcode==OR && !Invalid && !alif.red_op_A && !alif.red_op_B && !alif.bypass_A && !alif.bypass_B) |=> alif.out == $past(alif.A | alif.B,2) );
endproperty

property XOR_Redop_A;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.opcode==XOR && alif.red_op_A) |=> alif.out == $past(alif.A,2) );
endproperty

property XOR_Redop_B;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.opcode==XOR && alif.red_op_B) |=> alif.out == $past(alif.B,2) );
endproperty

property XOR_check;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.opcode==XOR && !Invalid && !alif.red_op_A && !alif.red_op_B && !alif.bypass_A && !alif.bypass_B) |=> alif.out == $past(alif.A ^ alif.B,2) );
endproperty

property ADD_Redop_A;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.opcode==ADD && alif.red_op_A) |=> alif.out == $past(alif.A,2) );
endproperty

property ADD_Redop_B;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.opcode==ADD && alif.red_op_B) |=> alif.out == $past(alif.B,2) );
endproperty

property ADD_check;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.opcode==ADD && !Invalid && !alif.red_op_A && !alif.red_op_B && !alif.bypass_A && !alif.bypass_B) |=> alif.out == $past(alif.A + alif.B,2) );
endproperty

property MULT_check;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.opcode==MULT && alif.FULL_ADDER == "ON") |=> alif.out == $past(alif.A * alif.B,2) );
endproperty

property shift_right;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.bypass_A && !alif.bypass_B && !Invalid && alif.opcode==SHIFT && alif.direction==0) |=> ##1
      (alif.out == {$past(alif.serial_in,2), $past(alif.out[5:1])} ) );
endproperty

property shift_left;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.bypass_A && !alif.bypass_B && !Invalid && alif.opcode==SHIFT && alif.direction==1) |=> ##1
      (alif.out == {$past(alif.out[4:0]), $past(alif.serial_in,2)} ) );
endproperty

property rotate_right;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.bypass_A && alif.bypass_B && !Invalid && alif.opcode==ROTATE && alif.direction==0) |=> ##1
      (alif.out == {$past(alif.out[0]), $past(alif.out[5:1])} ) );
endproperty

property rotate_left;
    @(posedge alif.clk) disable iff(alif.reset)
    ((alif.bypass_A && alif.bypass_B && !Invalid && alif.opcode==ROTATE && alif.direction==1) |=> ##1
      (alif.out == {$past(alif.out[4:0]), $past(alif.out[5])} ) );
endproperty

// Assertions
leds_check:assert property(leds);
bypassA_check:assert property(bypassA);
bypassB_check:assert property(bypassB);
INVALID_check:assert property(INVALID_ch);
OR_A:assert property(OR_Redop_A);
OR_B:assert property(OR_Redop_B);
OR_C:assert property(OR_check);

XOR_A:assert property(XOR_Redop_A);
XOR_B:assert property(XOR_Redop_B);
XOR_C:assert property(XOR_check);

ADD_A:assert property(ADD_Redop_A);
ADD_B:assert property(ADD_Redop_B);
ADD_C:assert property(ADD_check);

MULT_C:assert property(MULT_check);

shiftR_check:assert property(shift_right);
shiftL_check:assert property(shift_left);
rotateR_check:assert property(rotate_right);
rotateL_check:assert property(rotate_left);

// Coverage
leds_cover:cover property(leds);
bypassA_cover:cover property(bypassA);
bypassB_cover:cover property(bypassB);
INVALID_cover:cover property(INVALID_ch);

OR1_cover:cover property(OR_Redop_A);
OR2_cover:cover property(OR_Redop_B);
OR3_cover:cover property(OR_check);

XOR1_cover:cover property(XOR_Redop_A);
XOR2_cover:cover property(XOR_Redop_B);
XOR3_cover:cover property(XOR_check);

ADD1_cover:cover property(ADD_Redop_A);
ADD2_cover:cover property(ADD_Redop_B);
ADD3_cover:cover property(ADD_check);

MULT_cover:cover property(MULT_check);

shiftR_cover:cover property(shift_right);
shiftL_cover:cover property(shift_left);
rotateLeft_cover:cover property(rotate_left);
rotateRight_cover:cover property(rotate_right);

endmodule