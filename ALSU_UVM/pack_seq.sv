package pack_seq;
`include "uvm_macros.svh"
import uvm_pkg::*;
import pack_seq_item::*;

class shift_reg_reset_sequence extends uvm_sequence #(shift_reg_seq_item);
    `uvm_object_utils(shift_reg_reset_sequence);
    shift_reg_seq_item seq_item;
    function new(string name = "shift_reg_reset_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = shift_reg_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.reset = 1;
        seq_item.serial_in = 0;
        seq_item.red_op_B = 0;
        seq_item.red_op_A = 0;
        seq_item.bypass_B = 0;
        seq_item.bypass_A = 0;
        seq_item.direction = 0;
        seq_item.cin = 0;
        seq_item.B = 0;
        seq_item.A = 0;
        seq_item.opcode = 0;
        finish_item(seq_item);
    endtask
endclass

class shift_reg_main_sequence extends uvm_sequence #(shift_reg_seq_item);
    `uvm_object_utils(shift_reg_main_sequence);
    shift_reg_seq_item seq_item;
    function new(string name = "shift_reg_main_sequence");
        super.new(name);
    endfunction

    task body();
        repeat(1000) begin
            seq_item = shift_reg_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            assert (seq_item.randomize());
            finish_item(seq_item);
        end
    endtask
endclass

class direct_test_sequence extends uvm_sequence #(shift_reg_seq_item);
    `uvm_object_utils(direct_test_sequence);
    shift_reg_seq_item seq_item;
    function new(string name = "direct_test_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = shift_reg_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.A = 5'b0;
        seq_item.B = 5'b0;

        seq_item.opcode = 3'b000;
        #2;
        seq_item.opcode = 3'b001;
        #2;
        seq_item.opcode = 3'b010;
        #2;
        seq_item.opcode = 3'b011;
        #2;
        seq_item.opcode = 3'b100;
        #2;
        seq_item.opcode = 3'b101;

        finish_item(seq_item);
    endtask
endclass

endpackage