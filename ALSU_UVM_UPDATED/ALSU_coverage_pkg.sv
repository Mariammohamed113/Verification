package ALSU_coverage_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import ALSU_seq_item_pkg::*;

class ALSU_coverage extends uvm_component;
    `uvm_component_utils(ALSU_coverage);

    seq_item item;
    uvm_analysis_export #(seq_item) cov_ep;
    uvm_analysis_fifo #(seq_item) cov_fifo;

    covergroup cov @(posedge item.clk);
        CIN: coverpoint item.cin{
            bins CIN0={0};
            bins CIN1={1};
            option.weight=1;
        }

        red_op_A: coverpoint item.red_op_A{
            bins red_op_A0={0};
            bins red_op_A1={1};
            option.weight=1;
        }

        red_op_B: coverpoint item.red_op_B{
            bins red_op_B0={0};
            bins red_op_B1={1};
            option.weight=1;
        }

        bypass_A: coverpoint item.bypass_A{
            bins bypass_A0={0};
            bins bypass_A1={1};
            option.weight=1;
        }

        bypass_B: coverpoint item.bypass_B{
            bins bypass_B0={0};
            bins bypass_B1={1};
            option.weight=1;
        }

        direction: coverpoint item.direction{
            bins direction0={0};
            bins direction1={1};
            option.weight=1;
        }

        serial_in: coverpoint item.serial_in{
            bins serial_in0={0};
            bins serial_in1={1};
            option.weight=1;
        }

        special: coverpoint item.opcode{
            option.weight=1;
            bins operations[]={ [OR:ROTATE] };
        }

        CB1: coverpoint item.A{
            bins A_data_0={0};
            bins A_data_max={MAXPOS};
            bins A_data_min={MAXNEG};
            bins A_data_walkingones={3'b001,3'b010,3'b100} iff (!item.red_op_A);
            bins A_data_default=default;
        }

        CB2: coverpoint item.B{
            bins B_data_0={0};
            bins B_data_max={MAXPOS};
            bins B_data_min={MAXNEG};
            bins B_data_walkingones={3'b001,3'b010,3'b100} iff (!item.red_op_B);
            bins B_data_default=default;
        }

        AL_M: coverpoint item.opcode{
            bins bins_arith[] = {ADD,MULT};
        }
    endgroup