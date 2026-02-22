`include "uvm_macros.svh"
package scoreboard;
import uvm_pkg::*;
import pack_seq_item::*;

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uvm_analysis_export #(shift_reg_seq_item) sb_export;
    uvm_analysis_fifo  #(shift_reg_seq_item) sb_fifo;
    shift_reg_seq_item seq_item_sb;
    int error_count = 0;
    int correct_count = 0;

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
        sb_fifo   = new("sb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_sb);
            if (seq_item_sb.out != seq_item_sb.out_G) begin
                `uvm_error("run_phase", $sformatf("comparison failed, transaction received by the DUT: %s", seq_item_sb.convert2string()))
                error_count++;
            end
            else begin
                `uvm_info("run_phase", $sformatf("correct output: %s", seq_item_sb.convert2string()), UVM_LOW)
                correct_count++;
            end
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase", $sformatf("Total successful counts: %0d", correct_count), UVM_MEDIUM)
        `uvm_info("report_phase", $sformatf("Total failed counts: %0d", error_count), UVM_MEDIUM)
    endfunction

endclass

endpackage
