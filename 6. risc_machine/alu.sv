module ALU(Ain,Bin,ALUop,out,status);
  input [15:0] Ain, Bin; // inputs and outputs
  input [1:0] ALUop;
  output reg [15:0] out;
  output reg [2:0] status;



  always @(*) begin // combination block for ALU

    case(ALUop)
      2'b00: out = Ain + Bin; //adding
      2'b01: out = Ain - Bin; //subtracting 
      2'b10: out = Ain & Bin; //anding
      2'b11: out = ~Bin + 1; //notting the B input
      default: out = 16'bxxxxxxxxxxxxxxxx;
    endcase
  end
  
  always @(*) begin // combination block for the Z flag and N flag
    casex(out)
      16'sb0000000000000000: begin // Z
        status[0] = 1;
        status[2] = 0;
      end
      16'sb1xxxxxxxxxxxxxxx: begin // N
        status[0] = 0;
        status[2] = 1;
      end
      default: begin
        status[0] = 0;
        status[2] = 0;
      end
        
    endcase
  end

  always @(*) begin // combination block for the V flag (overflow)
    case(ALUop) 
      2'b00: if((Ain[15] == Bin[15]) && (out[15] == Ain[15])) begin
        status[1] = 0;
      end
      2'b01: if((Ain[15] !== Bin[15]) && (out[15] == Ain[15])) begin
        status[1] = 0;
      end
      2'b10: status[1] = 0;
      2'b11: status [1] = 0;
      default: status[1] = 1;

    endcase 
  end 
endmodule 

      
