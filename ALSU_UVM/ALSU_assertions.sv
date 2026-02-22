module ALSU_assertions (
    input logic signed [2:0] A, B,
    input logic clk, rst, cin, serial_in, red_op_A, red_op_B,
    input logic [2:0] opcode,
    input logic bypass_A, bypass_B, direction,
    input logic [15:0] leds,
    input logic signed [5:0] out
);

logic invalid;
assign invalid = (opcode == 7 || opcode == 6 || ((opcode != 1 && opcode != 0) && (red_op_B || red_op_A)));

// Reset check
always_comb if (rst) assert final(out == 0 && leds == 0);

// Combined properties for operations
property check_operations;
    @(posedge clk) disable iff (rst)
    ((invalid || bypass_A || bypass_B || red_op_A || red_op_B || opcode == 0 || opcode == 1) |-> 
        (   (bypass_A) ? out == A :
            (bypass_B) ? out == B :
            (red_op_A) ? out == (|A) :
            (red_op_B) ? out == (|B) :
            opcode == 0 ? out == (A & B) :
            opcode == 1 ? out == (A | B) :
            opcode == 2 ? out[2:0] == ($past(A,2) ^ $past(B,2) ^ $past(cin,2)) :
            opcode == 3 ? out == A + B :
            opcode == 4 ? out == (direction ? { $past(out[4:0]) , serial_in } : { serial_in , $past(out[5:1]) }) :
            opcode == 5 ? out == (serial_in , $past(out[4:0])) : 
            0
        )
    );
endproperty

// Assertions and coverage for operations
assert_operations_ap: assert property(check_operations);
cover_operations_cp: cover property(check_operations);

// Invalid opcode check
property invalid_opcode;
    @(posedge clk) disable iff (rst) (opcode == 6 || opcode == 7) |-> ##2 (out == 0 && leds == $past(leds));
endproperty

// Assertion and coverage for invalid opcode
assert_invalid_ap: assert property(invalid_opcode);
cover_invalid_cp: cover property(invalid_opcode);

endmodule