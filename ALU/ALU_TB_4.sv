import pck::*;

module ALU_TB;
    // Input and output declarations
    logic clk, reset;
    opcode_e Opcode;
    logic signed [3:0] A, B;
    logic signed [4:0] C;

    M obj; // creation of object from class

    // Module Instantiation
    ALU DUT (.*);

    // Clock declaration
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // Testbench initialization
    initial begin
        obj = new();
        reset = 0;

        // Randomized Testing
        repeat (50) begin
            @(negedge clk);
            assert(obj.randomize());
            A = obj.a;
            B = obj.b;
            Opcode = obj.opcode;
            reset = obj.rst;

            @(negedge clk);
            $display("At: For Inputs A = %0d, B = %0d, Opcode = %0d, Reset = %0d,Output C = %0d",
                      $time, A, B, Opcode, reset, C);
        end
        $stop;
    end

    // Properties
    property Addition_Prop;
        @(negedge clk) !reset && (Opcode == Add) |-> (C == A + B);
    endproperty

    property Subtraction_Prop;
        @(negedge clk) !reset && (Opcode == Sub) |-> (C == A - B);
    endproperty

    property Not_A_Prop;
        @(negedge clk) !reset && (Opcode == Not_A) |-> (C == ~A);
    endproperty

    property ReductionOR_B_Prop;
        @(negedge clk) !reset && (Opcode == ReductionOR_B) |-> (C == |B);
    endproperty

    assert property (Addition_Prop);
    assert property (Subtraction_Prop);
    assert property (Not_A_Prop);
    assert property (ReductionOR_B_Prop);

endmodule