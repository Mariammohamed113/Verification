module dff_tb_2;
parameter USE_EN = 1;
logic clk, rst, en, d, q, q_expected;
dff #( .USE_EN(USE_EN) ) DUT2 ( .clk(clk), .rst(rst), .d(d), .en(en), .q(q) );

integer error_count;   // 32-bit signed integer
integer correct_count; // 32-bit signed integer

// Clock generation
initial begin
    clk = 0;
    forever #25 clk = ~clk;
end

// Generate expected q
always @(posedge clk or posedge rst) begin
    if (rst)
        q_expected <= 0;
    else if (USE_EN && en)
        q_expected <= d;
    else if (!USE_EN)
        q_expected <= d;
    // do not change q_expected if en is low
end

// Main testbench sequence
initial begin
    correct_count = 0;
    error_count = 0;

    // Test reset
    check_reset;

    // Test cases for USE_EN = 1
    d = 1; en = 0; #50; check_result(q_expected); // Initial value with en = 0
    d = 0; en = 1; #50; check_result(q_expected); // Update d with en = 1
    d = 1; en = 1; #50; check_result(q_expected); // Updated d with en = 1
    d = 0; en = 0; #50; check_result(q_expected); // Check q when en = 0

    // Check reset again
    check_reset;

    $display("At the end of the test, error count = %0d and correct count = %0d", 
             error_count, correct_count);
    $stop;
end

// Task to check the result
task check_result(input logic expected_result);
    @(negedge clk); // wait for a clock edge
    #1; // small delay to allow for settling

    if (q != expected_result) begin
        error_count = error_count + 1;
        $display("**Error: For d = %0b and en = %0b, q should be %0b but is %0b", 
                 d, en, expected_result, q);
    end
    else begin
        correct_count = correct_count + 1;
    end
endtask

// Task to check reset behavior
task check_reset();
    rst = 1;
    @(negedge clk); // wait for clock edge to see reset effect
    #1;

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