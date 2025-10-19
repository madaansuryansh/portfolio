module regfile(data_in,writenum,write,readnum,clk,data_out);
  input [15:0] data_in; 
  input [2:0] writenum, readnum;
  input write, clk;
  output reg [15:0] data_out;
  reg [7:0] writenum_h; //output of writenum decoder in hot-code
  reg [7:0] readnum_h; //output of readnum decoder in hot-code
  reg [7:0] load; //load for each load enable blocks
  assign load = writenum_h & {8{write}}; //ands the value of writenum and write to signal when to store values into register
  reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7; //registers

  always @(*) begin //combination block for writenum decoder
    case(writenum)
      3'b000: writenum_h = 8'b00000001;
      3'b001: writenum_h = 8'b00000010;
      3'b010: writenum_h = 8'b00000100;
      3'b011: writenum_h = 8'b00001000;
      3'b100: writenum_h = 8'b00010000;
      3'b101: writenum_h = 8'b00100000;
      3'b110: writenum_h = 8'b01000000;
      3'b111: writenum_h = 8'b10000000;
      default: writenum_h = 8'bxxxxxxxx;
    endcase
  end
  
  always @(*) begin //combination block for readnum decoder
    case(readnum)
      3'b000: readnum_h = 8'b00000001;
      3'b001: readnum_h = 8'b00000010;
      3'b010: readnum_h = 8'b00000100;
      3'b011: readnum_h = 8'b00001000;
      3'b100: readnum_h = 8'b00010000;
      3'b101: readnum_h = 8'b00100000;
      3'b110: readnum_h = 8'b01000000;
      3'b111: readnum_h = 8'b10000000;
      default: readnum_h = 8'bxxxxxxxx;
    endcase
  end

  always_ff @(posedge clk) begin //flip flop for all load enable blocks. this stores data into registers
    case(load) 
      8'b00000001: R0 = data_in;
      8'b00000010: R1 = data_in;
      8'b00000100: R2 = data_in;
      8'b00001000: R3 = data_in;
      8'b00010000: R4 = data_in;
      8'b00100000: R5 = data_in;
      8'b01000000: R6 = data_in;
      8'b10000000: R7 = data_in;
      default: ;
    endcase
  end

  always @(*) begin //combination block of the multiplexer for output
    case(readnum_h)
      8'b00000001: data_out = R0;
      8'b00000010: data_out = R1;
      8'b00000100: data_out = R2;
      8'b00001000: data_out = R3;
      8'b00010000: data_out = R4;
      8'b00100000: data_out = R5;
      8'b01000000: data_out = R6;
      8'b10000000: data_out = R7;
      default: data_out = 16'bxxxxxxxxxxxxxxxx;
    endcase
  end

    

endmodule
