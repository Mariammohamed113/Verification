package test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_sequence_pkg::*;
import shift_sequence_pkg::*;
import shift_env_pkg::*;
import ALSU_env_pkg::*;
import config_object_pkg::*;

class ALSU_test extends uvm_test;
    `uvm_component_utils(ALSU_test);

    reset_sequence reset_seq;
    main_sequence main_seq;
    second_sequence snd_seq;

    ALSU_env env;
    shift_env sh_env;

    virtual ALSU_if ALSU_config_vif;
    virtual shift_reg_if shift_config_vif;

    ALSU_config ALSU_cfg;
    shift_config sh_cfg;

    function new(string name = "test", uvm_component parent=null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        reset_seq = reset_sequence::type_id::create("reset");
        main_seq  = main_sequence::type_id::create("main");
        snd_seq   = second_sequence::type_id::create("snd");

        ALSU_env  = ALSU_env::type_id::create("env");
        sh_env    = shift_env::type_id::create("sh_env");

        ALSU_cfg  = ALSU_config::type_id::create("ALSU_cfg");
        sh_cfg    = shift_config::type_id::create("sh_cfg");

        if(!uvm_config_db #(virtual ALSU_if)::get(this,"*","ALSU_if", ALSU_cfg.alsu_config_vif))
            `uvm_fatal("build_phase","unable to get ALSU virtual IF");

        if(!uvm_config_db #(virtual shift_reg_if)::get(this,"*","SHIFT_if", sh_cfg.shift_config_vif))
            `uvm_fatal("build_phase","unable to get shift virtual IF");

        ALSU_cfg.is_active = UVM_ACTIVE;
        sh_cfg.is_active   = UVM_PASSIVE;

        uvm_config_db #(ALSU_config)::set(this,"*.ALSU_cfg","ALSU_cfg",ALSU_cfg);
        uvm_config_db #(shift_config)::set(this,"*.SH_cfg","SHIFT_cfg",sh_cfg);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        `uvm_info("run_phase","reset sequence start",UVM_MEDIUM);
        reset_seq.start(env.agt.sqr);
        `uvm_info("run_phase","reset sequence end",UVM_MEDIUM);

        `uvm_info("run_phase","main sequence start",UVM_MEDIUM);
        main_seq.start(env.agt.sqr);
        `uvm_info("run_phase","main sequence end",UVM_MEDIUM);

        `uvm_info("run_phase","second sequence start",UVM_MEDIUM);
        snd_seq.start(env.agt.sqr);
        `uvm_info("run_phase","second sequence end",UVM_MEDIUM);

        phase.drop_objection(this);
    endtask

endclass //ALSU_if
endpackage