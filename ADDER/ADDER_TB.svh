module ADDER_TB;
    logic clk;
    logic reset;
    logic signed [3:0] A;    // Input data A in 2's complement
    logic signed [3:0] B;    // Input data B in 2's complement
    logic signed [4:0] C;    // Adder output in 2's complement
    adder DUT (.*);
    initial begin
        clk = 0;
        forever
        #1
        clk = ~clk;
    end
    localparam MAXPOS=7, ZERO=0, MAXNEG=-8;
    int error_count;
    int correct_count;
    initial begin
        assert_reset;
        A=MAXNEG ;B=MAXNEG ;check_result(-16);
        A=ZERO   ;B=ZERO   ;check_result(-0);
        A=MAXNEG ;B=MAXPOS ;check_result(-1);
        A=MAXPOS ;B=ZERO   ;check_result(7);
        A=ZERO   ;B=MAXNEG ;check_result(-8);
        A=MAXPOS ;B=MAXPOS ;check_result(14);
        A=MAXNEG ;B=ZERO   ;check_result(-8);
        A=MAXPOS ;B=MAXNEG ;check_result(-1);
        A=ZERO   ;B=MAXPOS ;check_result(7);
        assert_reset;
        $display("error_count=%d , correct_count=%d",error_count,correct_count);
        $stop;
    end
    task check_result(input signed [4:0] expected_result);
        @(negedge clk);
        if(expected_result !== C )begin
            $display ("incorrect result");
            error_count++;
        end
        else correct_count++;
    endtask
    task assert_reset;
        reset=1;
        check_result(0);
        reset=0;
    endtask
endmodule