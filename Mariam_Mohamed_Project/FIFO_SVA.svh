module FIFO_sva(FIFO_if.DUT fif, input [fif.max_fifo_addr:0] count);
always_comb begin 
		if(!fif.rst_n)
		reset_1_assertion: assert final ((!fif.wr_ack)&&(!fif.overflow)&&(!fif.underflow)&&(!count));
		reset_1_cover: cover final ((!fif.wr_ack)&&(!fif.overflow)&&(!fif.underflow)&&(!count));
	end
	always_comb begin 
		if((fif.rst_n)&&(count == fif.FIFO_DEPTH))
		full_assertion: assert final (fif.full);
		full_cover: cover (fif.full);
	end
	always_comb begin 
		if((fif.rst_n)&&(count == 0))
		empty_assertion: assert final (fif.empty);
		empty_cover: cover (fif.empty);
	end
	always_comb begin 
		if((fif.rst_n)&&(count == fif.FIFO_DEPTH-1))
		almostfull_assertion: assert final (fif.almostfull);
		almostfull_cover: cover (fif.almostfull);
	end
	always_comb begin 
		if((fif.rst_n)&&(count == 1))
		almostempty_assertion: assert final (fif.almostempty);
		almostempty_cover: cover (fif.almostempty);
	end
property P0;
		@(posedge fif.clk or negedge fif.rst_n) 
		(!fif.rst_n) |-> ((!fif.wr_ack)&&(!fif.overflow)&&(!fif.underflow));
endproperty
reset_clk:assert property(P0);
reset_clk_cover:cover property(P0);
property p1;
    @(posedge fif.clk) disable iff(!fif.rst_n)
      (fif.wr_en && !fif.full) |=> fif.wr_ack;
endproperty
  write_acknowledge : assert property(p1);
  write_acknowledge_cover : cover property(p1);
property p2;
    @(posedge fif.clk) disable iff(!fif.rst_n)
      (fif.empty && fif.rd_en) |=> fif.underflow;
endproperty
  underflow_assertion : assert property(p2);
  underflow_cover : cover property(p2);
  property p3;
    @(posedge fif.clk) disable iff(!fif.rst_n)
      (fif.full && fif.wr_en) |=> fif.overflow;
endproperty
  overflow_assertion : assert property(p3);
  overflow_cover : cover property(p3);
property p4;
    @(posedge fif.clk) disable iff(!fif.rst_n)
      (!fif.full && fif.wr_en && !fif.rd_en) |=> 
      (count == $past(count) + 4'b0001);
endproperty
  increment_assertion : assert property(p4);
  increment_cover : cover property(p4);
  property p5;
    @(posedge fif.clk) disable iff(!fif.rst_n)
      (!fif.empty && fif.rd_en && !fif.wr_en) |=> 
      (count == $past(count) - 4'b0001);
  endproperty
  decrement_assertion : assert property(p5);
  decrement_cover : cover property(p5);
endmodule