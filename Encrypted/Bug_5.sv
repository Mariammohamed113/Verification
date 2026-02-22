module analog_test ();
reg clk, reset;
reg write_tb;
reg [15:0] data_in_tb;
wire [15:0] data_out;
Logic [2:0] address_tb;
config_reg DUT (
    .clk(clk), .reset(reset), .write(write_tb), .data_in(data_in_tb), .address(address_tb), .data_out(data_out)
);
initial begin
    clk = 0;
    forever
    #1 clk =~clk;
end

initial begin
    address_tb = 3'b100;
    data_in_tb = 16'h8000;
    write_tb = 1;
    reset = 0;
    #40;
    @(negedge clk);
    address_tb = 3'b100;
    data_in_tb = 16'h2025;
    write_tb = 0;
    reset = 1;
    #40;
    @(negedge clk);
    address_tb = 3'b100;
    data_in_tb = 16'h2025;
    reset = 0;
    write_tb = 1;
    check_result(16'hA0CD);
    #200;
    $stop;
end

task check_result(Logic [15:0] data_out_expected);
    @(negedge clk);
    if (data_out != data_out_expected)
        $display("Error in the Output Data %0b and doesn't match the Expected data %0b", data_out, data_out_expected);
    else
        $display("Correct Result");
endtask

endmodule