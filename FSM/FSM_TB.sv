import pck::*;

module FSM_TB;

    // Parameters
    parameter IDLE = 2'b00;
    parameter ZERO = 2'b01;
    parameter ONE  = 2'b10;
    parameter STORE = 2'b11;

    // Signals
    bit clk, rst, x;
    bit y, y_expected;
    bit [9:0] users_count, users_count_expected;
    int error_counter, correct_counter;

    // FSM transition object
    fsm_trs obj; // create object from the class

    // DUT Instantiation
    FSM DUT(.clk(clk), .rst(rst), .x(x), .y(users_count), .users_count(users_count));
    FSM_GM GM (.clk(clk), .rst(rst), .x(x), .y_exp(y_expected), .count_exp(users_count_expected));

    // Clock generation
    initial begin
        clk = 0;
        forever begin #1 clk = ~clk; obj.clk=clk; end
    end

    // Testbench logic
    initial begin
        error_counter = 0;
        correct_counter = 0;

        // Generate random inputs and apply them
        repeat (20000) begin
            assert(obj.randomize()); // Randomize inputs
            rst = obj.rst_c;
            x = obj.x_c;

            @(negedge clk);

            obj.cg_x_transition.sample(); // Check results
            check_result();
        end

        $display("Error_Counter = %0d", error_counter);
        $stop;
    end

    // Check Result Task
    task check_result();
        @(negedge clk);
        if ((y != y_expected) && (users_count != users_count_expected)) begin
            error_counter++;
        end
        else
            correct_counter++;
    endtask

endmodule