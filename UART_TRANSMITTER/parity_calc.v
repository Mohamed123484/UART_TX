module parity_calc (
  input [7:0] P_DATA,
  input       Data_Valid, PAR_TYP,
  input       CLK, RST,
  output reg  par_bit
  );
  
  
  always @(posedge CLK or negedge RST)
    begin
      if (!RST)
        begin
          par_bit <= 1'b0;
        end
      else if (Data_Valid)
        begin
          case (PAR_TYP)
            1'b0: par_bit <= ^(P_DATA);
            1'b1: par_bit <= ~^(P_DATA);
          endcase
        end
    end
  
endmodule