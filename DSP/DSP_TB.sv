module DSP_TB;
  //parameter
  //parameter OPERATION = "ADD";
  parameter ZERO=0;
  //signal DECLARATION
  logic  [17:0] A, B, D;
  logic  [47:0] C, P_tb;
  logic clk, rst_n;
  //DUT INSTANTATION
  DSP dut(.A(A),.B(B),.C(C),.D(D),.clk(clk),.clk(clk),.rst_n(rst_n),.P(P));

  integer error_count;
  integer correct_count;
  //clock GENERATION
  initial begin
    clk=0;
    forever
      #1 clk=~clk;
  end

  //TEST
  initial begin
    correct_count=0;
    error_count=0;
    A = ZERO; B = ZERO; C = ZERO; D = ZERO; check_result(((0 + 0) * 0) + C);
    A = ZERO; B = ZERO; C = ZERO; D = ZERO; check_result(((0 + 0) * 0) + C);
    A = ZERO; B = ZERO; C = ZERO; D = ZERO; check_result(((0 + 0) * 0) + C);
    A = ZERO; B = ZERO; C = ZERO; D = ZERO; check_result(((0 + 0) * 0) + C);

    A = 10; B = 3; C = 2; D = 0; check_result(((10 + 3) * 0) + C);
    A = 2; B = 3; C = 5; D = 0; check_result(((2 + 3) * 0) + C);
    A = 7; B = 2; C = 9; D = 0; check_result(((7 + 2) * 0) + C);
    A = 20; B = 10; C = 33; D = 0; check_result(((20 + 10) * 0) + C);

    A = 5; B = 6; C = 7; D = 3; check_result(((5 + 6) * 3) + C);
    A = 9; B = 8; C = 10; D = 4; check_result(((9 + 8) * 4) + C);
    A = 3; B = 2; C = 5; D = 1; check_result(((3 + 2) * 1) + C);

    A = 18'h12345; B = 18'h3434; C = 48'h123456789ABC; D = 18'h333;
    check_result(((A + B) * D) + C);

    A = 18'hAAAA; B = 18'hBBBB; C = 48'h123456; D = 18'h345;
    check_result(((A + B) * D) + C);

    A = 18'hABCDE; B = 18'h123456; C = 48'h123456789ABC; D = 18'hA;
    check_result(((A + B) * D) + C);

    A = 18'h12345; B = 18'hABCD; C = 48'hABCDE1234567; D = 18'h12345;
    check_result(((A + B) * D) + C);

    // Random test
    for (int i = 1; i < 100; i++) begin
      // Random range
      A = $urandom_range(ZERO, 18'h12345);
      B = $urandom_range(ZERO, 18'h12345);
      C = $urandom_range(ZERO, 48'h123456789ABC);
      D = $urandom_range(ZERO, 18'h12345);

      check_result(((A + B) * D) + C);
    end

    $display("Correct Count: ");
    $display(correct_count);
    $display("Error Count: ");
    $display(error_count);
    $stop;
  end

  task check_result(input [47:0] expected_result );
    @(negedge clk);
    if(P != expected_result) begin
      $display("INCORRECT ! should equal %d", expected_result);
      error_count++;
    end
    else begin
      correct_count++;
    end
  endtask

  initial begin
    rst_n=0;
    #5 rst_n=1;
  end

endmodule