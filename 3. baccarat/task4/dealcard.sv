/*
CPEN 311 Lab 1, dealcard 
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Generates a random card on each fast_clock to be loaded into registers
*/

// Lucky you! We are giving you this code for free. There is nothing
// here you need to add or write.

module dealcard(input logic clock, input resetb, output logic [3:0] new_card);

logic [3:0] dealer_card;

always_ff @(posedge clock)
  if (resetb == 0)
     dealer_card <= 1;  
  else
     if (dealer_card == 13)
	     dealer_card <= 1;
	  else 
	     dealer_card++;

assign new_card = dealer_card;

endmodule

