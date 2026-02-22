package PCK;
    parameter WIDTH = 4;
    localparam ZERO =0;
    localparam MAX_COUNT = {WIDTH{1'b1}};
class Z;
    rand bit rst_n_c, load_n_c, ce_c, up_down_c;
    rand bit [WIDTH-1:0] data_load_c;
    logic [WIDTH-1:0] count_out_c;

    // Constraints for the random variables
    constraint c_rst { rst_n_c dist {0 := 5 , 1 := 95}; }
    constraint c_load { load_n_c dist {0 := 70 , 1 := 30};}
    constraint c_enable { ce_c dist {0 := 30 , 1 := 70};}

    covergroup cg @(posedge clk);
        load_cp : coverpoint data_load_c iff(!load_n_c);
        count_up_c1 : coverpoint count_out_c iff(rst_n_c && ce_c && up_down_c);
        count_up_c2 : coverpoint count_out_c iff(rst_n_c && ce_c && up_down_c){
            bins trans_overflow = (MAX_COUNT => ZERO);
        }
        count_down_c1 : coverpoint count_out_c iff(rst_n_c && ce_c && ! up_down_c);
        count_down_c2 : coverpoint count_out_c iff(rst_n_c && ce_c && ! up_down_c){
            bins trans_underflow = (ZERO => MAX_COUNT);
        }
    endgroup

    function new ;
        cg = new();
    endfunction

endclass
endpackage