import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_test_pkg::*;

module top;
	bit clk;
	initial begin
		clk=0;
		forever #1 clk=~clk;
	end
	FIFO_if fif(clk);
	FIFO dut(fif);
        
	bind FIFO FIFO_sva FIFO_sva_inst (fif, dut.count);

	initial begin
		uvm_config_db#(virtual FIFO_if)::set(null, "uvm_test_top", "FIFO_IF", fif);
		run_test("FIFO_test");
	end

endmodule