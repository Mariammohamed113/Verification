/////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Shift register Design
/////////////////////////////////////////////////////////////

module shift_reg (shift_reg_if alif);

always @(*) begin
    if (alif.mode) // rotate
        if (alif.direction) // left
            alif.dataout <= {alif.datain[4:0], alif.datain[5]};
        else
            alif.dataout <= {alif.datain[0], alif.dataout[5:1]};
    else // shift
        if (alif.direction) // left
            alif.dataout <= {alif.datain[0], alif.serial_in};
        else
            alif.dataout <= {alif.serial_in, alif.datain[5:1]};
end

endmodule