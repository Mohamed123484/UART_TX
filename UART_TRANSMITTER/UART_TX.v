module UART_TX (
  input [7:0] P_DATA,
  input       Data_Valid, PAR_EN, PAR_TYP,
  input       CLK, RST,
  output      TX_OUT, busy
  );
  
  wire        ser_en, ser_data, ser_done,
              par_bit;
  wire [2:0]  mux_sel;
        
  
  serializer U0 (
    .P_DATA(P_DATA),
    .ser_en(ser_en),
    .CLK(CLK), 
    .RST(RST),
    .ser_data(ser_data),
    .ser_done(ser_done)
    );
  
  parity_calc U1 (
  .P_DATA(P_DATA),
  .Data_Valid(Data_Valid),
  .PAR_TYP(PAR_TYP),
  .CLK(CLK),
  .RST(RST),
  .par_bit(par_bit)
  );
  
  FSM U2 (
  .Data_Valid(Data_Valid),
  .PAR_EN(PAR_EN),
  .ser_done(ser_done),
  .CLK(CLK),
  .RST(RST),
  .mux_sel(mux_sel),
  .ser_en(ser_en),
  .busy(busy)
  );
  
  MUX U3 (
  .mux_sel(mux_sel),
  .ser_data(ser_data),
  .par_bit(par_bit),
  .TX_OUT(TX_OUT)
  );
  
endmodule
  
