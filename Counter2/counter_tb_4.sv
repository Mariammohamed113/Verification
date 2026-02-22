import PCK::*;

module counter_tb(counter_if.TEST counterif);
    // Create an instance of the transaction class
    E2 obj = new();
    // Stimulus Generation
initial begin
    assert_rst;
    repeat (35000) begin
        assert(obj.randomize()) else $fatal("Randomization failed.");
        // Apply randomized values
        counterif.rst_n = obj.rst_n_c;
        counterif.load_n = obj.load_n_c;
        counterif.up_down = obj.up_down_c;
        counterif.ce = obj.ce_c;
        counterif.data_load = obj.data_load_c;
        @(negedge counterif.clk);
        obj.count_out_c = counterif.count_out;
        // Sample the coverage
        obj.cg.sample();
    end
    assert_rst;
    $stop;
end

task assert_rst;
    counterif.rst_n=0;
    @(negedge counterif.clk);
    counterif.rst_n=1;
endtask

endmodule