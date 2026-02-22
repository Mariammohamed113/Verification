package ALSU_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import constraints::*;
    import random::*;
class ALSU_seq_item extends uvm_sequence_item;
    rand bit clk, reset, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    rand logic [2:0] opcode;
    rand logic signed [2:0] A, B;
    rand logic [15:0] leds;
    rand logic signed [5:0] out;
    bit [30:0] numbers;
    bit [30:0] found;
    int num_numbers, num_found;
    rand bit [15:0] found_bits;
    rand bit [15:0] num_bits;
    rand bit [15:0] num_valid;

    function new(string name ="seq_item");
        super.new(name);
    endfunction

    function string convert2string();
        $sformat(convert2string, "%0d cin=%0d red_op_A=%0d red_op_B=%0d bypass_A=%0d bypass_B=%0d direction=%0d serial_in=%0d",
                 clk, reset, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in);
        $sformat(convert2string, "%s opcode=%0d A=%0d B=%0d leds=%0d out=%0d",
                 convert2string, opcode, A, B, leds, out);
        return convert2string;
    endfunction

    constraint reset {
        (num_found inside {numbers}) ;
    }

    function string full_convert_string();
        $sformat(full_convert_string, "%s direction=%0d serial_in=%0d opcode=%0d A=%0d B=%0d out=%0d leds=%0d",
                 convert2string(), direction, serial_in, opcode, A, B, out, leds);
        return full_convert_string;
    endfunction

    constraint c1 {
        opcode != 7 && opcode != 6;
        red_op_A != (red_op_A && red_op_B);
        red_op_B != (red_op_A && red_op_B);
    }

    constraint c2 {
        A inside {[-4:3]};
        B inside {[-4:3]};
    }

    // Found list
    forever begin
        found dist {found_bits, num_bits};
        num_found dist {numbers, found_bits};
    end

endclass // ALSU_if
endpackage

// -------------------- lower part --------------------

```systemverilog
    if (opcode == ADD || opcode == MULT) {
        A dist {a_state:=80, rem_numbers:=20};
        B dist {a_state:=80, rem_numbers:=20};
    }

    if (opcode == OR || opcode == XOR) {
        if(red_op_A){
            A dist {found:=80, notfound:=20};
            B==3'b000;
        }
        else if (red_op_B){
            B dist {found:=80, notfound:=20};
            A==3'b000;
        }
    }

    opcode dist {[OR:ROTATE]:=80, [INVALID6:INVALID7]:=20};

    bypass_A dist {0:=90, 1:=10};
    bypass_B dist {0:=90, 1:=10};

    unique{arr};
    foreach(arr[i])
        arr[i] inside {[OR:ROTATE]};

endclass //ALSU_if
endpackage