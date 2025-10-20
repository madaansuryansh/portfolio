/*
CPEN 311 Lab 1, datapath testbench
Suryansh Madaan (83499574) and Rishi Upath (18259374), Group: B15

Purpose: Testing inputs of all card loads and checking if ouputs of registers are correct with corresponding HEX display and scores
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

module tb_datapath();

    logic tb_slow_clock, tb_fast_clock, tb_resetb, tb_load_pcard1, tb_load_pcard2, tb_load_pcard3, tb_load_dcard1, tb_load_dcard2, tb_load_dcard3;
    wire [3:0] tb_pcard3_out, tb_pscore_out, tb_dscore_out;
    wire [6:0] tb_HEX5, tb_HEX4, tb_HEX3, tb_HEX2, tb_HEX1, tb_HEX0;
    reg err;


    datapath DUT (.slow_clock(tb_slow_clock), .fast_clock(tb_fast_clock), .resetb(tb_resetb),
                  .load_pcard1(tb_load_pcard1), .load_pcard2(tb_load_pcard2), .load_pcard3(tb_load_pcard3),
                  .load_dcard1(tb_load_dcard1), .load_dcard2(tb_load_dcard2), .load_dcard3(tb_load_dcard3), 
                  .pcard3_out(tb_pcard3_out), .pscore_out(tb_pscore_out), .dscore_out(tb_dscore_out), .HEX5(tb_HEX5), 
                  .HEX4(tb_HEX4), .HEX3(tb_HEX3), .HEX2(tb_HEX2), .HEX1(tb_HEX1), .HEX0(tb_HEX0));
    
    //task checker to check for expected score, pcard3, and HEXs 
    task datapath_checker;

        input [6:0] HEX0_expected, HEX1_expected, HEX2_expected, HEX3_expected, HEX4_expected, HEX5_expected;
        input [3:0] pscore_out_expected, dscore_out_expected, pcard3_expected;

        begin 

            if (tb_datapath.DUT.HEX0 != HEX0_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_datapath.DUT.HEX0, HEX0_expected);
            end

            if (tb_datapath.DUT.HEX1 != HEX1_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_datapath.DUT.HEX1, HEX1_expected);
            end

            if (tb_datapath.DUT.HEX2 != HEX2_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_datapath.DUT.HEX2, HEX2_expected);
            end

            if (tb_datapath.DUT.HEX3 != HEX3_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_datapath.DUT.HEX3, HEX3_expected);
            end

            if (tb_datapath.DUT.HEX4 != HEX4_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_datapath.DUT.HEX4, HEX4_expected);
            end

            if (tb_datapath.DUT.HEX5 != HEX5_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_datapath.DUT.HEX5, HEX5_expected);
            end

            if (tb_datapath.DUT.pscore_out != pscore_out_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_datapath.DUT.pscore_out, dscore_out_expected);
            end

            if (tb_datapath.DUT.dscore_out != dscore_out_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_datapath.DUT.dscore_out, dscore_out_expected);
            end

            if (tb_datapath.DUT.pcard3_out != pcard3_expected) begin
                err = 1'b1;
                $display("output is %b, expected %b", tb_datapath.DUT.pcard3_out, pcard3_expected);
            end
        end

    endtask

    initial begin 
        
        tb_fast_clock = 0;
        #10;
        
        forever begin 
            tb_fast_clock = 1; #10;
            tb_fast_clock = 0; #10;
        end

    end

    initial begin

        err = 1'b0;
        
        //Checking the output of reset
        $display("Checking Reset");
        tb_resetb = 1'b0; #10
        tb_slow_clock = 1'b1; #10;
        
        tb_resetb = 1'b1; 
        tb_slow_clock = 1'b0; #10;
        datapath_checker(`blank, `blank, `blank, `blank, `blank, `blank, 4'd0, 4'd0, 4'd0);
        
        
        //Checking the output of pcard1 after setting load_pcard1
        $display("Checking Pcard1");

        force tb_datapath.DUT.DEL.new_card = 4'd5;
        tb_load_pcard1 = 1'b1;

        tb_slow_clock = 1'b1; #10;
        tb_slow_clock = 1'b0; #10;

        datapath_checker(`five, `blank, `blank, `blank, `blank, `blank, 4'd5, 4'd0, 4'd0);

        
        //Checking the output of pcard2 after setting load_pcard2
        $display("Checking Pcard2");

        force tb_datapath.DUT.DEL.new_card = 4'd4;
        tb_load_pcard1 = 1'b0;
        tb_load_pcard2 = 1'b1;

        tb_slow_clock = 1'b1; #10;
        tb_slow_clock = 1'b0; #10;

        datapath_checker(`five, `four, `blank, `blank, `blank, `blank, 4'd9, 4'd0, 4'd0);
        
        
        //Checking the output of pcard3 after setting load_pcard3
        $display("Checking Pcard3");

        force tb_datapath.DUT.DEL.new_card = 4'd12;
        tb_load_pcard2 = 1'b0;
        tb_load_pcard3 = 1'b1;

        tb_slow_clock = 1'b1; #10;
        tb_slow_clock = 1'b0; #10;

        datapath_checker(`five, `four, `queen, `blank, `blank, `blank, 4'd9, 4'd0, 4'd12);


        //Checking the output of dcard1 after setting load_dcard1
        $display("Checking Dcard1");

        force tb_datapath.DUT.DEL.new_card = 4'd6;
        tb_load_pcard3 = 1'b0;
        tb_load_dcard1 = 1'b1;

        tb_slow_clock = 1'b1; #10;
        tb_slow_clock = 1'b0; #10;

        datapath_checker(`five, `four, `queen, `six, `blank, `blank, 4'd9, 4'd6, 4'd12);

        
        //Checking the output of dcard2 after setting load_dcard2
        $display("Checking Dcard2");

        force tb_datapath.DUT.DEL.new_card = 4'd7;
        tb_load_dcard1 = 1'b0;
        tb_load_dcard2 = 1'b1;

        tb_slow_clock = 1'b1; #10;
        tb_slow_clock = 1'b0; #10;

        datapath_checker(`five, `four, `queen, `six, `seven, `blank, 4'd9, 4'd3, 4'd12);
        
        
        //Checking the output of dcard3 after setting load_dcard3
        $display("Checking Dcard3");

        force tb_datapath.DUT.DEL.new_card = 4'd11;
        tb_load_dcard2 = 1'b0;
        tb_load_dcard3 = 1'b1;

        tb_slow_clock = 1'b1; #10;
        tb_slow_clock = 1'b0; #10;

        datapath_checker(`five, `four, `queen, `six, `seven, `jack, 4'd9, 4'd3, 4'd12);


        //Checking the output of reset again
        $display("Checking Reset");
        tb_resetb = 1'b0; #10
        tb_slow_clock = 1'b1; #10;
        
        tb_resetb = 1'b1; 
        tb_slow_clock = 1'b0; #10;
        datapath_checker(`blank, `blank, `blank, `blank, `blank, `blank, 4'd0, 4'd0, 4'd0);

        
        if(err)
            $display("Some cases FAILED :(");
        else
            $display("All cases PASSED :)");

        $stop;
    end


endmodule
