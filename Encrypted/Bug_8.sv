module digital_config();
reg clk, reset;
reg write_tb;
reg [15:0] data_in_tb;
wire [15:0] data_out;
Logic [2:0] address_tb;
config_reg DUT(
    .clk(clk), .reset(reset), .write(write_tb), .data_in(data_in_tb), .address(address_tb), .data_out(data_out)
);
initial begin
    clk = 0;
    forever
    #1 clk =~clk;
end

initial begin
    address_tb = 3'b111;
    data_in_tb = 16'b0000_0000_0000_0001;
    write_tb = 1;
    reset = 1;

    @(negedge clk);
    data_in_tb = 16'b0000_0000_0000_0001;
    address_tb = 3'b111;
    write_tb = 0;

    @(negedge clk);
    data_in_tb = 16'h2025;
    reset = 1;
    address_tb = 3'b111;
    write_tb = 1;
    check_result();
    #50;
    $stop;
end

task check_result();
    @(negedge clk);
    if (data_out != data_in_tb)
        $display("Error in the Output Data %0b and doesn't match the Expected data %0b",data_out, data_in_tb);
    else
        $display("Correct Result");
endtask

endmodule