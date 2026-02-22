package shift_agent_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_monitor_pkg::*;
import shift_driver_pkg::*;
import shift_sequencer_pkg::*;
import shift_seq_item_pkg::*;
import config_object_pkg::*;

class shift_reg_agent extends uvm_agent;
    `uvm_component_utils(shift_reg_agent);
    shift_reg_monitor mon;
    shift_seq_item_sqr sqr;
    shift_reg_driver dr;
    uvm_analysis_port #(seq_item) agt_p;
    uvm_active_passive_enum is_active;
    function new(string name ="shift_reg_agent", uvm_component parent =null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon=shift_reg_monitor::type_id::create("monitor",this);
        agt_p=new("agent port",this);
        if(!uvm_config_db #(shift_config)::get(this,"","shift_cfg",cfg))
            `uvm_fatal("build_phase","cant get shift virtual interface");
        is_active=cfg.is_active;
        if(is_active==UVM_ACTIVE)begin
            sqr=shift_seq_item_sequencer::type_id::create("sequencer",this);
            dr=shift_reg_driver::type_id::create("driver",this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(is_active==UVM_ACTIVE)begin
            dr.alsu_config_vif=cfg.shift_config_vif;
            dr.seq_item_port.connect(sqr.seq_item_export);
        end
        mon.alsu_config_vif=cfg.shift_config_vif;
        mon.mon_p.connect(agt_p);
    endfunction

endclass
endpackage