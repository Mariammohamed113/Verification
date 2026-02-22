interface ALSU_if(clk);

input bit clk;

parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
Logic reset, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
Logic signed cin;
Logic [2:0] opcode;
Logic signed [2:0] A, B;
Logic [15:0] leds;
Logic signed[5:0] out;

endinterface