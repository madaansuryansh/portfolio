/*
CPEN311 Lab 2: Circles and Triangles
Ansh Madaan (8399574) & Rishi Upath (18259374)
October 27, 2025

SYN Testbench for Reuleaux Module
Purpose: Tests .vo reuleaux modules output signals by implementing a reference reuleaux triangle drawing algorithm and comparing.
         Checks for vga_x, vga_y, colour, and vga_plot.
*/

`timescale 1ps/1ps

module tb_syn_reuleaux();

    //reuleaux.sv regs and wires
    reg tb_clk, tb_rst_n, tb_start; 
    reg [2:0] tb_colour;
    reg [7:0] tb_centre_x, tb_diameter;
    reg [6:0] tb_centre_y;
    wire [7:0] tb_vga_x; 
    wire [6:0] tb_vga_y;
    wire [2:0] tb_vga_colour;
    wire tb_vga_plot, tb_done;

    //local regs to compute pixels positions to draw
    reg signed [7:0] expected_offset_y;
    reg signed [7:0] expected_offset_x;
    reg signed [8:0] expected_crit;

    reg signed [8:0] signed_centre_x, expected_vga_x;
    reg signed [8:0] signed_centre_y, expected_vga_y;

    real expected_top_centre_x, expected_left_centre_x, expected_right_centre_x;
    real expected_top_centre_y, expected_left_centre_y, expected_right_centre_y;

    reg expected_vga_plot;

    reg err;
    
    //instantiate reuleaux module
    reuleaux DUT (.clk(tb_clk), .rst_n(tb_rst_n), .colour(tb_colour), .centre_x(tb_centre_x), .centre_y(tb_centre_y), 
                .diameter(tb_diameter), .start(tb_start), .done(tb_done), .vga_x(tb_vga_x), .vga_y(tb_vga_y), 
                .vga_colour(tb_vga_colour), .vga_plot(tb_vga_plot));

    //signed version of centre x and y
    assign signed_centre_x = tb_centre_x;
    assign signed_centre_y = tb_centre_y;

    //task checker for drawing circle, tests vga_x, vga_y, vga_plot, and done
    task reuleaux_checker;

        begin
            //initialize local parameters
            expected_offset_y = 7'd0;
            expected_offset_x = tb_diameter;
            expected_crit = 9'sd1 - $signed(tb_diameter);

            //compute expected centres 
            expected_top_centre_x = signed_centre_x;
            expected_top_centre_y = signed_centre_y - tb_diameter * ($sqrt(3.0)/3.0);
            expected_left_centre_x = signed_centre_x - tb_diameter / 2;
            expected_left_centre_y = signed_centre_y + tb_diameter * ($sqrt(3.0)/6.0);
            expected_right_centre_x = signed_centre_x + tb_diameter / 2;
            expected_right_centre_y = signed_centre_y + tb_diameter * ($sqrt(3.0)/6.0);

            while (expected_offset_y <= expected_offset_x) begin 

                @(posedge tb_clk); #1;
                //octant 8 test
                expected_vga_x = int'(expected_left_centre_x) + expected_offset_x;
                expected_vga_y = int'(expected_left_centre_y) - expected_offset_y; #1;

                //check vga_x
                $display("Checking vga_x, octant 8");
                if (tb_syn_reuleaux.DUT.vga_x != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_syn_reuleaux.DUT.vga_x, expected_vga_x);
                end

                //check vga_y
                $display("Checking vga_y, octant 8");
                if (tb_syn_reuleaux.DUT.vga_y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_syn_reuleaux.DUT.vga_y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else if ((expected_vga_x > int'(expected_right_centre_x)) || (expected_vga_x < int'(expected_top_centre_x)) || (expected_vga_y < int'(expected_top_centre_y)) || (expected_vga_y > int'(expected_right_centre_y))) 
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_syn_reuleaux.DUT.vga_plot != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_syn_reuleaux.DUT.vga_plot, expected_vga_plot);
                end

                

                @(posedge tb_clk); #1;
                //octant 7 test
                expected_vga_x = int'(expected_left_centre_x) + expected_offset_y;
                expected_vga_y = int'(expected_left_centre_y) - expected_offset_x; #1;
                
                $display("Checking vga_x, octant 7");
                if (tb_syn_reuleaux.DUT.vga_x != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_syn_reuleaux.DUT.vga_x, expected_vga_x);
                end

                $display("Checking vga_y, octant 7");
                if (tb_syn_reuleaux.DUT.vga_y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_syn_reuleaux.DUT.vga_y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else if ((expected_vga_x > int'(expected_right_centre_x)) || (expected_vga_x < int'(expected_top_centre_x)) || (expected_vga_y < int'(expected_top_centre_y)) || (expected_vga_y > int'(expected_right_centre_y))) 
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_syn_reuleaux.DUT.vga_plot != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_syn_reuleaux.DUT.vga_plot, expected_vga_plot);
                end

                

                @(posedge tb_clk); #1;
                //octant 6 test
                expected_vga_x = int'(expected_right_centre_x) - expected_offset_y;
                expected_vga_y = int'(expected_right_centre_y) - expected_offset_x; #1;
                
                $display("Checking vga_x, octant 6");
                if (tb_syn_reuleaux.DUT.vga_x != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_syn_reuleaux.DUT.vga_x, expected_vga_x);
                end

                $display("Checking vga_y, octant 6");
                if (tb_syn_reuleaux.DUT.vga_y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_syn_reuleaux.DUT.vga_y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else if ((expected_vga_x > int'(expected_top_centre_x)) || (expected_vga_x < int'(expected_left_centre_x)) || (expected_vga_y < int'(expected_top_centre_y)) || (expected_vga_y > int'(expected_left_centre_y))) 
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_syn_reuleaux.DUT.vga_plot != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_syn_reuleaux.DUT.vga_plot, expected_vga_plot);
                end

                

                @(posedge tb_clk); #1;
                //octant 5 test
                expected_vga_x = int'(expected_right_centre_x) - expected_offset_x;
                expected_vga_y = int'(expected_right_centre_y) - expected_offset_y; #1;
                
                $display("Checking vga_x, octant 5");
                if (tb_syn_reuleaux.DUT.vga_x != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_syn_reuleaux.DUT.vga_x, expected_vga_x);
                end

                $display("Checking vga_y, octant 5");
                if (tb_syn_reuleaux.DUT.vga_y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_syn_reuleaux.DUT.vga_y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else if ((expected_vga_x > int'(expected_top_centre_x)) || (expected_vga_x < int'(expected_left_centre_x)) || (expected_vga_y < int'(expected_top_centre_y)) || (expected_vga_y > int'(expected_left_centre_y))) 
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_syn_reuleaux.DUT.vga_plot != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_syn_reuleaux.DUT.vga_plot, expected_vga_plot);
                end

                

                @(posedge tb_clk); #1;
                //octant 3 test
                expected_vga_x = int'(expected_top_centre_x) - expected_offset_y;
                expected_vga_y = int'(expected_top_centre_y) + expected_offset_x; #1;

                $display("Checking vga_x, octant 3");
                if (tb_syn_reuleaux.DUT.vga_x != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_syn_reuleaux.DUT.vga_x, expected_vga_x);
                end

                $display("Checking vga_y, octant 3");
                if (tb_syn_reuleaux.DUT.vga_y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_syn_reuleaux.DUT.vga_y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else if ((expected_vga_x > int'(expected_right_centre_x)) || (expected_vga_x < int'(expected_left_centre_x)) || (expected_vga_y < int'(expected_right_centre_y)))
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_syn_reuleaux.DUT.vga_plot != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_syn_reuleaux.DUT.vga_plot, expected_vga_plot);
                end

                

                @(posedge tb_clk); #1;
                //octant 2 test
                expected_vga_x = int'(expected_top_centre_x) + expected_offset_y;
                expected_vga_y = int'(expected_top_centre_y) + expected_offset_x; #1;
                
                $display("Checking vga_x, octant 2");
                if (tb_syn_reuleaux.DUT.vga_x != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_syn_reuleaux.DUT.vga_x, expected_vga_x);
                end

                $display("Checking vga_y, octant 2");
                if (tb_syn_reuleaux.DUT.vga_y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_syn_reuleaux.DUT.vga_y, expected_vga_y);
                end  

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else if ((expected_vga_x > int'(expected_right_centre_x)) || (expected_vga_x < int'(expected_left_centre_x)) || (expected_vga_y < int'(expected_right_centre_y)))
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_syn_reuleaux.DUT.vga_plot != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_syn_reuleaux.DUT.vga_plot, expected_vga_plot);
                end

                //changing offset_y, offset_x, and crit according to reuleauxdrawing algorithm 
                expected_offset_y = expected_offset_y + 8'sd1;

                if (expected_crit <= 9'sd0)
                    expected_crit = expected_crit + 9'sd2 * $signed(expected_offset_y) + 9'sd1;
                else begin
                    expected_offset_x = expected_offset_x - 8'sd1;
                    expected_crit = expected_crit + 9'sd2 * ($signed(expected_offset_y) - $signed(expected_offset_x)) + 9'sd1;
                end

            end
            
            @(posedge tb_syn_reuleaux.DUT.done); #1;
            @(posedge tb_clk); #1;

            //check if plot is low
            $display("Checking plot signal");
            if (tb_syn_reuleaux.DUT.vga_plot != 1'b0) begin
            err = 1'b1;
            $display("vga_plot is %b, expected 0",tb_syn_reuleaux.DUT.vga_plot);
            end

            //check if done is high
            $display("Checking done signal");
            if (tb_syn_reuleaux.DUT.done != 1'b1) begin
            err = 1'b1;
            $display("done is %b, expected 1",tb_syn_reuleaux.DUT.done);
            end
            
        end

    endtask 

    //block to run clock at 50MHz
    initial begin 
        tb_clk = 1'b1; #10; 

        forever begin
            tb_clk = 1'b0; #10;
            tb_clk = 1'b1; #10;
        end
    end

    //block to test different circle positions and radius
    initial begin
        //set reuleauxcolour to green
        err = 1'b0;
        tb_colour = 3'b010; #1;
        
        //check colour
        $display("Checking colour is green");
        if (tb_syn_reuleaux.DUT.vga_colour != 3'b010) begin 
            err = 1'b1;
            $display("colour is %b, expected 010 (green)", tb_syn_reuleaux.DUT.vga_colour);
        end
        
        //Check 1: small reuleaux

        //setting radius, centre_x, and centre_y
        tb_diameter = 8'd10;
        tb_centre_x = 8'd10;
        tb_centre_y = 7'd10;

        //assert reset and start
        tb_rst_n = 1'b0; #20;
        tb_rst_n = 1'b1; #5;

        tb_start = 1'b1; #10;

        $display("Testing reuleaux with diameter: 10, centre: (10,10) at: %0t", $time);
        reuleaux_checker();

        @(posedge tb_clk); #1;

        //Check 2: task 4 expected reuleaux

        //setting radius, centre_x, centre_y
        tb_diameter = 8'd80;
        tb_centre_x = 8'd80;
        tb_centre_y = 7'd60;

        //assert reset and start
        tb_rst_n = 1'b0; #20;
        tb_rst_n = 1'b1; #5;

        tb_start = 1'b1; #10;

        $display("Testing reuleaux with diameter: 80, centre: (80,60) at: %0t", $time);
        reuleaux_checker();

        @(posedge tb_clk); #1;

        //Check 3: top edge of screen reuleaux

        //setting radius, centre_x, and centre_y
        tb_diameter = 8'd80;
        tb_centre_x = 8'd80;
        tb_centre_y = 7'd0;

        //assert reset and start
        tb_rst_n = 1'b0; #20;
        tb_rst_n = 1'b1; #5;

        tb_start = 1'b1; #10;

        $display("Testing reuleaux with diameter: 80, centre: (80,0) at: %0t", $time);
        reuleaux_checker();

        @(posedge tb_clk); #1;

        //Check 4: left edge of screen reuleaux

        //setting radius, centre_x, and centre_y
        tb_diameter = 8'd80;
        tb_centre_x = 8'd0;
        tb_centre_y = 7'd60;

        //assert reset and start
        tb_rst_n = 1'b0; #20;
        tb_rst_n = 1'b1; #5;

        tb_start = 1'b1; #10;

        $display("Testing reuleaux with diameter: 80, centre: (0,60) at: %0t", $time);
        reuleaux_checker();  

        @(posedge tb_clk); #1;   

        //Check 5: right edge of screen reuleaux

        //setting radius, centre_x, and centre_y
        tb_diameter = 8'd40;
        tb_centre_x = 8'd159;
        tb_centre_y = 7'd60;

        //assert reset and start
        tb_rst_n = 1'b0; #20;
        tb_rst_n = 1'b1; #5;

        tb_start = 1'b1; #5;

        $display("Testing reuleaux with radius: 40, centre: (159,60) at: %0t", $time);
        reuleaux_checker();   

        @(posedge tb_clk); #1;

        //Check 6: bottom edge of screen reuleaux

        //setting radius, centre_x, and centre_y
        tb_diameter = 8'd20;
        tb_centre_x = 8'd80;
        tb_centre_y = 7'd119;

        //assert reset and start
        tb_rst_n = 1'b0; #20;
        tb_rst_n = 1'b1; #5;

        tb_start = 1'b1; #10;

        $display("Testing reuleaux with radius: 20, centre: (80,119) at: %0t", $time);
        reuleaux_checker();    

        @(posedge tb_clk); #1;      

        //Check 7: corner reuleaux

        //setting radius, centre_x, and centre_y
        tb_diameter = 8'd80;
        tb_centre_x = 8'd0;
        tb_centre_y = 7'd0;

        //assert reset and start
        tb_rst_n = 1'b0; #20;
        tb_rst_n = 1'b1; #5;

        tb_start = 1'b1; #10;

        $display("Testing reuleaux with radius: 80, centre: (0,0) at: %0t", $time);
        reuleaux_checker(); 

        @(posedge tb_clk); #1;  

        //Check 8: reuleaux with large radius

        //setting radius, centre_x, and centre_y
        tb_diameter = 8'd100;
        tb_centre_x = 8'd80;
        tb_centre_y = 7'd60;

        //assert reset and start
        tb_rst_n = 1'b0; #20;
        tb_rst_n = 1'b1; #5;

        tb_start = 1'b1; #10;

        $display("Testing reuleaux with radius: 80, centre: (80,60) at: %0t", $time);
        reuleaux_checker();  

        @(posedge tb_clk); #1; 

        //Check 9: reuleaux with no radius

        //setting radius, centre_x, and centre_y
        tb_diameter = 8'd0;
        tb_centre_x = 8'd80;
        tb_centre_y = 7'd60;

        //assert reset and start
        tb_rst_n = 1'b0; #20;
        tb_rst_n = 1'b1; #5;

        tb_start = 1'b1; #10;

        $display("Testing reuleaux with radius: 0, centre: (80,60) at: %0t", $time);
        reuleaux_checker();  

        @(posedge tb_clk); #1;         

        //display error or passed message 
        if(err)
            $display("Some cases FAILED :(");
        else 
            $display("All cases PASSED :)");
            
        $stop;

    end

endmodule: tb_syn_reuleaux
