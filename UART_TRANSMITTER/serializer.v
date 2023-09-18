module serializer (
  input [7:0] P_DATA,
  input       ser_en,
  input       CLK, RST,
  output reg  ser_data,
  output      ser_done
  );
  
  reg [3:0] ser_count;

  
  always @(posedge CLK or negedge RST)
    begin
      if (!RST)
        begin
          ser_data <= 1'b0;
        end
      else if (ser_en)
        begin
          ser_data <= P_DATA[ser_count];
        end
      else
        begin
          ser_data <= 1'b0;
        end
    end
    
    always @(posedge CLK or negedge RST)
      begin
        if (!RST)
        begin
          ser_count <= 4'b0;
        end
      else if (ser_en && !ser_done)
        begin
          ser_count <= ser_count + 4'b1;
        end
      else
        begin
          ser_count <= 4'b0;
        end
      end
      
    assign ser_done = (ser_count == 4'h8);
endmodule