package ALSU_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_seq_item_pkg::*;

class reset_sequence extends uvm_sequence #(seq_item);
    `uvm_object_utils(reset_sequence)
    function new(string name = "reset_sequence");
        super.new(name);
    endfunction
    task body();
        seq_item item;
        item=seq_item::type_id::create("sequence reset");
        start_item(item);
        item.reset=1;
        finish_item(item);
    endtask
endclass //ALSU_if

class main_sequence extends uvm_sequence #(seq_item);
    `uvm_object_utils(main_sequence);
    function new(string name = "main_sequence",uvm_component parent=null);
        super.new(name);
    endfunction
    task body();
        repeat(2000)begin
            seq_item item;
            item=seq_item::type_id::create("sequence");
            item.constraint_mode(0);
            item.constraint_mode(1);
            start_item(item);
            assert(item.randomize());
            finish_item(item);
        end
    endtask
endclass //ALSU_if

class second_sequence extends uvm_sequence #(seq_item);
    `uvm_object_utils(second_sequence);
    function new(string name = "second_sequence",uvm_component parent=null);
        super.new(name);
    endfunction
    task body();
        for (int i=1;i<500;i++)begin
            seq_item item;
            item=seq_item::type_id::create("sequence");
            item.constraint_mode(0);
            assert(item.randomize());
            if(item.bypass_A,item.bypass_A!=item.bypass_B; item.red_op_A,item.red_op_A!=item.red_op_B;
               item.serial_in,item.serial_in!=0; item.direction,item.direction!=0; item.red_op_A_rand_mode();
               item.red_op_A_rand_mode();)
            assert((i<100,AND,OR,XOR,NOR,SHIFT,Rotate) ==item.arr)$display("At the wanted sequence is %p",item.arr);
            item.opcode=item.arr[];
            start_item(item);
            finish_item(item);
        end
    endtask
endclass //ALSU_if
endpackage