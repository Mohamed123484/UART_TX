module MUX (
  input [2:0] mux_sel,
  input       ser_data,
  input       par_bit,
  output reg  TX_OUT
  );
  
  always @(*)
    begin
      case (mux_sel)
        3'd0    : TX_OUT = 1'b1;
        3'd1    : TX_OUT = 1'b0;
        3'd2    : TX_OUT = ser_data;
        3'd3    : TX_OUT = par_bit;
        3'd4    : TX_OUT = 1'b1;
        default : TX_OUT = 1'b1;
      endcase
    end
endmodule
