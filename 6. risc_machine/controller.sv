`define waiting 4'b0000 
`define decoding 4'b0001
`define MOV_im 4'b0010
`define MOV_r 4'b0011
`define getA 4'b0100
`define getB 4'b0101
`define ADD 4'b0110
`define SUB 4'b0111
`define AND 4'b1000
`define NOT 4'b1001
`define write_back 4'b1010

module controller(s, reset, clk, opcode, op, w, nsel, write, loada, loadb, loadc, loads, vsel, asel, bsel); // state machine module
  input s, reset, clk; // inputs and outputs
  input [2:0] opcode;
  input [1:0] op;
  output reg asel, bsel, loada, loadb, loadc, loads, write; // inputs and outputs of the datapath as seen in figure 1 of the PDF
  output reg [2:0] nsel;
  output reg [1:0] vsel;
  output reg w; // output of FSM when in waiting state
  reg [3:0] state = 4'b0000;
  reg [11:0] instr;

  always_ff @(posedge clk) begin // flip flop to control change in states
    if (reset) begin
      state = 4'b0000;
    end
    else begin
      case(state)
        `waiting: case(s)
          1: state = `decoding;
          default: state = `waiting;
        endcase
        `decoding: casex({opcode, op}) // decoding state can split into multiple paths depending on the opcode and op from the instruction register
          5'b11010: state = `MOV_im;
          5'b11000: state = `getB;
          5'b10111: state = `getB;
          5'b101xx: state = `getA;
          default: state = 4'bxxxx;
        endcase
        `getA: state = `getB;
        `MOV_im: state = `waiting;
        `getB: case(opcode) // after loading the B value, different paths are possible due to the opcode (+, -, & or ~)
          3'b110: state = `MOV_r;
          3'b101: case(op)
            2'b00: state = `ADD;
            2'b01: state = `SUB;
            2'b10: state = `AND;
            2'b11: state = `NOT;
            default: state = 4'bxxxx;
          endcase
          default: state = 4'bxxxx;
        endcase
        `SUB: state = `waiting;
        `write_back: state = `waiting;
        default: state = `write_back; // most of the paths lead to writing back the final value into a new register
      endcase
    end
  end

  always @(*) begin // combinational block to control the outputs of each state
    case(state)
      `waiting: instr = 13'b0000000000001;
      `decoding: instr = 13'b0000000000000;
      `getA: instr = 13'b0010000100000;
      `getB: instr = 13'b0001000001000;
      `MOV_im: instr = 13'b0000001100010;
      `MOV_r: instr = 13'b1000110000000;
      `ADD: instr = 13'b0000110000000;
      `SUB: instr = 13'b0000010000000;
      `AND: instr = 13'b0000110000000;
      `NOT: instr = 13'b1000110000000;
      `write_back: case(op)
        2'b01: instr = 13'b000000000000;
        default: instr = 13'b0000001010110;
      endcase
      default: instr = 13'bxxxxxxxxxxxxx;
    endcase
  end

  assign {asel, bsel, loada, loadb, loadc, loads, write, nsel, vsel, w} = instr; // concactation of multiple outputs into 1 output since a combinational block can only have one output
endmodule
