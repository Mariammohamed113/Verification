module dff_tb_1;
parameter USE_EN = 1'b1;
logic clk, rst, d, en, q, q_expected;

// DUT
dff #( .USE_EN(USE_EN) ) dut ( .clk(clk), .rst(rst), .d(d), .q(q), .en(en) );

integer error_count;   // total signed integer
integer correct_count; // total signed integer

// clock generation
initial begin
    clk = 0;
    forever #25 clk = ~clk;
end

// Generate expected q
always @(posedge clk or posedge rst) begin
    if (rst)
        q_expected <= 0;
    else if (en || USE_EN == 0)  // only update q_expected if en is high or USE_EN is 0
        q_expected <= d;
end

// Main testbench sequence
initial begin
    correct_count = 0;
    error_count = 0;

    rst = 1; en = 0; d = 0; check_result();
    rst = 0; en = 1; d = 1; check_result();
    d = 0; check_result();
    en = 0; d = 1; check_result();
    d = 1; check_result();

    $display("NOTE: At the end of the test, error count = %0d and correct count = %0d", error_count, correct_count);
    $stop;
end

// Task to check the result
task check_result(input logic expected_result);
    @(negedge clk);
    if (q != expected_result) begin
        error_count = error_count + 1;
        $display("**Error: For q = %0b and en = %0b, d should be %0b but is %0b", 
                 d, en, expected_result, q);
    end
    else begin
        correct_count = correct_count + 1;
    end
endtask

// Task to check reset behavior
task check_reset();
    rst = 1;
    @(negedge clk);
    if (q != 0) begin
        error_count = error_count + 1;
        $display("**Error: Reset asserted, but q is not 0!", $time);
    end
    else begin
        correct_count = correct_count + 1;
    end
    rst = 0;
endtask

endmodule