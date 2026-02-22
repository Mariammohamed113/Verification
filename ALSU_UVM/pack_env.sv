`include "uvm_macros.svh"
package pack_env;
import uvm_pkg::*;
import pack_agent::*;
import scoreboard::*;
import sh_coverage::*;
import pack_seq_item::*;

class alsu_env extends uvm_env;
    `uvm_component_utils(alsu_env);
    sh_agent agt;
    scoreboard sb;
    coverage cov;
    uvm_analysis_port #(shift_reg_seq_item) agt_ap;

    function new(string name = "als_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        agt = sh_agent::type_id::create("agt",this);
        sb = scoreboard::type_id::create("sb",this);
        cov = coverage::type_id::create("cov",this);
        agt_ap = new("agt_ap",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.agt_ap.connect(sb.sb_export);
        agt.agt_ap.connect(cov.cov_export);
    endfunction

endclass  // shift_env
endpackage