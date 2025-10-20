/*
CPEN 311 Lab 1, task 5 testbench (final testbench)
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Testing all Baccarat game cases. Checking all hexes and LEDs for proper outputs. 
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

module tb_task5();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 100,000 ticks (equivalent to "initial #100000 $finish();").


    reg tb_CLOCK_50;
    reg [3:0] tb_KEY; 
    wire [9:0] tb_LEDR;
    wire [6:0] tb_HEX5, tb_HEX4, tb_HEX3, tb_HEX2, tb_HEX1, tb_HEX0;
    reg err;

            
    task5 DUT (.CLOCK_50(tb_CLOCK_50), .KEY(tb_KEY), .LEDR(tb_LEDR),
               .HEX5(tb_HEX5), .HEX4(tb_HEX4), .HEX3(tb_HEX3),
               .HEX2(tb_HEX2), .HEX1(tb_HEX1), .HEX0(tb_HEX0));

    //Self-checking task for all HEX and LED outputs. 
    task task5_checker;
        
        input [6:0] HEX0_expected, HEX1_expected, HEX2_expected, HEX3_expected, HEX4_expected, HEX5_expected;
        input [9:0] LEDR_expected;
        
        begin 

            if (tb_task5.DUT.HEX0 != HEX0_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task5.DUT.HEX0, HEX0_expected);
            end

            if (tb_task5.DUT.HEX1 != HEX1_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task5.DUT.HEX1, HEX1_expected);
            end

            if (tb_task5.DUT.HEX2 != HEX2_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task5.DUT.HEX2, HEX2_expected);
            end

            if (tb_task5.DUT.HEX3 != HEX3_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task5.DUT.HEX3, HEX3_expected);
            end

            if (tb_task5.DUT.HEX4 != HEX4_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task5.DUT.HEX4, HEX4_expected);
            end

            if (tb_task5.DUT.HEX5 != HEX5_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task5.DUT.HEX5, HEX5_expected);
            end

            if (tb_task5.DUT.LEDR != LEDR_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task5.DUT.LEDR, LEDR_expected);
            end

        end
    
    endtask
    
    initial begin 
        
        tb_CLOCK_50 = 0;
        #10;
        
        forever begin 
            tb_CLOCK_50 = 1; #10;
            tb_CLOCK_50 = 0; #10;
        end

    end

    initial begin

        err = 1'b0;

        //Test 1: Testing Dealer won, no third cards drawn

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = 6
            force DUT.dp.DEL.new_card = 4'd6;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 6
            force DUT.dp.DEL.new_card = 4'd6;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //plyaer's card = 4
            force DUT.dp.DEL.new_card = 4'd4;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 1:");
            task5_checker (`six, `four, `blank, `six, `two, `blank, 10'b10_1000_0000);


        //Test 2: No win after 2 cards. No third card for either. Tie between player and dealer.

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = 3
            force DUT.dp.DEL.new_card = 4'd3;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //plyaer's card = 4
            force DUT.dp.DEL.new_card = 4'd4;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 5
            force DUT.dp.DEL.new_card = 4'd5;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 2:");
            task5_checker (`three, `four, `blank, `two, `five, `blank, 10'b11_0111_0111);

        //Test 3: Player gets a third card. Banker does not get a third card. Player won. 

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = 1
            force DUT.dp.DEL.new_card = 4'd1;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 7
            force DUT.dp.DEL.new_card = 4'd7;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 4
            force DUT.dp.DEL.new_card = 4'd4;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = king
            force DUT.dp.DEL.new_card = 4'd13;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //Player's card = 4
            force DUT.dp.DEL.new_card = 4'd4;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 3:");
            task5_checker (`ace, `four, `four, `seven, `king, `blank, 10'b01_0111_1001);
            
        //Test 4: Player does not get a third card. Banker does get a third card. Dealer won.

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = 5
            force DUT.dp.DEL.new_card = 4'd5;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = ace
            force DUT.dp.DEL.new_card = 4'd1;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 3
            force DUT.dp.DEL.new_card = 4'd3;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 4:");
            task5_checker (`five, `ace, `blank, `two, `three, `two, 10'b10_0111_0110);

        //Test 5: Player and dealer get a third card. Rule: Banker score = 6, Player third card = 6 or 7. Player won.

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = ace
            force DUT.dp.DEL.new_card = 4'd1;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 3
            force DUT.dp.DEL.new_card = 4'd3;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 3
            force DUT.dp.DEL.new_card = 4'd3;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 6
            force DUT.dp.DEL.new_card = 4'd6;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 5
            force DUT.dp.DEL.new_card = 4'd5;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 5:");
            task5_checker (`ace, `two, `six, `three, `three, `five, 10'b01_0001_1001);
        
        //Test 5.1: Player gets a third card and dealer doesn't. Rule: Banker score = 6, Player third card != 6 or 7. Dealer won.

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = ace
            force DUT.dp.DEL.new_card = 4'd1;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 3
            force DUT.dp.DEL.new_card = 4'd3;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = ace
            force DUT.dp.DEL.new_card = 4'd1;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 3
            force DUT.dp.DEL.new_card = 4'd3;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 8
            force DUT.dp.DEL.new_card = 4'd8;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = no card

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 5.1:");
            task5_checker (`ace, `ace, `eight, `three, `three, `blank, 10'b10_0110_0000);
        
        //Test 6: Player and dealer get a third card. Rule: Banker score = 5, Player's third card = [4,7]. Tie.

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = ace
            force DUT.dp.DEL.new_card = 4'd1;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 3
            force DUT.dp.DEL.new_card = 4'd3;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 3
            force DUT.dp.DEL.new_card = 4'd3;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 5
            force DUT.dp.DEL.new_card = 4'd5;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 4
            force DUT.dp.DEL.new_card = 4'd4;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 6:");
            task5_checker (`ace, `three, `five, `two, `three, `four, 10'b11_1001_1001);

        //Test 6.1: Player gets a third card and dealer doesn't. Rule: Banker score = 5, Player's third card != [4,7]. Tie.

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = ace
            force DUT.dp.DEL.new_card = 4'd1;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 3
            force DUT.dp.DEL.new_card = 4'd3;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 3
            force DUT.dp.DEL.new_card = 4'd3;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 1
            force DUT.dp.DEL.new_card = 4'd1;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = no card

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 6.1:");
            task5_checker (`ace, `three, `ace, `two, `three, `blank, 10'b11_0101_0101);

        //Test 7: Player and dealer get a third card. Rule: Banker score = 4, Player's third card = [2,7]. Dealer won

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = 4
            force DUT.dp.DEL.new_card = 4'd4;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 10
            force DUT.dp.DEL.new_card = 4'd10;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 3
            force DUT.dp.DEL.new_card = 4'd3;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 4
            force DUT.dp.DEL.new_card = 4'd4;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 7:");
            task5_checker (`four, `zero, `three, `two, `two, `four, 10'b10_1000_0111);

        //Test 7.1: Player gets a third card and dealer doesn't. Rule: Banker score = 4, Player's third card != [2,7]. Tie.

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = 4
            force DUT.dp.DEL.new_card = 4'd4;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 10
            force DUT.dp.DEL.new_card = 4'd10;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = king
            force DUT.dp.DEL.new_card = 4'd13;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = no card

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 7.1:");
            task5_checker (`four, `zero, `king, `two, `two, `blank, 10'b11_0100_0100);

        //Test 8: Player and dealer gets a third card. Rule: Banker score = 3, Player's third card != 8. Player won

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = 3
            force DUT.dp.DEL.new_card = 4'd3;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = ace
            force DUT.dp.DEL.new_card = 4'd1;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = queen
            force DUT.dp.DEL.new_card = 4'd12;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = jack
            force DUT.dp.DEL.new_card = 4'd11;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 8:");
            task5_checker (`three, `two, `queen, `two, `ace, `jack, 10'b01_0011_0101);

        //Test 8.1: Player gets a third card and dealer doesn't. Rule: Banker score = 3, Player's third card = 8. Tie.

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = 3
            force DUT.dp.DEL.new_card = 4'd3;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = ace
            force DUT.dp.DEL.new_card = 4'd1;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = 8
            force DUT.dp.DEL.new_card = 4'd8;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = no card

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 8.1:");
            task5_checker (`three, `two, `eight, `two, `ace, `blank, 10'b11_0011_0011);

        //Test 9: Player and dealer get a third card. Rule: Banker score = [0,2]. Dealer won

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
        
            //player's card = 10
            force DUT.dp.DEL.new_card = 4'd10;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 2
            force DUT.dp.DEL.new_card = 4'd2;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = king
            force DUT.dp.DEL.new_card = 4'd13;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = jack
            force DUT.dp.DEL.new_card = 4'd11;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //player's card = queen
            force DUT.dp.DEL.new_card = 4'd12;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //dealer's card = 7
            force DUT.dp.DEL.new_card = 4'd7;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            //Deciding winner 
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test 9:");
            task5_checker (`zero, `king, `queen, `two, `jack, `seven, 10'b10_1001_0000);
            
        //Display message if tests passed or failed
        if (err)
            $display("Some cases FAILED :(");
        else 
            $display("All cases PASSED :)");
        $stop;

    end

endmodule
