import shared_pkg ::*;
import FIFO_transaction_pkg ::*;
module FIFO_tb(FIFO_if.TEST if_obj);
FIFO_transaction obj_test ;      
// we choose values
localparam MIXED_TESTS = 9900;    
localparam WRITE_TESTS = 50;      
localparam READ_TESTS = 50;

initial begin
obj_test = new();
if_obj.rst_n = 0;   
repeat(2) @(negedge if_obj.clk); 
if_obj.rst_n = 1;
obj_test.constraint_mode(0);
obj_test.write_only.constraint_mode(1);
repeat(WRITE_TESTS) begin
	assert(obj_test.randomize());
	if_obj.rst_n = obj_test.rst_n ;
	if_obj.rd_en = obj_test.rd_en ;
	if_obj.wr_en = obj_test.wr_en ;
	if_obj.data_in = obj_test.data_in ;
	@(negedge if_obj.clk);
end
obj_test.constraint_mode(0);
obj_test.read_only.constraint_mode(1);
obj_test.data_in.rand_mode(0);   
repeat(READ_TESTS) begin
	assert(obj_test.randomize());
	if_obj.rst_n = obj_test.rst_n ;
	if_obj.rd_en = obj_test.rd_en ;
	if_obj.wr_en = obj_test.wr_en ;
	if_obj.data_in = obj_test.data_in ;
	@(negedge if_obj.clk);
end

obj_test.constraint_mode(1);
obj_test.data_in.rand_mode(1);  
obj_test.read_only.constraint_mode(0);
obj_test.write_only.constraint_mode(0);
repeat(MIXED_TESTS) begin
	assert(obj_test.randomize());
	if_obj.rst_n = obj_test.rst_n ;
	if_obj.rd_en = obj_test.rd_en ;
	if_obj.wr_en = obj_test.wr_en ;
	if_obj.data_in = obj_test.data_in ;
	@(negedge if_obj.clk);
end

test_finished = 1 ;    

end   
endmodule

