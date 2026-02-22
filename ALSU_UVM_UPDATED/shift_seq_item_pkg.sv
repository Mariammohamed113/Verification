package shift_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class seq_item extends uvm_sequence_item;
    `uvm_object_utils(seq_item);

    function new(string name = "shift_reg_sequence_item");
        super.new(name);
    endfunction

    rand logic reset;
    rand logic serial_in, direction, mode;
    rand logic [5:0] dataIn;
    logic [5:0] dataout;

    function string convert2string();
        return $sformatf("\n reset=%0b serial_in=%0b direction=%0b mode=%0b datain=%0b ",
                         reset,serial_in,direction,mode,dataIn);
    endfunction

    function string convertstring_stimulus();
        return $sformatf("\n reset=%0b serial_in=%0b direction=%0b mode=%0b datain=%0b ",
                         reset,serial_in,direction,mode,dataIn);
    endfunction

    constraint c1 {
        reset dist {1:=5, 0:=15};
    }

endclass
endpackage