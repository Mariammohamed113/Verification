package pck;

typedef enum logic [1:0] {Add , Sub , Not_A , ReductionOR_B} opcode_e;

class M;
    rand bit signed [3:0] a , b;
    rand opcode_e opcode;
    rand bit rst;
    constraint c_rst {rst dist{0 :/ 90, 1 :/ 10};}
endclass

endpackage