import pack_test::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module TOP ();
bit clk;
initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

ALSU_if al_if (clk);
ALSU DUT (al_if);
ALSU_Gold GOLD(al_if);
bind ALSU SVA assertions (al_if.DUT);

initial begin
    uvm_config_db#(virtual ALSU_if)::set(null,"uvm_test_top","ALSU_if", al_if);
    run_test("test");
end

endmodule