package ALSU_driver_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_seq_item_pkg::*;
class ALSU_driver extends uvm_driver #(seq_item);
    `uvm_component_utils(ALSU_driver);
    virtual ALSU_if alsu_config_vif;
    seq_item item;
    function new(string name ="driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            item=seq_item::type_id::create("seq item");
            seq_item_port.get_next_item(item);
            alsu_config_vif.reset=item.reset;
            alsu_config_vif.A=item.A;
            alsu_config_vif.B=item.B;
            alsu_config_vif.cin=item.cin;
            alsu_config_vif.red_op_A=item.red_op_A;
            alsu_config_vif.red_op_B=item.red_op_B;
            alsu_config_vif.bypass_A=item.bypass_A;
            alsu_config_vif.bypass_B=item.bypass_B;
            alsu_config_vif.direction=item.direction;
            alsu_config_vif.serial_in=item.serial_in;
            alsu_config_vif.opcode=item.opcode;
            @(negedge alsu_config_vif.clk);
            seq_item_port.item_done ();
        end
    endtask
endclass //ALSU_if
endpackage