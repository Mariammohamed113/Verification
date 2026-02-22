module RAM_tb();

    // Input and Output Declaration
    logic clk, write, read;
    logic [7:0] data_in;
    logic [15:0] address;
    logic [8:0] data_out;

    localparam TESTS = 100;
    // Error & Correct Counters
    integer error_counter, correct_counter;

    // Testbench Data Arrays
    bit [15:0] address_array[];
    bit [7:0] data_to_write_array[];
    bit [8:0] data_read_expect_assoc[bit [18:0]];
    bit [8:0] data_read_queue[$];

    // Design Module Instantiation
    RAM DUT (.*);

    // CLOCK GENERATION
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    task stimulus_gen();
        for (int i = 0 ; i < TESTS ; i++) begin
            address_array[i] = $random;
            data_to_write_array[i] = $random;
        end
    endtask

    task golden_model();
        for(int i = 0 ; i < TESTS ; i++) begin
            data_read_expect_assoc[address_array[i]] = {^data_to_write_array[i], data_to_write_array[i]};
        end
    endtask

    // Initial Values for Inputs & Main Block Operations
    initial begin
        address_array = new[TESTS];
        data_to_write_array = new[TESTS];
        // Initialize all Counters & Inputs to ZERO
        error_counter = 0;
        correct_counter = 0;
        correct_counter = 0;
    error_counter = 0;
    write = 0;
    read = 0;
    #2;

    // Delay 1 Clock Cycles
    repeat(1) @(negedge clk);
    stimulus_gen();
    @(negedge clk);
    golden_model();

    // Write Operations
    write = 1;
    for (int i = 0 ; i < TESTS ; i++) begin
        @(negedge clk);
        address = address_array[i];
        data_in = data_to_write_array[i];
    end
    write = 0;

    // Delay 1 Clock Cycles to Allow Final Data to be Written in RAM
    repeat(1) @(negedge clk);

    read = 1;
    address_array.reverse();
    for(int i = 0 ; i < TESTS ; i++) begin
        @(negedge clk);
        address = address_array[i];
        data_read_queue.insert(i, data_out);
    end
    read = 0;

    $display("Data Read From The Queue");
    while (data_read_queue.size())
        $display("%0t: Data Read From Queue %0h", $time, data_read_queue.pop_front());

    @(negedge clk);
    $display("%0t: At End of test error counter = %0d and correct counter = %0d", 
             $time, error_counter, correct_counter);
    $stop;
end

task check_result(input bit [18:0] Expected_Address);
    @(negedge clk);
    if (data_read_expect_assoc.exists(Expected_Address)) begin
        if (data_out != data_read_expect_assoc[Expected_Address]) begin
            $display("%0t: Error: For Read Data %0h should be equal to %0h but it is not equal",
                     $time, data_out, data_read_expect_assoc[address_array[Expected_Address]]);
            error_counter++;
        end
        else
            correct_counter++;
    end
endtask

endmodule

``
