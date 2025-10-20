/*
CPEN 311 Lab 1, datapath module 
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Takes load_card inputs from statemachine controller and sets corresponding scores, HEX card display, and LED score display. 
        Done synchronously with slow_clock.
*/

module datapath(input logic slow_clock, input logic fast_clock, input logic resetb,
                input logic load_pcard1, input logic load_pcard2, input logic load_pcard3,
                input logic load_dcard1, input logic load_dcard2, input logic load_dcard3,
                output logic [3:0] pcard3_out,
                output logic [3:0] pscore_out, output logic [3:0] dscore_out,
                output logic [6:0] HEX5, output logic [6:0] HEX4, output logic [6:0] HEX3,
                output logic [6:0] HEX2, output logic [6:0] HEX1, output logic [6:0] HEX0);

    // regs and wires (internal signals)
    wire [3:0] new_card;
    wire [3:0] PCard1;
    wire [3:0] PCard2;
    wire [3:0] PCard3;
    wire [3:0] DCard1;
    wire [3:0] DCard2;
    wire [3:0] DCard3;

    // intantiations

    //dealcard outputs random playing card
    dealcard DEL (.clock(fast_clock), .resetb(resetb), .new_card(new_card));
    
    //6 registers to load new cards into players 
    reg4 PC1 (.new_card(new_card), .load_card(load_pcard1), .reset(resetb), .slow_clock(slow_clock), .out_card(PCard1));
    reg4 PC2 (.new_card(new_card), .load_card(load_pcard2), .reset(resetb), .slow_clock(slow_clock), .out_card(PCard2));
    reg4 PC3 (.new_card(new_card), .load_card(load_pcard3), .reset(resetb), .slow_clock(slow_clock), .out_card(PCard3));
    reg4 DC1 (.new_card(new_card), .load_card(load_dcard1), .reset(resetb), .slow_clock(slow_clock), .out_card(DCard1));
    reg4 DC2 (.new_card(new_card), .load_card(load_dcard2), .reset(resetb), .slow_clock(slow_clock), .out_card(DCard2));
    reg4 DC3 (.new_card(new_card), .load_card(load_dcard3), .reset(resetb), .slow_clock(slow_clock), .out_card(DCard3));

    //6 hex displays for each card
    card7seg PSEG1 (.card(PCard1), .seg7(HEX0));
    card7seg PSEG2 (.card(PCard2), .seg7(HEX1));
    card7seg PSEG3 (.card(PCard3), .seg7(HEX2));
    card7seg DSEG1 (.card(DCard1), .seg7(HEX3));
    card7seg DSEG2 (.card(DCard2), .seg7(HEX4));
    card7seg DSEG3 (.card(DCard3), .seg7(HEX5));

    //calculates total score
    scorehand PSCR (.card1(PCard1), .card2(PCard2), .card3(PCard3), .total(pscore_out));
    scorehand DSCR (.card1(DCard1), .card2(DCard2), .card3(DCard3), .total(dscore_out));

    assign pcard3_out = PCard3;

endmodule

// module for player card registers. Takes input of new_card and outputs that card when load is set and rising edge of slow_clock seen
module reg4 (input logic [3:0] new_card, input logic load_card, input logic reset, input logic slow_clock, 
             output logic [3:0] out_card);
    
    always @(posedge slow_clock)begin 

        //synchronous, active low reset 
        if (reset == 0)
            out_card <= 4'd0;

        //register enabled with load_card signals
        else if (load_card) 
            out_card <= new_card;

    end

endmodule

