module counter_sva (counter_if.DUT counterif);

    // Assertion: when load control signal is active, dout should be equal to din
    property p_load_control;
        @(posedge counterif.clk) disable iff (!counterif.rst_n)
        (counterif.load_n == 0) |-> (counterif.count_out == $past(counterif.data_load));
    endproperty

    assert property (p_load_control)
        else $fatal(1,"load control assertion failed");
    cover property (p_load_control);

    // when load control signal is not active, and enable is off, dout should not change
    property p_no_change;
        @(posedge counterif.clk) disable iff (!counterif.rst_n)
        (counterif.load_n == 1 && counterif.ce == 0) |=> $stable(counterif.count_out);
    endproperty

    assert property (p_no_change)
        else $fatal(1,"no change assertion failed");
    cover property (p_no_change);

    // Increment: when load_n is inactive, enable is active, and up_down is high, dout should increment
    property p_increment;
        @(posedge counterif.clk) disable iff (!counterif.rst_n)
        ((counterif.load_n == 1 && counterif.ce == 1 && counterif.up_down == 1)) |=> (counterif.count_out == $past(counterif.count_out) + 4'b0001);
    endproperty

    assert property (p_increment)
        else $fatal(1,"increment assertion failed");
    cover property (p_increment);

    // Decrement: when load_n is inactive, enable is active, and up_down is low, dout should decrement
    property p_decrement;
        @(posedge counterif.clk) disable iff (!counterif.rst_n)
        ((counterif.load_n == 1 && counterif.ce == 1 && counterif.up_down == 0)) |=> (counterif.count_out == $past(counterif.count_out) - 4'b0001);
    endproperty

    assert property (p_decrement)
        else $fatal(1,"decrement assertion failed");
    cover property (p_decrement);

    // check reset
    always @(posedge counterif.clk) begin
        if(!counterif.rst_n)
            assert final(counterif.count_out == 0);
        if(counterif.count_out == counterif.zero == 1)
            $display("ZERO");
        if(counterif.count_out == counterif.WIDTH{1'b1})
            $display("MAX");
        assert property (counterif.max_count == 1);
        assert property (counterif.zero == 1);
    end

endmodule