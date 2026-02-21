import PCK::*;

module counter_tb;

  // Parameter
  parameter WIDTH = 4;

  // Input and output declaration
  logic clk, rst_n, load_n, up_down, ce;
  logic [WIDTH-1:0] data_load;
  logic [WIDTH-1:0] count_out;
  logic max_count, zero;
  logic [WIDTH-1:0] count_out_exp;  // Expected value for output count

  // Counters declaration
  int correct_count, error_count;

  // DUT Instantiation
  counter #( .WIDTH(WIDTH) ) DUT (
    .clk(clk),
    .rst_n(rst_n),
    .load_n(load_n),
    .up_down(up_down),
    .ce(ce),
    .data_load(data_load),
    .count_out(count_out),
    .max_count(max_count),
    .zero(zero)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #25 clk = ~clk; // Clock period is 50 time units
  end

  // Define the randomization object
  E2 object1;

  initial begin
    // Initialize variables
    object1 = new();
    correct_count = 0;
    error_count = 0;
    count_out_exp = 0;

    // Run the test for a number of iterations
    repeat (1000) begin

      // Randomize the test object
      assert (object1.randomize());

      // Apply randomized values
      rst_n     = object1.rst_n_c;
      load_n    = object1.load_n_c;
      up_down   = object1.up_down_c;
      ce        = object1.ce_c;
      data_load = object1.data_load_c;

      @(negedge clk);
      object1.count_out_c = count_out;
      object1.cg.sample();

      self_check();
    end

    // Final results
    $display("Total Correct Count = %0d, Total Errors = %0d", 
              correct_count, error_count);
    $stop;
  end

  // Task to check the DUT output
  task self_check();

    // Calculate the expected value
    if (!rst_n)
      count_out_exp = 0;
    else if (!load_n)
      count_out_exp = data_load;
    else if (ce) begin
      // Update count_out_exp based on direction
      if (up_down) begin // counting up
        if (count_out_exp == {WIDTH{1'b1}}) 
          count_out_exp = 0;  // Wrap around
        else 
          count_out_exp = count_out_exp + 1;
      end
      else begin // counting down
        if (count_out_exp == 0) 
          count_out_exp = {WIDTH{1'b1}}; // Wrap around
        else 
          count_out_exp = count_out_exp - 1;
      end
    end

    // Display
    $display("DUT Output: count_out = %0d, Expected Output: count_out_exp = %0d", 
              count_out, count_out_exp);

    if (count_out !== count_out_exp) begin
