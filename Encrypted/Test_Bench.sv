typedef enum logic [2:0]{adc0_reg = 3'b000, adc1_reg = 3'b001, temp_sensor0_reg = 3'b010, temp_sensor1_reg = 3'b011,
                        analog_test = 3'b100, digital_test = 3'b101,
                        gpio_config = 3'b110, gpio_in = 3'b111} reg_e;

module config_reg_tb();
    logic clk, reset, write;
    logic [15:0] data_in_tb, data_out_tb;
    logic [2:0] address_tb;
    logic find_error;

    reg [15:0] check_res0, check_res1;
    reg_e addr_enum;
    int i, error_counter_tb, correct_counter_tb;

    config_reg DUT (.clk(clk), .reset(reset), .write(write), .data_in(data_in_tb),
                    .address(address_tb), .data_out(data_out_tb));

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset_assert;
    write = 0;
    data_in_tb = 0;

    reset_assert;
    #10 reset_assert;
    reset_assert;
    reset_assert;

    addr_enum = adc0_reg;
    reset_assoc["adc0_reg"] = 16'hffff;
    reset_assoc["adc1_reg"] = 16'h0;
    reset_assoc["temp_sensor0"] = 16'h0;
    reset_assoc["temp_sensor1"] = 16'h0;
    reset_assoc["analog_test"] = 16'h0;
    reset_assoc["digital_test"] = 16'h0;
    reset_assoc["gpio_config"] = 16'h0;
    reset_assoc["gpio_in"] = 16'h0;

    initial begin
        addr_enum = adc0_reg;
        data_assoc = 0;
        error_counter_tb = 0;
        correct_counter_tb = 0;

        for(i = 0; i < 15; i++) begin
            data_in_tb = i;
            for(addr_enum = adc0_reg; addr_enum <= gpio_in; addr_enum++) begin
                write = 1;
                #(delay_ns * 10);
                @(negedge clk);
                write = 0;
                #(delay_ns * 10);

                check_reset(i);
            end
        end
        $display("Error Count= %d and correct Count= %d", error_counter_tb, correct_counter_tb);
        $stop;
    end
end

task reset_assert;
    reset = 1;
    @(negedge clk);
    reset = 0;
endtask

task check_reset(input int i);
    addr_enum = $urandom_range(0, 7);
    address_tb = address_tb_t'(addr_enum);
    @(negedge clk);
    if(data_out_tb != reset_assoc[address_tb.name()]) begin
        $display("The Error is in the Reset reg, The Data_out is %h and the expected is %h, addr=%0h, data_out, reset_assoc[address_tb.name()]);
        error_counter_tb = error_counter_tb + 1;
    end
    else begin
        correct_counter_tb = correct_counter_tb + 1;
    end
endtask

task write_data;
    addr_enum = $urandom_range(0, 7);
    address_tb = address_tb_t'(addr_enum);
    @(negedge clk);
    data_in_tb = i;
endtask

task check_data;
    @(negedge clk);
    if(data_out_tb != data_in_tb) begin
        $display("Error in the Output Data %h of reg %h doesn't match the input data %h", data_out_tb, address_tb.name(), data_in_tb);
        error_counter_tb = error_counter_tb + 1;
    end
    else begin
        correct_counter_tb = correct_counter_tb + 1;
    end
endtask

endmodule