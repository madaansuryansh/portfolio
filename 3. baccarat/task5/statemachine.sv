/*
CPEN 311 Lab 1, statemachine module
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Takes player scores, pcard3 as inputs and ouputs the correct load signals or win lights depending on the proper state. State machines are controlled on slow_clock.
*/

`define state_player1 3'b001
`define state_dealer1 3'b010
`define state_player2 3'b011
`define state_dealer2 3'b100
`define state_decision1 3'b101
`define state_decision2 3'b110
`define state_final 3'b111

module statemachine(input logic slow_clock, input logic resetb,
                    input logic [3:0] dscore, input logic [3:0] pscore, input logic [3:0] pcard3,
                    output logic load_pcard1, output logic load_pcard2, output logic load_pcard3,
                    output logic load_dcard1, output logic load_dcard2, output logic load_dcard3,
                    output logic player_win_light, output logic dealer_win_light);
                    
    reg [2:0] present_state;
    reg [2:0] next_state;
    reg [5:0] load_instruction;
    reg game_over_flag;
    
    //Bus created to hold all load outputs
    assign {load_pcard1, load_pcard2, load_pcard3, load_dcard1, load_dcard2, load_dcard3} = load_instruction;

    //Combinational next state logic block
    always_comb begin
        
        case (present_state)
            `state_player1: next_state = `state_dealer1;
            `state_dealer1: next_state = `state_player2;
            `state_player2: next_state = `state_dealer2;
            `state_dealer2: next_state = `state_decision1;
            //if no 3rd card needs to be dealt, go to the final state
            `state_decision1:
            if (game_over_flag) 
                next_state = `state_final;
            else 
                next_state = `state_decision2;
                
            `state_decision2: next_state = `state_final;
            `state_final: next_state = `state_final;
            default: next_state = 3'bxxx;
        endcase

    end

    //Sequential block for changing state (Flip Flop)
    always_ff @(posedge slow_clock) begin 
            
        //Check for asynchronous, low reset 
        if (~resetb) 
            present_state <= `state_player1;
        //Otherwise state gets next state
        else 
            present_state <= next_state;
    end

    //Output logic Block
    always_comb begin
        
        case (present_state)
            `state_player1: begin
                load_instruction = 6'b100000;
                 
                player_win_light = 1'b0;
                dealer_win_light = 1'b0;
                game_over_flag = 1'b0;
            end
            `state_dealer1: begin 
                load_instruction = 6'b000100;
                
                player_win_light = 1'b0;
                dealer_win_light = 1'b0;
                game_over_flag = 1'b0; 
            end
            `state_player2: begin
                load_instruction = 6'b010000;
                 
                player_win_light = 1'b0;
                dealer_win_light = 1'b0;
                game_over_flag = 1'b0;
            end
            `state_dealer2: begin 
                load_instruction = 6'b000010;
                 
                player_win_light = 1'b0;
                dealer_win_light = 1'b0;
                game_over_flag = 1'b0;
            end
            `state_decision1: begin 

                //Check if player or dealer get a 3rd card
                if (pscore < 8 && dscore < 8 )

                    //Player gets 3rd card
                    if (pscore < 6) begin
                        load_instruction = 6'b001000;

                        player_win_light = 1'b0;
                        dealer_win_light = 1'b0;
                        game_over_flag = 1'b0;
                    end
                    
                    //Player does not get a 3rd card. Check if the dealer does
                    else 
                        //dealer gets a 3rd card
                        if (dscore < 4'd6) begin 
                            load_instruction = 6'b000001;

                            player_win_light = 1'b0;
                            dealer_win_light = 1'b0;
                            
                            //signal that the game is over
                            game_over_flag = 1'b1;
                        end 

                        //neither get a card, game over.
                        else begin 
                            load_instruction = 6'b000000;

                            player_win_light = 1'b0;
                            dealer_win_light = 1'b0;
                            
                            //signal that the game is over
                            game_over_flag = 1'b1;
                        end

                //Either the player won, dealer won, or tie    
                else begin 
                    load_instruction = 6'b000000;

                    player_win_light = 1'b0;
                    dealer_win_light = 1'b0;

                    //signal that the game is over
                    game_over_flag = 1'b1;
                end
            
            end

            //decision based on player getting a third card
            `state_decision2: begin 

                if (dscore == 4'd6 && ((pcard3 == 4'd6) || (pcard3 == 4'd7))) begin 
                    //dealer gets a 3rd card if dealer score is 6 and pcard3 is 6 or 7
                    load_instruction = 6'b000001;

                    player_win_light = 1'b0;
                    dealer_win_light = 1'b0;
                    game_over_flag = 1'b0;
                end

                else if (dscore == 4'd5 && ((pcard3 < 4'd8) && (pcard3 > 4'd3))) begin 
                    //dealer gets a 3rd card if dealer score is 5 and pcard3 is [4,7]
                    load_instruction = 6'b000001;

                    player_win_light = 1'b0;
                    dealer_win_light = 1'b0;
                    game_over_flag = 1'b0;
                end
                    
                else if (dscore == 4'd4 && ((pcard3 < 4'd8) && (pcard3 > 4'd1))) begin 
                    //dealer gets a 3rd card if dealer score is 4 and pcard3 [2,7]
                    load_instruction = 6'b000001;

                    player_win_light = 1'b0;
                    dealer_win_light = 1'b0;
                    game_over_flag = 1'b0;
                end

                else if (dscore == 4'd3 && pcard3 != 8) begin
                    //dealer gets a 3rd card if dealer score is 3 and pcard3 is anything but 8
                    load_instruction = 6'b000001;

                    player_win_light = 1'b0;
                    dealer_win_light = 1'b0;
                    game_over_flag = 1'b0;
                end
                    
                else if (dscore < 3) begin
                    //dealer gets a 3rd card if bankers score is 0, 1, or 2
                    load_instruction = 6'b000001;

                    player_win_light = 1'b0;
                    dealer_win_light = 1'b0;
                    game_over_flag = 1'b0;
                end
                    
                else begin 
                    //dealer does not get a 3rd card and go to next state
                    load_instruction = 6'b000000;

                    player_win_light = 1'b0;
                    dealer_win_light = 1'b0;
                    game_over_flag = 1'b0;
                end

            end
            
            `state_final: begin

                //check who won and turn on LED's 
                if (pscore > dscore) begin 
                    //player won 
                    load_instruction = 6'b000000;

                    player_win_light = 1'b1;
                    dealer_win_light = 1'b0;
                    game_over_flag = 1'b0;
                end

                else if (pscore == dscore) begin
                    //tie
                    load_instruction = 6'b000000;
                    
                    player_win_light = 1'b1;
                    dealer_win_light = 1'b1;
                    game_over_flag = 1'b0;
                end

                else begin 
                    //dealer won 
                    load_instruction = 6'b000000;

                    player_win_light = 1'b0;
                    dealer_win_light = 1'b1;
                    game_over_flag = 1'b0;
                end
            end

            default: begin
                load_instruction = 6'bxxxxxx;
                player_win_light = 1'bx;
                dealer_win_light = 1'bx;
                game_over_flag = 1'bx;
            end

        endcase
    end




endmodule

