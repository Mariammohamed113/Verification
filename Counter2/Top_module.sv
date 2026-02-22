module TOP;

bit clk;
always #50 clk=~clk;

// interface object
counter_if counterif(clk);
// DUT instantiation
counter DUT(counterif);
// testbench instantiation
counter_tb TEST(counterif);
// binding the assertions
bind counter counter_sva T(counterif);

endmodule