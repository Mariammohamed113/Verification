interface counter_if (clk);
    // parameter declaration
    parameter WIDTH = 4;
    // input & output declaration
    logic rst_n, load_n, up_down, ce;
    logic [WIDTH-1:0] data_load, count_out;
    logic max_count, zero;
    input bit clk;

    modport DUT (input clk, rst_n, load_n, up_down, ce, data_load, output count_out, max_count, zero);
    modport TEST (output rst_n, load_n, up_down, ce, data_load, input clk, count_out, max_count, zero);

endinterface