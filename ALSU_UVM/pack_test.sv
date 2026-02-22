package pack_test;
`include "uvm_macros.svh"
import uvm_pkg::*;
import pack_env::*;
import pack_object::*;
import pack_seq::*;
class test extends uvm_test;
    `uvm_component_utils(test)
    alsu_env env;
    object alsu_config_obj_test;
    shift_reg_main_sequence main_seq;
    shift_reg_reset_sequence reset_seq;
    direct_test_sequence direc_seq;
    function new (string name = "test", uvm_component parent = null);
        super. new(name, parent);
    endfunction
    function void build_phase (uvm_phase phase);
        super. build_phase(phase);
        env = alsu_env :: type_id :: create("env", this);
        alsu_config_obj_test = object :: type_id :: create("alsu_config_obj_test");
        main_seq = shift_reg_main_sequence :: type_id :: create("main_seq");
        reset_seq = shift_reg_reset_sequence :: type_id :: create("reset_seq");
        direc_seq = direct_test_sequence ::type_id :: create("direc_seq");
        if(!uvm_config_db #(virtual ALSU_if):: get(this, "*", "ALSU_if", alsu_config_obj_test. alsu_config_vif))begin
            `uvm_fatal("build_phase","the test unable to get the virtual interface");
        end
        alsu_config_obj_test. sel_mod = UVM_ACTIVE;
        uvm_config_db #(object) :: set (this,"*","CG0", alsu_config_obj_test);
    endfunction
    task run_phase (uvm_phase phase);
        super. run_phase (phase);
        phase. raise_objection( this);
        //reset sequence
        `uvm_info("run_phase","reset asserted",UVM_LOW);
        reset_seq.start( env.agt. sqr);
        `uvm_info("run_phase","reset deasserted",UVM_LOW);
        //main Sequence
        `uvm_info("run_phase","stimulus generated started",UVM_LOW);
        main_seq.start(env.agt. sqr);
        `uvm_info("run_phase","stimulus generated ended",UVM_LOW);
        //direct test sequence
        `uvm_info("run_phase","stimulus generated started",UVM_LOW);
        direc_seq .start(env. agt. sqr);
        `uvm_info("run_phase","stimulus generated ended",UVM_LOW);
        phase. drop_objection(this);
    endtask
endclass
endpackage