package FIFO_scoreboard_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_seq_item_pkg::*;
class FIFO_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(FIFO_scoreboard)
    uvm_analysis_export #(FIFO_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
    FIFO_seq_item obj;
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    bit [FIFO_WIDTH-1:0] data_out_ref;      
    bit wr_ack_ref, overflow_ref;
    bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
    int counter; 
    int correct_count, error_count;      
    bit [FIFO_WIDTH-1:0] queue[$];   
    localparam max_fifo_addr = $clog2(FIFO_DEPTH); 
    function void check_data(input FIFO_seq_item obj);
        logic [6:0] flags_ref, flags_dut;
        reference_model(obj);
        flags_ref = {wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref};  
        flags_dut = {obj.wr_ack, obj.overflow, obj.full, obj.empty, obj.almostfull, obj.almostempty, obj.underflow};

        if ((obj.data_out == data_out_ref) && (flags_dut == flags_ref)) begin                                                                           
            $display("At time = %0t , The queue = %p", $time, queue);
            correct_count++;
        end else begin
            error_count++;
            $display("At time = %0t , the outputs of the DUT don't match with the Golden model outputs", $time);
        end
    endfunction
function void flags();     
        full_ref = (counter == FIFO_DEPTH) ? 1 : 0;     
        empty_ref = (counter == 0) ? 1 : 0;
        almostfull_ref = (counter == FIFO_DEPTH-1) ? 1 : 0;         
        almostempty_ref = (counter == 1) ? 1 : 0;
    endfunction 

    function void reference_model(FIFO_seq_item F_rm);
        fork
            begin  
                if (!F_rm.rst_n) begin
                    wr_ack_ref = 0;
                    full_ref = 0;
                    almostfull_ref = 0;
                    overflow_ref = 0;
                    counter = 0;
                    queue.delete();	
                end else if (F_rm.wr_en && counter < F_rm.FIFO_DEPTH) begin  
                    queue.push_back(F_rm.data_in);
                    wr_ack_ref = 1;
                end else begin 
                    wr_ack_ref = 0; 
                    if (full_ref && F_rm.wr_en)
                        overflow_ref = 1;
                    else
                        overflow_ref = 0;
                end
            end  
            begin  
                if (!F_rm.rst_n) begin
                    data_out_ref = 0;
                    empty_ref = 1;
                    almostempty_ref = 0;
                    underflow_ref = 0;
                end else if (F_rm.rd_en && counter != 0) begin   
                    data_out_ref = queue.pop_front();
                end else begin
                    if (empty_ref && F_rm.rd_en)
                        underflow_ref = 1;
                    else
                        underflow_ref = 0;
                end                
            end  
        join

        if (!F_rm.rst_n) begin
            counter = 0;
        end else if ({F_rm.wr_en, F_rm.rd_en} == 2'b10 && !full_ref) begin
            counter = counter + 1;
        end else if ({F_rm.wr_en, F_rm.rd_en} == 2'b01 && !empty_ref) begin
            counter = counter - 1;
        end else if ({F_rm.wr_en, F_rm.rd_en} == 2'b11 && full_ref) begin
            counter = counter - 1;
        end else if ({F_rm.wr_en, F_rm.rd_en} == 2'b11 && empty_ref) begin
            counter = counter + 1;
        end
        flags(); 
endfunction
function new(string name = "FIFO_scoreboard", uvm_component parent = null);
			super.new(name,parent);
		endfunction
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export=new("sb_export",this);
			sb_fifo=new("sb_fifo",this);
		endfunction
		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_fifo.get(obj);
				check_data(obj);
			end
		endtask
		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("At time %0t: Simulation Ends and Error Count= %0d, Correct Count= %0d", $time, error_count, correct_count), UVM_MEDIUM);
		endfunction
endclass
endpackage