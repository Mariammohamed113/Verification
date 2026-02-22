module PE_TB;
    logic clk, rst;
    logic [3:0] D;
    logic [1:0] Y;
    logic valid;

    integer error_count, correct_count;
    // Instantiate the priority_enc module
    priority_enc test (
        .clk(clk),
        .rst(rst),
        .D(D),
        .Y(Y),
        .valid(valid)
    );

    //clock generation
    initial begin
        clk = 0;
        forever #1 clk =~clk; // Clock period of 20 time units
    end

    // Testbench initial block
    initial begin
        rst = 0;
        error_count = 0;
        correct_count = 0;

    // Apply reset and check
    checkreset();
    // Pre-test cases with extended time
    D = 4'b1000; #20; checkresult(2'b00, 1'b1);
    D = 4'b0100; #20; checkresult(2'b01, 1'b1);
    D = 4'b0010; #20; checkresult(2'b10, 1'b1);
    D = 4'b0001; #20; checkresult(2'b11, 1'b1);
    D = 4'b0000; #20; checkresult(2'b00, 1'b0);

    // More tests
    D = 4'b1100; #20; checkresult(2'b00, 1'b1); // Test case where two bits are high
    D = 4'b0110; #20; checkresult(2'b01, 1'b1); // Another case with multiple bits high
    D = 4'b1111; #20; checkresult(2'b00, 1'b1);  // All bits are high, higher priority should win
    D = 4'b1011; #20; checkresult(2'b00, 1'b1);  // Mixed high bits

    // End simulation
    checksresult();
    $stop;
    end

    // Task for reset check
    task checkreset;
        rst = 1; @(negedge clk); // Extend reset for two cycles
        @(negedge clk); if ( valid != 1'b0) begin
            $display("Error during reset: Y= %b, valid =%b at time %0t", Y, valid, $time);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end
        rst = 0;
    endtask

    // Task for checking valid signal
    task checkresult(input expected_Y,
                     input expected_valid);
        @(negedge clk);
        if ((Y != expected_Y) || ( valid != expected_valid)) begin
            $display("Error: Y= %b, expected = %b, valid = %b, expected_valid = %b at time %0t", Y, expected_Y, valid, expected_valid, $time);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end
    endtask

    // Assertions for checking the design
property p_high_pri_bit3;
    @(posedge clk) disable iff (rst)
        (D[3] == 1'b1) |=> 
        (Y == 2'b00 && valid == 1'b1);
endproperty

property p_high_pri_bit2;
    @(posedge clk) disable iff (rst)
        (D[3] == 1'b0 && D[2] == 1'b1) |=> 
        (Y == 2'b01 && valid == 1'b1);
endproperty


property p_high_pri_bit1;
    @(posedge clk) disable iff (rst)
        (D[3:2] == 2'b00 && D[1] == 1'b1) |=> 
        (Y == 2'b10 && valid == 1'b1);
endproperty


property p_high_pri_bit0;
    @(posedge clk) disable iff (rst)
        (D[3:1] == 3'b000 && D[0] == 1'b1) |=> 
        (Y == 2'b11 && valid == 1'b1);
endproperty


property p_case_zero;
    @(posedge clk) disable iff (rst)
        (D == 4'b0000) |=> 
        (Y == 2'b00 && valid == 1'b0);
endproperty
    

    initial begin
    assert property (p_reset);
    assert property (p_high_pri_bit3);
    assert property (p_high_pri_bit2);
    assert property (p_high_pri_bit1);
    assert property (p_high_pri_bit0);
    assert property (p_case_zero);

end

    // Cover properties for monitoring coverage
    cover property (p_case_1000);
    cover property (p_case_0100);
    cover property (p_case_0010);
    cover property (p_case_0001);
    cover property (p_case_0000);


endmodule

