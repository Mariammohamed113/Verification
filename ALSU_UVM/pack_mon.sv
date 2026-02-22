package pack_mon;
`include "uvm_macros.svh"
import uvm_pkg::*;
import pack_seq_item::*;

class MONITOR extends uvm_monitor;
    `uvm_component_utils(MONITOR)
    virtual ALSU_if sh_vif;
    shift_reg_seq_item rsp_seq_item;
    uvm_analysis_port #(shift_reg_seq_item) mon_ap;

    function new(string name = "monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap",this);
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        forever begin
            rsp_seq_item = shift_reg_seq_item::type_id::create("rsp_seq_item");
            @(negedge sh_vif.clk);

            rsp_seq_item.reset      = sh_vif.reset;
            rsp_seq_item.cin        = sh_vif.cin;
            rsp_seq_item.direction  = sh_vif.direction;
            rsp_seq_item.serial_in  = sh_vif.serial_in;
            rsp_seq_item.bypass_B   = sh_vif.bypass_B;
            rsp_seq_item.bypass_A   = sh_vif.bypass_A;
            rsp_seq_item.red_op_B   = sh_vif.red_op_B;
            rsp_seq_item.red_op_A   = sh_vif.red_op_A;
            rsp_seq_item.B          = sh_vif.B;
            rsp_seq_item.A          = sh_vif.A;
            rsp_seq_item.opcode     = sh_vif.opcode;

            rsp_seq_item.out        = sh_vif.out;
            rsp_seq_item.out_G      = sh_vif.out_G;
            rsp_seq_item.leds       = sh_vif.leds;
            rsp_seq_item.leds_G     = sh_vif.leds_G;

            mon_ap.write(rsp_seq_item);
            `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH);
        end
    endtask
endclass

endpackage