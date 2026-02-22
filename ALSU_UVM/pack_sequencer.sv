package pack_sequencer;
import pack_seq_item::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class MYSequencer extends uvm_sequencer #(shift_reg_seq_item);
    `uvm_component_utils(MYSequencer);
    function new(string name = "MYSequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass
endpackage