/*
CPEN 311 Lab 1, statemachine module
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Takes player scores, pcard3 as inputs and ouputs the correct load signals or win lights depending on the proper state. State machines are controlled on slow_clock.
*/

`define state_player1 3'b001
`define state_dealer1 3'b010
`define state_player2 3'b011
`define state_dealer2 3'b100
`define state_final 3'b101

module statemachine(input logic slow_clock, input logic resetb,
                    input logic [3:0] dscore, input logic [3:0] pscore, input logic [3:0] pcard3,
                    output logic load_pcard1, output logic load_pcard2, output logic load_pcard3,
                    output logic load_dcard1, output logic load_dcard2, output logic load_dcard3,
                    output logic player_win_light, output logic dealer_win_light);

    reg [2:0] present_state, next_state;
    reg [5:0] load_instruction;

    //Bus created to hold all outputs
    assign {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = load_instruction;

    //next state logic 
    always_comb begin 

        case (present_state) 
            `state_player1: next_state = `state_dealer1;
            `state_dealer1: next_state = `state_player2;
            `state_player2: next_state = `state_dealer2;
            `state_dealer2: next_state = `state_final;
            `state_final: next_state = `state_final;
            default: next_state = 3'bxxx;
        endcase

    end
    
    //sequential block for changing state (Flip Flop)
    always_ff @(posedge slow_clock) begin 
        //Check for asynchronous, low reset 
        if (~resetb)  
            present_state <= `state_player1;
        
        //Go to next state
        else
            present_state <= next_state;

    end

    //state output logic
    always_comb begin
         
        case (present_state)  
            `state_player1: load_instruction = 6'b100000; 
            `state_dealer1: load_instruction = 6'b000100; 
            `state_player2: load_instruction = 6'b010000; 
            `state_dealer2: load_instruction = 6'b000010; 
            `state_final: load_instruction = 6'b000000;
            default: load_instruction = 6'bxxxxxx;
        endcase
        

    end


endmodule

