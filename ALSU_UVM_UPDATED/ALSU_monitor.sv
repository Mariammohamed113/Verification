package ALSU_monitor_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_seq_item_pkg::*;

class ALSU_monitor extends uvm_monitor;
    `uvm_component_utils(ALSU_monitor);
    virtual ALSU_if alsu_config_vif;
    seq_item item;
    uvm_analysis_port #(seq_item) mon_p;

    function new(string name ="",uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        mon_p=new("alsu monitor port",this);
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase (phase);
        forever begin
            item=seq_item::type_id::create("items recived");
            @(negedge alsu_config_vif.clk);
            item.reset=alsu_config_vif.reset;
            item.A=alsu_config_vif.A;
            item.B=alsu_config_vif.B;
            item.cin=alsu_config_vif.cin;
            item.red_op_A=alsu_config_vif.red_op_A;
            item.red_op_B=alsu_config_vif.red_op_B;
            item.bypass_A=alsu_config_vif.bypass_A;
            item.bypass_B=alsu_config_vif.bypass_B;
            item.direction=alsu_config_vif.direction;
            item.serial_in=alsu_config_vif.serial_in;
            item.opcode=alsu_config_vif.opcode;
            item.out=alsu_config_vif.out;
            item.leds=alsu_config_vif.leds;
            mon_p.write(item);
            `uvm_info("run_phase",item.convert2string(),UVM_HIGH);
        end
    endtask
endclass //ALSU_if
endpackage