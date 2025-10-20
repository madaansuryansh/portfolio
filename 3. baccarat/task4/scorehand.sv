/*
CPEN 311 Lab 1, scorehand 
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Takes input of 3 4 bit card numbers and outpute the sum based on Baccarat (%10) calculations.
*/

module scorehand(input logic [3:0] card1, input logic [3:0] card2, input logic [3:0] card3, output logic [3:0] total);

    //registers to store the score of each card and total score
    reg [3:0] card1val; 
    reg [3:0] card2val;
    reg [3:0] card3val;
    reg [4:0] total_temp;
    
    
    //if card value is greater than 9, gets a score of zero 
    always_comb begin
        if (card1 > 4'd9)  
            card1val = 4'd0; 
        else
            card1val = card1;
  
        if (card2 > 4'd9) 
            card2val = 4'd0;
        else
            card2val = card2;

        if (card3 > 4'd9) 
            card3val = 4'd0;
        else
            card3val = card3;

        
    end
    
    //find the total of the cards 
    always_comb begin

        //adds the value of each card and calculates score
        total_temp = (card1val[3:0] + card2val[3:0] + card3val[3:0]);

        //check whether the score is larger than 10 and correct accordingly 
        if (total_temp >= 5'd10 && total_temp < 5'd20)
            total = (total_temp - 5'd10) & 4'b1111;
            
        else if (total_temp >= 5'd20)
            total = (total_temp - 5'd20) & 4'b1111;
           
        else 
            total = total_temp[3:0];

    end
    
endmodule

