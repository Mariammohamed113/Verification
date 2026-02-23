package FIFO_coverage_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import FIFO_seq_item_pkg::*;
        class FIFO_coverage extends uvm_component;
            `uvm_component_utils(FIFO_coverage)
            uvm_analysis_export #(FIFO_seq_item) cov_export;
            uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
            FIFO_seq_item  cvg;
           covergroup cg;
			// Coverpoints
			wr_en_cp: coverpoint cvg.wr_en;
			rd_en_cp: coverpoint cvg.rd_en;
			wr_ack_cp: coverpoint cvg.wr_ack;
			overflow_cp: coverpoint cvg.overflow;
			underflow_cp: coverpoint cvg.underflow;
			full_cp: coverpoint cvg.full;
			almostfull_cp: coverpoint cvg.almostfull;
			empty_cp: coverpoint cvg.empty;
			almostempty_cp: coverpoint cvg.almostempty;
			// Crosses
			WRITE_READ_WR_ACK_CROSS: cross wr_en_cp, rd_en_cp, wr_ack_cp{
				ignore_bins WRITE0_READ1_WR_ACK1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{1} && binsof(wr_ack_cp)intersect{1};
				ignore_bins WRITE0_READ0_WR_ACK1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{0} && binsof(wr_ack_cp)intersect{1};
			}
			WRITE_READ_OVERFLOW_CROSS: cross wr_en_cp, rd_en_cp, overflow_cp{
				ignore_bins WRITE0_READ1_OVERFLOW1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{1} && binsof(overflow_cp)intersect{1};
				ignore_bins WRITE0_READ0_OVERFLOW1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{0} && binsof(overflow_cp)intersect{1};
			}
			WRITE_READ_UNDERFLOW_CROSS: cross wr_en_cp, rd_en_cp, underflow_cp {
				ignore_bins WRITE1_READ0_UNDERFLOW1 = binsof(wr_en_cp)intersect{1} && binsof(rd_en_cp)intersect{0} && binsof(underflow_cp)intersect{1};
				ignore_bins WRITE0_READ0_UNDERFLOW1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{0} && binsof(underflow_cp)intersect{1};
			}
			WRITE_READ_FULL_CROSS: cross wr_en_cp, rd_en_cp, full_cp {
				ignore_bins WRITE1_READ1_FULL1 = binsof(wr_en_cp)intersect{1} && binsof(rd_en_cp)intersect{1} && binsof(full_cp)intersect{1};
				ignore_bins WRITE0_READ1_FULL1 = binsof(wr_en_cp)intersect{0} && binsof(rd_en_cp)intersect{1} && binsof(full_cp)intersect{1};
			}
			WRITE_READ_EMPTY_CROSS: cross wr_en_cp, rd_en_cp, empty_cp;
			WRITE_READ_ALMOST_FULL_CROSS: cross wr_en_cp, rd_en_cp, almostfull_cp;
			WRITE_READ_ALMOST_EMPTY_CROSS: cross wr_en_cp, rd_en_cp, almostempty_cp;
		endgroup : cg
            function new(string name = "FIFO_coverage", uvm_component parent = null);
                super.new(name,parent);
                cg=new();
            endfunction
            function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                cov_export=new("cov_export",this);
                cov_fifo=new("cov_fifo",this);
            endfunction
            function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                cov_export.connect(cov_fifo.analysis_export);
            endfunction
            task run_phase(uvm_phase phase);
                super.run_phase(phase);
                forever begin
                    cov_fifo.get(cvg);
                    cg.sample();
                end
            endtask
        endclass
    endpackage