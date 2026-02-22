package pack_driver;
`include "uvm_macros.svh"
import uvm_pkg::*;
import pack_object::*;
import pack_sequencer::*;
import pack_seq::*;

class DRIVER extends uvm_driver #(shift_reg_seq_item);
    `uvm_component_utils(DRIVER);
    virtual ALSU_if sh_vif;
    shift_reg_seq_item stim_seq_item;

    function new(string name = "DRIVER", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase (phase);
        forever begin
            stim_seq_item = shift_reg_seq_item::type_id::create("stim_seq_item");
            seq_item_port.get_next_item(stim_seq_item);

            sh_vif.reset      = stim_seq_item.reset;
            sh_vif.direction  = stim_seq_item.direction;
            sh_vif.cin        = stim_seq_item.cin;
            sh_vif.serial_in  = stim_seq_item.serial_in;
            sh_vif.bypass_B   = stim_seq_item.bypass_B;
            sh_vif.bypass_A   = stim_seq_item.bypass_A;
            sh_vif.red_op_B   = stim_seq_item.red_op_B;
            sh_vif.red_op_A   = stim_seq_item.red_op_A;
            sh_vif.B          = stim_seq_item.B;
            sh_vif.A          = stim_seq_item.A;
            sh_vif.opcode     = stim_seq_item.opcode;

            @(negedge sh_vif.clk);

            stim_seq_item.out    = sh_vif.out;
            stim_seq_item.out_G  = sh_vif.out_G;
            stim_seq_item.leds   = sh_vif.leds;
            stim_seq_item.leds_G = sh_vif.leds_G;

            seq_item_port.item_done();
            `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH);
        end
    endtask
endclass

endpackage