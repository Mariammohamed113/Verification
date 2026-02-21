module PE_TB;
    logic clk;
    logic rst;
    logic [3:0] D;
    logic [1:0] Y;
    logic valid;

    priority_enc DUT(.*);
    integer error_count;
    integer correct_count;

    initial begin
        clk=0;
        forever #1 clk=~clk;
    end

    initial begin
        D=4'b0000;
        error_count=0;
        correct_count=0;
        assert_reset;
        for (int i = 0; i < 10; i++) begin
            D=4'b0000;check_result_Y(0);check_result_valid(0);
            D=4'b1000;check_result_Y(0);check_result_valid(1);
            D=4'b0100;check_result_Y(1);check_result_valid(1);
            D=4'b0010;check_result_Y(2);check_result_valid(1);
            D=4'b0001;check_result_Y(3);check_result_valid(1);
        end
        $display("%t: error count=%0d, correct_count=%0d", $time, error_count, correct_count);
        $stop;
    end

    task check_result_Y(input [1:0] expected_result_Y );
        @(negedge clk);
        if(expected_result_Y !== Y) begin
            $display("%t: Error: For D=%b, Y should equal %0d but is %0d", $time, D, expected_result_Y, Y);
            error_count++;
        end
        else correct_count++;
    endtask

    task check_result_valid(input expected_result_valid );
        @(negedge clk);
        if(expected_result_valid !== valid) begin
            $display("%t: Error: For D=%b, valid should equal %0d but is %0d", $time, D, expected_result_valid, valid);
            error_count++;
        end
        else correct_count++;
    endtask

    task assert_reset;
        rst=1;
        check_result_Y(0);
        check_result_valid(0);
        rst=0;
    endtask
    
endmodule