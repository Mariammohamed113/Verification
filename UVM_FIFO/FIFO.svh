module FIFO(FIFO_if.DUT fif);
localparam max_fifo_addr = $clog2(fif.FIFO_DEPTH);
reg [fif.FIFO_WIDTH-1:0] mem [fif.FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr; 
reg [max_fifo_addr:0] count;
always @(posedge fif.clk or negedge fif.rst_n) begin
	if (!fif.rst_n) begin
		wr_ptr <= 0;
		fif.overflow <= 0;
		fif.wr_ack <= 0;             
	end
	else if (fif.wr_en && count < fif.FIFO_DEPTH) begin
		mem[wr_ptr] <= fif.data_in;
		fif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end else begin 
		fif.wr_ack <= 0; 
		if (fif.full && fif.wr_en)
			fif.overflow <= 1;
		else fif.overflow <= 0;
	end end
always @(posedge fif.clk or negedge fif.rst_n) begin
	if (!fif.rst_n) begin
		rd_ptr <= 0;
		fif.underflow <= 0;
		fif.data_out <= 0;       
	end else if (fif.rd_en && count != 0) begin
		fif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		end
	else begin
		if(fif.empty && fif.rd_en)
			fif.underflow  <= 1;
		else
			fif.underflow  <= 0;
	end end
// always block specialized for counter signal
always @(posedge fif.clk or negedge fif.rst_n) begin
	if (!fif.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({fif.wr_en, fif.rd_en} == 2'b10) && !fif.full) 
			count <= count + 1;
		else if ( ({fif.wr_en, fif.rd_en} == 2'b01) && !fif.empty)
			count <= count - 1;
		else if (({fif.wr_en, fif.rd_en} == 2'b11) && fif.full)      // priority for write operation
			count <= count - 1;
		else if (({fif.wr_en, fif.rd_en} == 2'b11) && fif.empty)      // priority for read operation
			count <= count + 1;
	end end
assign fif.full = (count == fif.FIFO_DEPTH)? 1 : 0;
assign fif.empty = (count == 0)? 1 : 0;
assign fif.almostfull = (count == fif.FIFO_DEPTH-1)? 1 : 0; 
assign fif.almostempty = (count == 1)? 1 : 0;
endmodule


