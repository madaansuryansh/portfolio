/*
CPEN 311 Lab 1, card7seg module
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Take input of 4 bit number and display corresponding HEX card value
*/

`define blank 7'b1111111 
`define ace 7'b0001000
`define two 7'b0100100
`define three 7'b0110000  
`define four 7'b0011001 
`define five 7'b0010010  
`define six 7'b0000010 
`define seven 7'b1111000 
`define eight 7'b0000000 
`define nine 7'b0010000 
`define zero 7'b1000000
`define jack 7'b1100001
`define queen 7'b0011000
`define king 7'b0001001

module card7seg(input logic [3:0] card, output logic [6:0] seg7);

      // combinational block for 7-seg display
      always_comb begin 
      case (card)
         4'b0000: seg7 = `blank; 
         4'b0001: seg7 = `ace;
 			4'b0010: seg7 = `two; 
			4'b0011: seg7 = `three;  
         4'b0100: seg7 = `four;  
			4'b0101: seg7 = `five;  
			4'b0110: seg7 = `six; 
			4'b0111: seg7 = `seven; 
			4'b1000: seg7 = `eight; 
			4'b1001: seg7 = `nine; 
         4'b1010: seg7 = `zero;
         4'b1011: seg7 = `jack;
         4'b1100: seg7 = `queen;
         4'b1101: seg7 = `king;
         4'b1110: seg7 = `blank;
         4'b1111: seg7 = `blank;
         default: seg7 = 7'bxxxxxxx;
      endcase
   end

endmodule

