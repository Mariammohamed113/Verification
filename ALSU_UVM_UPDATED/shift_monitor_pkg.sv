package shift_monitor_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_seq_item_pkg::*;

class shift_reg_monitor extends uvm_monitor;
    `uvm_component_utils(shift_reg_monitor);
    virtual shift_reg_if alsu_config_vif;
    seq_item itm;
    uvm_analysis_port #(seq_item) mon_p;

    function new(string name = "shift_reg_monitor", uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        mon_p=new("shift monitor port",this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            itm=seq_item::type_id::create("items recived");
            @(negedge alsu_config_vif.clk);
            itm.serial_in=alsu_config_vif.serial_in;
            itm.mode=alsu_config_vif.mode;
            itm.dataIn=alsu_config_vif.dataIn;
            mon_p.write(itm);
            `uvm_info("run_phase", itm.convert2string(), UVM_HIGH);
        end
    endtask
endclass
endpackage