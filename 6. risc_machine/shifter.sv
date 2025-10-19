module shifter(in,shift,sout);
  input [15:0] in; //inputs and outputs
  input [1:0] shift;
  output reg [15:0] sout;
  reg temp;
  assign temp = in[15];

  always @(*) begin //combination block for the shifter
    case(shift)
      2'b00: sout = in; // no shift
      2'b01: sout = in << 1; // shift to the left by 1 bit
      2'b10: sout = in >> 1; // shift to the right by 1 bit
      2'b11: begin
        sout = in >> 1; sout[15] = temp; // shift to the right and store MSB to sout[15]
      end
      default: sout = 16'bxxxxxxxxxxxxxxxx;
    endcase
  end

  
endmodule
