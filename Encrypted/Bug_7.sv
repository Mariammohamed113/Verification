module amp_gain();
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
    write_tb = 0;
    reset = 0;
    #20;
    reset = 1;
    @(negedge clk);
    data_in_tb = 16'h0fff;
    address_tb = 3'b100;
    @(negedge clk);
    data_in_tb = 16'h2525;
    address_tb = 3'b101;
    @(negedge clk);
    address_tb = 3'b110;
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