/*
CPEN 311 Lab 1, task 4 testbench 
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Testing if first 4 player/dealer cards are dealt. 
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

module tb_task4();

    reg tb_CLOCK_50;
    reg [3:0] tb_KEY; 
    wire [9:0] tb_LEDR;
    wire [6:0] tb_HEX5, tb_HEX4, tb_HEX3, tb_HEX2, tb_HEX1, tb_HEX0;
    reg err;

            
    task4 DUT (.CLOCK_50(tb_CLOCK_50), .KEY(tb_KEY), .LEDR(tb_LEDR),
               .HEX5(tb_HEX5), .HEX4(tb_HEX4), .HEX3(tb_HEX3),
               .HEX2(tb_HEX2), .HEX1(tb_HEX1), .HEX0(tb_HEX0));

    //Self-checking task for all HEX and LED outputs. 
    task task4_checker;
        
        input [6:0] HEX0_expected, HEX1_expected, HEX2_expected, HEX3_expected, HEX4_expected, HEX5_expected;
        input [9:0] LEDR_expected;
        
        begin 

            if (tb_task4.DUT.HEX0 != HEX0_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task4.DUT.HEX0, HEX0_expected);
            end

            if (tb_task4.DUT.HEX1 != HEX1_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task4.DUT.HEX1, HEX1_expected);
            end

            if (tb_task4.DUT.HEX2 != HEX2_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task4.DUT.HEX2, HEX2_expected);
            end

            if (tb_task4.DUT.HEX3 != HEX3_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task4.DUT.HEX3, HEX3_expected);
            end

            if (tb_task4.DUT.HEX4 != HEX4_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task4.DUT.HEX4, HEX4_expected);
            end

            if (tb_task4.DUT.HEX5 != HEX5_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task4.DUT.HEX5, HEX5_expected);
            end

            if (tb_task4.DUT.LEDR != LEDR_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_task4.DUT.LEDR, LEDR_expected);
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

        //Test 1: Testing outputs from first 4 states

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
            
            $display("Test1.1: Checking reset state");
            task4_checker(`blank, `blank, `blank, `blank, `blank, `blank, 10'bxx_0000_0000);
        
            //player's card = 3
            force DUT.dp.DEL.new_card = 4'd3;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test1.2: Checking state_player1");
            task4_checker(`three, `blank, `blank, `blank, `blank, `blank, 10'bxx_0000_0011);

            //dealer's card = 1
            force DUT.dp.DEL.new_card = 4'd1;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test1.3: Checking state_dealer1");
            task4_checker(`three, `blank, `blank, `ace, `blank, `blank, 10'bxx_0001_0011);

            //plyaer's card = queen
            force DUT.dp.DEL.new_card = 4'd12;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test1.4: Checking state_player2");
            task4_checker(`three, `queen, `blank, `ace, `blank, `blank, 10'bxx_0001_0011);

            //dealer's card = 9
            force DUT.dp.DEL.new_card = 4'd9;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test1.5: Checking state_dealer2");
            task4_checker(`three, `queen, `blank, `ace, `nine, `blank, 10'bxx_0000_0011);

            //Testing if stops after four cards
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test1.6: Checking if no extra cards are dealt");
            task4_checker (`three, `queen, `blank, `ace, `nine, `blank, 10'bxx_0000_0011);


        //Test 2: Testing reset and outputs from first 4 states again

            //Assert Reset 
            tb_KEY[3] = 1'b0; #10
            tb_KEY[0] = 1'b1; #10;
        
            tb_KEY[3] = 1'b1; 
            tb_KEY[0] = 1'b0; #10;
            
            $display("Test2.1: Checking reset state");
            task4_checker(`blank, `blank, `blank, `blank, `blank, `blank, 10'bxx_0000_0000);
        
            //player's card = king
            force DUT.dp.DEL.new_card = 4'd13;
            
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test2.2: Checking state_player1");
            task4_checker(`king, `blank, `blank, `blank, `blank, `blank, 10'bxx_0000_0000);

            //dealer's card = 4
            force DUT.dp.DEL.new_card = 4'd4;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test2.3: Checking state_dealer1");
            task4_checker(`king, `blank, `blank, `four, `blank, `blank, 10'bxx_0100_0000);

            //plyaer's card = 7
            force DUT.dp.DEL.new_card = 4'd7;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test2.4: Checking state_player2");
            task4_checker(`king, `seven, `blank, `four, `blank, `blank, 10'bxx_0100_0111);

            //dealer's card = jack
            force DUT.dp.DEL.new_card = 4'd11;

            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test2.5: Checking state_dealer2");
            task4_checker(`king, `seven, `blank, `four, `jack, `blank, 10'bxx_0100_0111);

            //Testing if stops after four cards
            tb_KEY[0] = 1'b1; #10;
            tb_KEY[0] = 1'b0; #10;

            $display("Test2.7: Checking if no extra cards are dealt");
            task4_checker (`king, `seven, `blank, `four, `jack, `blank, 10'bxx_0100_0111);


            if(err)
                $display("Some cases FAILED :(");
            else 
                $display("All cases PASSED :)");

        $stop;
    end

            
endmodule
