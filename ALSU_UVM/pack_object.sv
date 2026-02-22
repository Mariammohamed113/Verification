package pack_object;
`include "uvm_macros.svh"
import uvm_pkg::*;

class object extends uvm_object;
    `uvm_object_utils(object);
    virtual ALSU_if alsu_config_vif;
    uvm_active_passive_enum sel_mod;

    function new (string name = "object");
        super.new(name);
    endfunction
endclass

endpackage