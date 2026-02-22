import uvm_pkg::*;
`include "uvm_macros.svh"
import test_pkg::*;

module top();
bit clk=0;
always #5 clk=clk;

ALSU_if al_if(clk);
shift_reg_if sh_if();
SH_reg SI (sh_if);
ALSU DUT (al_if,sh_if);

bind ALSU Assertions AS (al_if);

initial begin
    uvm_config_db #(virtual ALSU_if)::set(null,"*.ALSU_if","ALSU_if",al_if);
    uvm_config_db #(virtual shift_reg_if)::set(null,"*.SHIFT_IF","SHIFT_if",sh_if);
    run_test("ALSU_test");
end

endmodule