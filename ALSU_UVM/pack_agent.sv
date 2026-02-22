package pack_agent;
`include "uvm_macros.svh"
import uvm_pkg::*;
import pack_driver::*;
import pack_sequencer::*;
import pack_seq::*;
import pack_mon::*;
import pack_object::*;

class sh_agent extends uvm_agent;
    `uvm_component_utils(sh_agent);

    object alsu_config_obj_test;
    DRIVER alsu_dr;
    MYSequencer sqr;
    MONITOR mon;

    uvm_analysis_port #(shift_reg_seq_item) agt_ap;

    function new(string name = "sh_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(object)::get(this,"","CG0", alsu_config_obj_test)) begin
            `uvm_fatal("build_phase","DRIVER unable to get the virtual interface");
        end

        if (alsu_config_obj_test.sel_mod == UVM_ACTIVE) begin
            alsu_dr = DRIVER::type_id::create("alsu_dr",this);
            sqr = MYSequencer::type_id::create("sqr",this);
        end

        mon = MONITOR::type_id::create("mon",this);
        agt_ap = new("agt_ap",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (alsu_config_obj_test.sel_mod == UVM_ACTIVE) begin
            alsu_dr.seq_item_port.connect(sqr.seq_item_export);
            alsu_dr.sh_vif = alsu_config_obj_test.alsu_config_vif;
        end

        mon.sh_vif = alsu_config_obj_test.alsu_config_vif;
        mon.mon_ap.connect(agt_ap);
    endfunction

endclass
endpackage