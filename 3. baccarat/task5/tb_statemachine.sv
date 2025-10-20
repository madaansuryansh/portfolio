/*
CPEN 311 Lab 1, statemachine testbench
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Testing all state transitions and state outputs (all ways to reach each state are tested)
*/

`define state_player1 3'b001
`define state_dealer1 3'b010
`define state_player2 3'b011
`define state_dealer2 3'b100
`define state_decision1 3'b101
`define state_decision2 3'b110
`define state_final 3'b111

module tb_statemachine();

    reg tb_slow_clock;
    reg tb_resetb;
    reg [3:0] tb_dscore; 
    reg [3:0] tb_pscore; 
    reg [3:0] tb_pcard3;
    wire tb_load_pcard1; 
    wire tb_load_pcard2; 
    wire tb_load_pcard3;
    wire tb_load_dcard1; 
    wire tb_load_dcard2; 
    wire tb_load_dcard3;
    wire tb_player_win_light;
    wire tb_dealer_win_light;

    reg err;
    
    statemachine DUT(.slow_clock(tb_slow_clock), .resetb(tb_resetb),
                    .dscore(tb_dscore), .pscore(tb_pscore), .pcard3(tb_pcard3),
                    .load_pcard1(tb_load_pcard1), .load_pcard2(tb_load_pcard2), .load_pcard3(tb_load_pcard3),
                    .load_dcard1(tb_load_dcard1), .load_dcard2(tb_load_dcard2), .load_dcard3(tb_load_dcard3),
                    .player_win_light(tb_player_win_light), .dealer_win_light(tb_dealer_win_light));

    
    //task checker for checking if correct loads and win lights are set. 
    task statemachine_checker;
        
        input load_pcard1_expected, load_dcard1_expected, load_pcard2_expected, load_dcard2_expected, load_pcard3_expected, load_dcard3_expected;
        input player_win_light_expected, dealer_win_light_expected;
        input [3:0] state_expected;

        begin 
                
            if (tb_statemachine.DUT.load_pcard1 != load_pcard1_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_statemachine.DUT.load_pcard1, load_pcard1_expected);
            end

            if (tb_statemachine.DUT.load_dcard1 != load_dcard1_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_statemachine.DUT.load_dcard1, load_dcard1_expected);
            end

            if (tb_statemachine.DUT.load_pcard2 != load_pcard2_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_statemachine.DUT.load_pcard2, load_pcard2_expected);
            end

            if (tb_statemachine.DUT.load_dcard2 != load_dcard2_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_statemachine.DUT.load_dcard2, load_dcard2_expected);
            end

            if (tb_statemachine.DUT.load_pcard3 != load_pcard3_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_statemachine.DUT.load_pcard3, load_pcard3_expected);
            end

            if (tb_statemachine.DUT.load_dcard3 != load_dcard3_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_statemachine.DUT.load_dcard3, load_dcard3_expected);
            end

            if (tb_statemachine.DUT.player_win_light != player_win_light_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_statemachine.DUT.player_win_light, player_win_light_expected);
            end

            if (tb_statemachine.DUT.dealer_win_light != dealer_win_light_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_statemachine.DUT.dealer_win_light, dealer_win_light_expected);
            end
            
            if (tb_statemachine.DUT.present_state != state_expected)begin 
                err = 1'b1;
                $display("output is %b, expected %b", tb_statemachine.DUT.present_state, state_expected);
            end

        end

    endtask
    

    initial begin 

        tb_slow_clock = 1'b0;

        //Test 1 (player wins after 4 cards dealt with score of 9) 

            $display("Test 1");
            //loading values for outputs
            tb_pscore = 4'd5;
            tb_dscore = 4'd7;
            tb_pcard3 = 4'd2; #10;
            
            //asserting reset
            tb_resetb = 1'b0; #10;
            tb_slow_clock = 1'b1; #10;

            tb_resetb = 1'b1; 
            tb_slow_clock = 1'b0; #10;

            statemachine_checker(1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `state_player1);

        
            //Checking transition: state_player1 -> state_dealer1
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            statemachine_checker(1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `state_dealer1);

            //Checking transition: state_dealer1 -> state_player2
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            statemachine_checker(1'b0, 1'b0 , 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `state_player2);

            //Checking transition: state_player2 -> state_dealer2
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, `state_dealer2);

            //Checking transition state_dealer2 -> state_decision1
            tb_pscore = 4'd9;
            tb_dscore = 4'd6;

            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `state_decision1);

            //Checking transition state_decision1 -> state_final
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, `state_final);

        //Test 2 (dealer wins after 4 cards dealt with score of 7, no 3rd cards dealt) 
        //pscore and dscore < 8 and dscore > 5 and pscore > 5

            $display("Test 2");

            //asserting reset
            tb_resetb = 1'b0; #10;
            tb_slow_clock = 1'b1; #10;

            tb_resetb = 1'b1; 
            tb_slow_clock = 1'b0; #10;


            //Checking transition: state_player1 -> state_decision1
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
        
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
                //setting scores for player and dealer
                tb_pscore = 4'd6;
                tb_dscore = 4'd7;

            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            //Checking transition state_decision1 -> state_final
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `state_final);


        //Test 3 (player wins after 5 cards dealt, player gets third card. Dealer has a score of 6 or 7)
        //pscore and dscore < 8 and pscore < 6

            $display("Test 3");

            //asserting reset
            tb_resetb = 1'b0; #10;
            tb_slow_clock = 1'b1; #10;

            tb_resetb = 1'b1; 
            tb_slow_clock = 1'b0; #10;


            //Checking transition: state_player1 -> state_decision1
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
        
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
                //setting scores for player and dealer
                tb_pscore = 4'd4;
                tb_dscore = 4'd7;

            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, `state_decision1);

            //Checking transition state_decision1 -> state_decision2
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_pcard3 = 4'd4;
            tb_pscore = 4'd8;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, `state_decision2);

            //Checking transition state_decision2 -> state_final
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, `state_final);


        //Test 4 (dealer wins after 5 cards dealt, dealer gets 3rd card and player doesn't. Player has a score 6 or 7)
        //pscore and dscore < 8 and dscore < 6 and pscore > 5

            $display("Test 4");

            //asserting reset
            tb_resetb = 1'b0; #10;
            tb_slow_clock = 1'b1; #10;

            tb_resetb = 1'b1; 
            tb_slow_clock = 1'b0; #10;


            //Checking transition: state_player1 -> state_decision1
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
        
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
                //setting scores for player and dealer
                tb_pscore = 4'd6;
                tb_dscore = 4'd2;

            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
        
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, `state_decision1);

            //Checking transition state_decision1 -> state_final
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_dscore = 4'd8;
            
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, `state_final);

        //Test 5 
        //Player and dealer get a third card. Rule: Banker score = 6, Player third card = 6 or 7. Dealer won.

            $display("Test 5");

            //asserting reset
            tb_resetb = 1'b0; #10;
            tb_slow_clock = 1'b1; #10;

            tb_resetb = 1'b1; 
            tb_slow_clock = 1'b0; #10;


            //Checking transition: state_player1 -> state_decision1
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
        
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
                //setting scores for player and dealer
                tb_pscore = 4'd4;
                tb_dscore = 4'd6;

            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, `state_decision1);

            //Checking transition state_decision1 -> state_decision2
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_pcard3 = 4'd7;
            tb_pscore = 4'd1; #5;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, `state_decision2);

            //Checking transition state_decision2 -> state_final
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_dscore = 4'd8; #5;
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `state_final);

        //Test 6: Player and dealer get a third card. Rule: Banker score = 5, Player's third card = [4,7]. Tie.

            $display("Test 6");

            //asserting reset
            tb_resetb = 1'b0; #10;
            tb_slow_clock = 1'b1; #10;

            tb_resetb = 1'b1; 
            tb_slow_clock = 1'b0; #10;


            //Checking transition: state_player1 -> state_decision1
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
        
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
                //setting scores for player and dealer
                tb_pscore = 4'd2;
                tb_dscore = 4'd5;

            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, `state_decision1);

            //Checking transition state_decision1 -> state_decision2
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_pcard3 = 4'd5;
            tb_pscore = 4'd7;
            
            
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, `state_decision2);

            //Checking transition state_decision2 -> state_final
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_dscore = 4'd7; #5;
            
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, `state_final);

        //Test 7: Player and dealer get a third card. Rule: Banker score = 4, Player's third card = [2,7]. Dealer won

            $display("Test 7");

            //asserting reset
            tb_resetb = 1'b0; #10;
            tb_slow_clock = 1'b1; #10;

            tb_resetb = 1'b1; 
            tb_slow_clock = 1'b0; #10;


            //Checking transition: state_player1 -> state_decision1
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
        
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
                //setting scores for player and dealer
                tb_pscore = 4'd5;
                tb_dscore = 4'd4;

            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, `state_decision1);

            //Checking transition state_decision1 -> state_decision2
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_pcard3 = 4'd3;
            tb_pscore = 4'd8;
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, `state_decision2);

            //Checking transition state_decision2 -> state_final
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_dscore = 4'd9; #5;
            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `state_final);

        //Test 8: Player and dealer gets a third card. Rule: Banker score = 3, Player's third card != 8. Dealer won

            $display("Test 8");

            //asserting reset
            tb_resetb = 1'b0; #10;
            tb_slow_clock = 1'b1; #10;

            tb_resetb = 1'b1; 
            tb_slow_clock = 1'b0; #10;


            //Checking transition: state_player1 -> state_decision1
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
        
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
                //setting scores for player and dealer
                tb_pscore = 4'd1;
                tb_dscore = 4'd3;

            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, `state_decision1);

            //Checking transition state_decision1 -> state_decision2
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_pcard3 = 4'd11;
            tb_pscore = 4'd1;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, `state_decision2);

            //Checking transition state_decision2 -> state_final
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_dscore = 4'd6;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, `state_final);

        //Test 9: Player and dealer get a third card. Rule: Banker score = [0,2]. Player won

            $display("Test 9");

            //asserting reset
            tb_resetb = 1'b0; #10;
            tb_slow_clock = 1'b1; #10;

            tb_resetb = 1'b1; 
            tb_slow_clock = 1'b0; #10;


            //Checking transition: state_player1 -> state_decision1
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
        
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;
            
                //setting scores for player and dealer
                tb_pscore = 4'd4;
                tb_dscore = 4'd0;

            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, `state_decision1);

            //Checking transition state_decision1 -> state_decision2
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_pcard3 = 4'd5;
            tb_pscore = 4'd9;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, `state_decision2);

            //Checking transition state_decision2 -> state_final
            tb_slow_clock = 1'b1; #10;
            tb_slow_clock = 1'b0; #10;

            tb_dscore = 4'd0;

            statemachine_checker(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, `state_final);

        //Message for checking if cases passed or failed
        if(err)
            $display("Some cases FAILED :(");
        else
            $display("All cases PASSED :)");
            
    end
    

endmodule
