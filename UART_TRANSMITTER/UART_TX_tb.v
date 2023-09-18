`timescale 1ns/1ps

module UART_TX_tb;
  
  parameter CLK_PER = 5;
  parameter EVEN = 0, ODD = 1;
  
  reg [7:0] P_DATA_tb;
  reg       Data_Valid_tb, PAR_EN_tb, PAR_TYP_tb;
  reg       CLK_tb, RST_tb;
  wire      TX_OUT_tb, busy_tb;
  
  integer   i;
  
  always #(CLK_PER/2.0) CLK_tb = ~CLK_tb;
  
  UART_TX DUT (
  .P_DATA(P_DATA_tb),
  .Data_Valid(Data_Valid_tb),
  .PAR_EN(PAR_EN_tb),
  .PAR_TYP(PAR_TYP_tb),
  .CLK(CLK_tb),
  .RST(RST_tb),
  .TX_OUT(TX_OUT_tb),
  .busy(busy_tb)
  );
  
  initial
    begin
      $dumpfile("UART_TX_DUMP.vcd") ;       
      $dumpvars; 
      initialize();
      reset();
      $display("Test Case 1: Parity is enabled & Parity Type is even");
      test_data(8'b11011011, 1'b1, EVEN);
      $display("Test Case 2: Parity is enabled & Parity Type is odd");
      test_data(8'b10101010, 1'b1, ODD);
      $display("Test Case 2: Parity is not enabled");
      test_data(8'b11011011, 1'b0, EVEN);
      #(2*CLK_PER)
      $stop;
    end
  
  task initialize;
    begin
      CLK_tb = 1'b0;
      RST_tb = 1'b1;
      Data_Valid_tb = 1'b0;
      PAR_EN_tb = 1'b0;
      PAR_TYP_tb = 1'b0;
    end
  endtask
    
  task reset;
    begin
      #1
      RST_tb  = 'b0;
      #(CLK_PER - 1)
      RST_tb  = 'b1;
    end
  endtask
    
  task test_data;
    input [7:0]      TEST_DATA;
    input            Par_en, Par_type;
    reg   [10:0]     Frame;
    reg   [10:0]     EXPECTED;
    reg   [10:0]     Busy_ch;
    reg              parity;
    begin
      P_DATA_tb = TEST_DATA;
      PAR_EN_tb = Par_en;
      PAR_TYP_tb = Par_type;
      Data_Valid_tb = 1'b1;
      
      if(Par_type == EVEN)
        parity = ^(TEST_DATA);
      else
        parity = ~^(TEST_DATA);
        
      if(Par_en)
        EXPECTED = {1'b1, parity, TEST_DATA, 1'b0};
      else
        EXPECTED = {Frame[10], 1'b1, TEST_DATA, 1'b0};
        
      @(posedge CLK_tb);
      for (i = 0; i <= 9+Par_en; i = i + 1)
        begin
          @(negedge CLK_tb)
          Data_Valid_tb = 1'b0;
          Frame[i] = TX_OUT_tb;
          Busy_ch[i] = busy_tb;
        end
      if ((Frame == EXPECTED) && (&Busy_ch == 1'b1))
        $display("Test Case is succeeded");
      else
        $display("Test Case is Failed");
    end
  endtask

endmodule
