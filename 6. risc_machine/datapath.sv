module datapath(writenum, write, readnum, clk, loada, loadb, loadc, loads, vsel, asel, bsel, shift, status_out, ALUop, sximm5, mdata, sximm8, PC, C); // very similar to lab5 datapath with only a few modifications

  input asel, bsel, clk, loada, loadb, loadc, loads, write; // inputs and outputs of the datapath as seen in figure 1 of the PDF
  input [1:0] ALUop, shift, vsel;
  input [15:0] sximm5, mdata, sximm8; // new inputs for lab6
  input [7:0] PC;
  input [2:0] writenum, readnum;
  output reg [2:0] status_out;
  output reg [15:0] C; // new output for lab6

  reg [15:0] data_in; // regs created to connect different modules/blocks together
  reg [15:0] data_out;
  reg [15:0] Aout;
  reg [15:0] in;
  reg [15:0] sout;
  reg [15:0] Ain;
  reg [15:0] Bin;
  reg [15:0] out;
  reg [2:0] status, opcode;
  reg [1:0] op, nsel;
  reg s, reset, w;
  
  // intantiating all blocks
  vmux U0(mdata, sximm8, PC, C, data_in, vsel); // this module was changed for lab6
  regfile REGFILE(data_in, writenum, write, readnum, clk, data_out); 
  aff U2(data_out, loada, clk , Aout);
  bff U3(data_out, loadb, clk, in);
  shifter U4(in, shift, sout);
  amux U5(Aout, asel, Ain);
  bmux U6(sout, bsel, Bin, sximm5);
  ALU U7(Ain, Bin, ALUop, out, status); // this module was changed for lab6
  cff U8(out, loadc, clk, C);
  sff U9(status, loads, clk, status_out); // this module was changed for lab6

endmodule

module vmux(mdata, sximm8, PC, C, data_in, vsel); //initial multiplexer which controls what value is being sent into the register file
  input [15:0] mdata, sximm8, C;
  input [1:0] vsel;
  input [7:0] PC;
  output reg [15:0] data_in;

  always @(*) begin // combination block of the mux with 4 select options
    case(vsel)
      2'b00: data_in = mdata;
      2'b01: data_in = sximm8;
      2'b10: data_in = {8'b0, PC};
      2'b11: data_in = C;
      default: data_in = 16'bxxxxxxxxxxxxxxxx;
    endcase
  end
endmodule

module amux(Aout, asel, Ain); // multiplexer for Ain 
  input [15:0] Aout;
  input asel;
  output reg [15:0] Ain;

  always @(*) begin // mux is dependent on asel
    case(asel)
      0: Ain = Aout;
      1: Ain = 16'b0;
      default: Ain = 16'bxxxxxxxxxxxxxxxx;
    endcase
  end
endmodule

module bmux(sout, bsel, Bin, sximm5); // multiplexer for Bin
  input [15:0] sout, sximm5;
  input bsel;
  output reg [15:0] Bin;

  always @(*) begin // mux is depended on bsel
    case(bsel)
      0: Bin = sout;
      1: Bin = sximm5;
      default: Bin = 16'bxxxxxxxxxxxxxxxx;
    endcase
  end
endmodule

module aff(data_out, loada, clk, Aout); // load enable flip flop for A
  input [15:0] data_out;
  input loada, clk;
  output reg [15:0] Aout;
  always @(posedge clk) begin
    case(loada)
      1: Aout = data_out;
      0: ;
      default: Aout = 16'bxxxxxxxxxxxxxxxx;
    endcase
  end
endmodule

module bff(data_out, loadb, clk, in); // load enable flip flop for B
  input [15:0] data_out;
  input loadb, clk;
  output reg [15:0] in;
  always @(posedge clk) begin
    case(loadb)
      1: in = data_out;
      0: ;
      default: in = 16'bxxxxxxxxxxxxxxxx;
    endcase
  end
endmodule

module cff(out, loadc, clk, C); // final load enable flip flop which sends the value after ALU to datapath_out
  input [15:0] out;
  input loadc, clk;
  output reg [15:0] C;
  always @(posedge clk) begin
    case(loadc)
      1: C = out; // changed datapath_out to C
      0: ;
      default: C = 16'bxxxxxxxxxxxxxxxx;
    endcase
  end
endmodule

module sff(status, loads, clk, status_out); // status register which outputs the Z N or V flags
  input [2:0] status; // holds the value of all flags
  input loads, clk;
  output reg [2:0] status_out;
  always @(posedge clk) begin // combination block which outputs the flags
    case(loads)
      1: status_out = status;
      0: ;
      default: status_out = 3'bxxx;
    endcase
  end
endmodule
