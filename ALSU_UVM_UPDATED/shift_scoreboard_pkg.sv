package shift_scoreboard_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_seq_item_pkg::*;

class shift_reg_sb extends uvm_scoreboard;
    `uvm_component_utils(shift_reg_sb);

    seq_item itm;
    logic [5:0] dataout_ref;
    int error_count, correct_count;

    uvm_analysis_export #(seq_item) sb_export;
    uvm_tlm_analysis_fifo #(seq_item) sb_fifo;

    function new(string name = "shift_reg_sb", uvm_component parent =null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export",this);
        sb_fifo   = new("sb_fifo",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(itm);
            reference_model(itm);
            if(itm.dataout != dataout_ref) begin
                `uvm_error("run_phase", $sformatf("Transaction recieved is %s and data_out ref = %s",
                         itm.convert2string(), dataout_ref))
                error_count++;
            end
            else correct_count++;
        end
    endtask

    task reference_model(seq_item items);
        if(items.mode) begin
            if(items.direction) // left
                dataout_ref = {items.datain[4:0], items.datain[5]};
            else
                dataout_ref = {items.datain[0], items.datain[5:1]};
        end
        else begin
            if(items.direction) // left
                dataout_ref = {items.datain[4:0], items.serial_in};
            else
                dataout_ref = {items.serial_in, items.datain[5:1]};
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("cases passed : %0d , failed cases= %0d", correct_count, error_count),UVM_MEDIUM)
    endfunction

endclass

endpackage