package ALSU_coverage;
`include "uvm_macros.svh"
import uvm_pkg::*;
import pack_seq_item::*;
import pack_seq_item::*;

class coverage extends uvm_component;
    `uvm_component_utils(coverage)

    uvm_analysis_export #(shift_reg_seq_item) cov_export;
    uvm_analysis_fifo  #(shift_reg_seq_item) cov_fifo;
    shift_reg_seq_item cov_item;

    covergroup ALSU_cg @(posedge cov_item.clk);
        bin data_A_bins[] = {3'b000, 3'b001, 3'b010, 3'b011,
                             3'b100, 3'b101, 3'b110, 3'b111};
        bin data_B_bins[] = {3'b000, 3'b001, 3'b010, 3'b011,
                             3'b100, 3'b101, 3'b110, 3'b111};

        bin data_A_signed[] = {3'b000, 3'b001, 3'b010, 3'b011,
                               3'b100, 3'b101, 3'b110, 3'b111};
        bin data_B_signed[] = {3'b000, 3'b001, 3'b010, 3'b011,
                               3'b100, 3'b101, 3'b110, 3'b111};

        bins opcode_bins[] = {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7};

        bins cin_bins[] = {0, 1};
        bins red_A_bins[] = {0, 1};
        bins red_B_bins[] = {0, 1};
        bins bypass_A_bins[] = {0, 1};
        bins bypass_B_bins[] = {0, 1};
        bins direction_bins[] = {0, 1};
        bins serial_in_bins[] = {0, 1};

        bins invalid_bins[] = {[INVALID_6:INVALID_7]};
    endgroup

    covergroup ALSU_cross_cg @(posedge cov_item.clk);
        opcodeXdata_A   : cross cov_item.opcode, cov_item.A;
        opcodeXdata_B   : cross cov_item.opcode, cov_item.B;
        opcodeXred      : cross cov_item.opcode, cov_item.red_op_A, cov_item.red_op_B;
        opcodeXbypass   : cross cov_item.opcode, cov_item.bypass_A, cov_item.bypass_B;
        shift_cross     : cross cov_item.opcode, cov_item.direction;
    endgroup

    covergroup full_cross @(posedge cov_item.clk);
        ALL_cross: cross cov_item.opcode, cov_item.A, cov_item.B, cov_item.cin,
                          cov_item.red_op_A, cov_item.red_op_B, cov_item.bypass_A,
                          cov_item.bypass_B, cov_item.direction, cov_item.serial_in;
    endgroup

    function new(string name = "coverage", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export", this);
        cov_fifo   = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(cov_item);
            ALSU_cg.sample();
            ALSU_cross_cg.sample();
            full_cross.sample();
        end
    endtask

endclass

endpackage