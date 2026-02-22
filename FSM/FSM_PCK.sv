package pck;

typedef enum logic[1:0] {IDLE , ZERO , ONE , STORE} state_e ;

class fsm_trs;
    rand bit rst_c , x_c ;
    bit y_exp,clk ;
    bit [9:0] users_count_exp ;
    constraint C_inputs { rst_c dist {0:= 90 , 1:= 10};x_c dist {0:/67 , 1:/33};}
    covergroup cg_x_transition@(posedge clk);

        x_transition: coverpoint x_c {
            bins x_0_to_1_to_0 = (0 => 1 => 0);
        }

    endgroup

    function new();
        cg_x_transition = new();
    endfunction

endclass

endpackage