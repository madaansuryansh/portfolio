/*
CPEN 311 Lab 1, scorehand testbench
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Testing simple additions, different "overflows", values of special cards (jack, queen, king)
*/

module tb_scorehand();

    reg [3:0] tb_card1;
    reg [3:0] tb_card2;
    reg [3:0] tb_card3;
    wire [3:0] tb_total;
    reg err;

    //instantiate scorehand module
    scorehand DUT (.card1(tb_card1), .card2(tb_card2), .card3(tb_card3), .total(tb_total));

    //task checker to check for proper score
    task score_checker;

        input [3:0] score_expected;

        begin
            if(tb_scorehand.DUT.total != score_expected) begin 
                err = 1'b1;
                // display message when wrong
                $display("total is %d, expected %d", tb_scorehand.DUT.total, score_expected);
            end
        end

    endtask

    initial begin 
        
        err = 1'b0;

        $display("Checking 2 + 3 + 2"); // test for addition 
        tb_card1 = 4'd2;
        tb_card2 = 4'd3;
        tb_card3 = 4'd2;
        #10;  score_checker(4'd7);

        $display("Checking 8 + 8 + 2"); // test for overflow in 10's
        tb_card1 = 4'd8;
        tb_card2 = 4'd8;
        tb_card3 = 4'd2;
        #10;  score_checker(4'd8);

        $display("Checking 9 + 9 + 9"); // test for overflow in 20's
        tb_card1 = 4'd9;
        tb_card2 = 4'd9;
        tb_card3 = 4'd9;
        #10;  score_checker(4'd7);

        $display("Checking J + Q + K"); // test for Jack, Queen, and King 
        tb_card1 = 4'd11;
        tb_card2 = 4'd12;
        tb_card3 = 4'd13;
        #10;  score_checker(4'd0);

        $display("Checking 5 + 3 + 10"); // test for 10 
        tb_card1 = 4'd5;
        tb_card2 = 4'd3;
        tb_card3 = 4'd10;
        #10;  score_checker(4'd8);

        if (~err)
            $display("All cases PASSED");
        else 
            $display("ERROR found!!");
        
    end

endmodule
