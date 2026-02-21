module TOP;

bit clk ;
initial begin
	clk = 0;
	forever begin
		#25;
		clk = ~clk;
	end 
end

FIFO_if if_obj(clk);

FIFO DUT (if_obj);

FIFO_tb TEST (if_obj);

FIFO_monitor MONITOR(if_obj);

endmodule
