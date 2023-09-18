module FSM (
  input             Data_Valid, PAR_EN, ser_done,
  input             CLK, RST,
  output reg [2:0]  mux_sel,
  output reg        ser_en, busy
  );

  localparam  IDLE  = 3'b000,
              START = 3'b001,
              DATA  = 3'b011,
              PAR   = 3'b010,
              STOP  = 3'b110;
  
  reg [2:0]   current_state,
              next_state;
  
  always @(posedge CLK or negedge RST)
    begin
      if(!RST)
        begin
          current_state <= IDLE ;
        end
      else
        begin
          current_state <= next_state ;
        end
    end
  
  always @(*)
    begin
      case(current_state)
        IDLE    : begin
                    ser_en = 1'b0;
                    mux_sel = 3'd0;
                    busy = 1'b0;
                    if (Data_Valid)
                      next_state = START;
                    else
                      next_state = IDLE;
                  end
        
        START   : begin
                    ser_en = 1'b1;
                    mux_sel = 3'd1;
                    busy = 1'b1;
                    next_state = DATA;
                  end
        
        DATA    : begin
                    mux_sel = 3'd2;
                    busy = 1'b1;
                    if (ser_done && PAR_EN)
                      begin
                        next_state = PAR;
                        ser_en = 1'b0;
                      end
                    else if (ser_done)
                      begin
                        next_state = STOP;
                        ser_en = 1'b0;
                      end
                    else
                      begin
                        next_state = DATA;
                        ser_en = 1'b1;
                      end
                  end
        
        PAR     : begin
                    ser_en = 1'b0;
                    mux_sel = 3'd3;
                    busy = 1'b1;
                    next_state = STOP;
                  end
        
        STOP    : begin
                    ser_en = 1'b0;
                    mux_sel = 3'd4;
                    busy = 1'b1;
                    if (Data_Valid)
                      next_state = START;
                    else
                      next_state = IDLE;
                  end
                
        default : begin
                    ser_en = 1'b0;
                    mux_sel = 3'd0;
                    busy = 1'b0;
                    next_state = IDLE;
                  end
                
      endcase
    end
 
endmodule
