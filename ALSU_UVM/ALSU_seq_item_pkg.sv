package ALSU_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    typedef enum {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    typedef enum {MAXPOS=3, ZERO=0, MAXNEG=-4, MINPOS=1} limits;

    class ALSU_seq_item extends uvm_sequence_item;

        rand bit cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand logic [2:0] opcode;
        rand logic signed [2:0] A, B;

        logic invalid_opcode, invalid_red, invalid;

        `uvm_object_utils_begin(ALSU_seq_item)
            `uvm_field_int(cin, UVM_ALL_ON)
            `uvm_field_int(red_op_A, UVM_ALL_ON)
            `uvm_field_int(red_op_B, UVM_ALL_ON)
            `uvm_field_int(bypass_A, UVM_ALL_ON)
            `uvm_field_int(bypass_B, UVM_ALL_ON)
            `uvm_field_int(direction, UVM_ALL_ON)
            `uvm_field_int(serial_in, UVM_ALL_ON)
            `uvm_field_int(opcode, UVM_ALL_ON)
            `uvm_field_int(A, UVM_ALL_ON)
            `uvm_field_int(B, UVM_ALL_ON)
        `uvm_object_utils_end

        function new(string name="ALSU_seq_item");
            super.new(name);
        endfunction

        function void post_randomize();
            invalid_opcode = (opcode > 5);
            invalid_red = (red_op_A && red_op_B) && (opcode > 2);
            invalid = invalid_opcode || invalid_red;
        endfunction

        // ALSU_3
        constraint ADD_MULT {
            if(opcode==ADD || opcode==MULT) {
                A dist { MAXPOS:=30, ZERO:=30, MAXNEG:=30, [-3:-1]:=10, [1:3]:=10 };
                B dist { MAXPOS:=30, ZERO:=30, MAXNEG:=30, [-3:-1]:=10, [1:3]:=10 };
            }
        }

        // ALSU_2
        constraint OR_XOR {
            if( (opcode==OR || opcode==XOR) && red_op_A ) {
                A dist { 2:=90, -4:=90, [-3:0]:=10, 3:=30 };
                B==ZERO;
            }

            if( (opcode==OR || opcode==XOR) && red_op_B ) {
                B dist { 2:=90, -4:=90, [-3:0]:=10, 3:=30 };
                A==ZERO;
            }
        }

        // ALSU_3
        constraint Opcode_Invalid_Cases {
            opcode dist { [0:5]:=90 , [6:7]:=10 };
        }

        // ALSU_4
        constraint Bypass_A_B {
            bypass_B dist {ZERO:=80, 1:=20};
            bypass_A dist {ZERO:=80, 1:=20};
        }

    endclass : ALSU_seq_item
endpackage : ALSU_seq_item_pkg