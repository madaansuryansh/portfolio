module cpu(clk,reset,s,load,in,out,N,V,Z,w,); // module which includes all other modules (main)
  input clk, reset, s, load; // inputs and outputs
  input [15:0] in;
  output [15:0] out;
  output N, V, Z, w;

  reg asel, bsel, clk, loada, loadb, loadc, loads, write; // internal signals created for instantiation purposes
  reg [1:0] shift, vsel, op, ALUop;
  reg [15:0] sximm5, mdata, sximm8, C, instr1;
  reg [7:0] PC;
  reg [2:0] writenum, readnum, nsel, opcode, status_out;
  assign {N, V, Z} = status_out;
  assign out = C;

  datapath DP(writenum, write, readnum, clk, loada, loadb, loadc, loads, vsel, asel, bsel, shift, status_out, ALUop, sximm5, mdata, sximm8, PC, C); // instantiating all necessary modules
  Ri RI(in, load, instr1, clk); // instruction register
  idecoder ID(instr1, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum); // instruction decoder
  controller CT(s, reset, clk, opcode, op, w, nsel, write, loada, loadb, loadc, loads, vsel, asel, bsel); // state machine
  

endmodule

module Ri(in, load, instr1, clk); // instruction register
  input [15:0] in;
  input load, clk;
  output reg [15:0] instr1;

  always_ff @(posedge clk) begin // controlled by a clock and load input 
    case(load)
      1: instr1 = in;
      0: ;
      default: instr1 = 16'bxxxxxxxxxxxxxxx;
    endcase
  end
endmodule

module idecoder(instr1, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum); // instruction decoder

  input [15:0] instr1; // inputs and outputs
  input [2:0] nsel; 
  output reg [2:0] readnum, writenum;
  output wire [2:0] opcode;
  output wire [1:0] op, ALUop, shift;
  output reg [15:0] sximm5, sximm8;
  wire [2:0] Rn, Rd, Rm; // wires created for assigning 
  wire [7:0] imm8;
  wire [4:0] imm5;

  assign imm5 = instr1 [4:0]; // assign statements which store the necessary bits from the instruction register
  assign imm8 = instr1 [7:0];
  assign ALUop = instr1 [12:11];
  assign op = instr1 [12:11];
  assign shift = instr1 [4:3];
  assign opcode = instr1 [15:13];

  assign Rn = instr1 [10:8];
  assign Rd = instr1 [7:5];
  assign Rm = instr1 [2:0];

  always @(*) begin // combination block for writenum
    case(nsel)
      3'b001: writenum = Rm;
      3'b010: writenum = Rd;
      3'b100: writenum = Rn;
      default: writenum = 3'bxxx;
    endcase
  end

  always @(*) begin // combination block for readnum
    case(nsel)
      3'b001: readnum = Rm;
      3'b010: readnum = Rd;
      3'b100: readnum = Rn;
      default: readnum = 3'bxxx;
    endcase
  end

  always @(*) begin // combination block to provide the sign extend
    sximm8 [7:0] = imm8;
    sximm8 [15:8] = {8{imm8[7]}};
  end

  always @(*) begin // combination block to provide the sign extend
    sximm5 [4:0] = imm5;
    sximm5 [15:5] = {11{imm5[4]}};
  end
endmodule


      
