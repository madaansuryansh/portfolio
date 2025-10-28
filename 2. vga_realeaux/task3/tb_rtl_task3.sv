/*
CPEN311 Lab 2: Circles and Triangles
Ansh Madaan (8399574) & Rishi Upath (18259374)
October 27, 2025

RTL Testbench for Task3 Module
Purpose: Tests task3 modules output signals by implementing a reference Bresenham circle drawing algorithm and comparing.
         Checks for vga_x, vga_y, offsets, crit, vga_plot, and done.
*/

`timescale 1ps/1ps

module tb_rtl_task3();

    reg tb_CLOCK_50;
    reg [3:0] tb_KEY;
    reg [9:0] tb_SW; 
    wire [9:0] tb_LEDR;
    wire [6:0] tb_HEX0, tb_HEX1, tb_HEX2, tb_HEX3, tb_HEX4, tb_HEX5;
    wire [7:0] tb_VGA_R, tb_VGA_G, tb_VGA_B, tb_VGA_X;
    wire [6:0] tb_VGA_Y;
    wire [2:0] tb_VGA_COLOUR;
    wire tb_VGA_HS, tb_VGA_VS, tb_VGA_CLK, tb_VGA_PLOT;
    reg err;

    //local regs to compute pixels positions to draw
    reg signed [7:0] expected_offset_y;
    reg signed [7:0] expected_offset_x;
    reg signed [8:0] expected_crit;

    reg signed [8:0] expected_vga_x;
    reg signed [7:0] expected_vga_y;

    wire signed [8:0] signed_centre_x;
    wire signed [7:0] signed_centre_y;

    reg expected_vga_plot;

    //signed version of centre x and y
    assign signed_centre_x = tb_rtl_task3.DUT.centre_x;
    assign signed_centre_y = tb_rtl_task3.DUT.centre_y;

    //instantiate task3 module
    task3 DUT(.CLOCK_50(tb_CLOCK_50), .KEY(tb_KEY), .SW(tb_SW), .LEDR(tb_LEDR), .HEX0(tb_HEX0),
             .HEX1(tb_HEX1), .HEX2(tb_HEX2), .HEX3(tb_HEX3), .HEX4(tb_HEX4), .HEX5(tb_HEX5),
             .VGA_R(tb_VGA_R), .VGA_G(tb_VGA_G), .VGA_B(tb_VGA_B),
             .VGA_HS(tb_VGA_HS), .VGA_VS(tb_VGA_VS), .VGA_CLK(tb_VGA_CLK),
             .VGA_X(tb_VGA_X), .VGA_Y(tb_VGA_Y),
             .VGA_COLOUR(tb_VGA_COLOUR), .VGA_PLOT(tb_VGA_PLOT));

    //task checker for fillscreen module, checks x and y position, colour, and plot
    task fillscreen_checker;
        
        input [7:0] x_expected;
        input [6:0] y_expected;
        input [2:0] colour_expected;
        input vga_plot_expected;

        begin
            if (tb_rtl_task3.DUT.VGA_X != x_expected) begin
                $display("ERROR, x position is %b, expected %b", tb_rtl_task3.DUT.VGA_X, x_expected);
                err = 1'b1;
            end
            if (tb_rtl_task3.DUT.VGA_Y != y_expected) begin
                $display("ERROR, y position is %b, expected %b", tb_rtl_task3.DUT.VGA_Y, y_expected);
                err = 1'b1;
            end
            if (tb_rtl_task3.DUT.VGA_COLOUR != colour_expected) begin
                $display("ERROR, colour is %b, expected %b", tb_rtl_task3.DUT.VGA_COLOUR, colour_expected);
                err = 1'b1;
            end
            if (tb_rtl_task3.DUT.VGA_PLOT != vga_plot_expected) begin
                $display("ERROR, vga_plot is %b, expected %b", tb_rtl_task3.DUT.VGA_PLOT, vga_plot_expected);
                err = 1'b1;
            end

        end
    endtask

    //task checker for drawing circle, tests vga_x, vga_y, vga_plot, crit, offsets, start, and done signals 
    task circle_checker;

        begin
            //initialize local parameters
            expected_offset_y = 7'd0;
            expected_offset_x = tb_rtl_task3.DUT.radius;
            expected_crit = 9'sd1 - $signed(tb_rtl_task3.DUT.radius);

            while (expected_offset_y <= expected_offset_x) begin 

                @(posedge tb_CLOCK_50); #1;
                //octant 1 test
                expected_vga_x = signed_centre_x + expected_offset_x;
                expected_vga_y = signed_centre_y + expected_offset_y;

                //check offset_y
                $display("Checking offset_y signal");
                if (tb_rtl_task3.DUT.CRC.offset_y != expected_offset_y) begin
                    err = 1'b1;
                    $display("offset_y is %b, expected %b",tb_rtl_task3.DUT.CRC.offset_y, expected_offset_y);
                end

                //check offset_x
                $display("Checking offset_x signal");
                if (tb_rtl_task3.DUT.CRC.offset_x != expected_offset_x) begin
                    err = 1'b1;
                    $display("offset_x is %b, expected %b",tb_rtl_task3.DUT.CRC.offset_x, expected_offset_x);
                end
                
                //check crit 
                $display("Checking crit signal");
                if (tb_rtl_task3.DUT.CRC.crit != expected_crit) begin
                    err = 1'b1;
                    $display("crit is %b, expected %b",tb_rtl_task3.DUT.CRC.crit, expected_crit);
                end
                
                $display("Checking vga_x, octant 1");
                if (tb_rtl_task3.DUT.VGA_X != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_rtl_task3.DUT.VGA_X, expected_vga_x);
                end

                $display("Checking vga_y, octant 1");
                if (tb_rtl_task3.DUT.VGA_Y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_rtl_task3.DUT.VGA_Y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_rtl_task3.DUT.VGA_PLOT != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_rtl_task3.DUT.VGA_PLOT, expected_vga_plot);
                end

          

                @(posedge tb_CLOCK_50); #1;
                //octant 2 test
                expected_vga_x = signed_centre_x + expected_offset_y;
                expected_vga_y = signed_centre_y + expected_offset_x;
                
                $display("Checking vga_x, octant 2");
                if (tb_rtl_task3.DUT.VGA_X != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_rtl_task3.DUT.VGA_X, expected_vga_x);
                end

                $display("Checking vga_y, octant 2");
                if (tb_rtl_task3.DUT.VGA_Y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_rtl_task3.DUT.VGA_Y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_rtl_task3.DUT.VGA_PLOT != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_rtl_task3.DUT.VGA_PLOT, expected_vga_plot);
                end



                @(posedge tb_CLOCK_50); #1;
                //octant 4 test
                expected_vga_x = signed_centre_x - expected_offset_x;
                expected_vga_y = signed_centre_y + expected_offset_y;
                
                $display("Checking vga_x, octant 4");
                if (tb_rtl_task3.DUT.VGA_X != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_rtl_task3.DUT.VGA_X, expected_vga_x);
                end

                $display("Checking vga_y, octant 4");
                if (tb_rtl_task3.DUT.VGA_Y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_rtl_task3.DUT.VGA_Y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_rtl_task3.DUT.VGA_PLOT != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_rtl_task3.DUT.VGA_PLOT, expected_vga_plot);
                end

                

                @(posedge tb_CLOCK_50); #1;
                //octant 3 test
                expected_vga_x = signed_centre_x - expected_offset_y;
                expected_vga_y = signed_centre_y + expected_offset_x;
                
                $display("Checking vga_x, octant 3");
                if (tb_rtl_task3.DUT.VGA_X != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_rtl_task3.DUT.VGA_X, expected_vga_x);
                end

                $display("Checking vga_y, octant 3");
                if (tb_rtl_task3.DUT.VGA_Y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_rtl_task3.DUT.VGA_Y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_rtl_task3.DUT.VGA_PLOT != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_rtl_task3.DUT.VGA_PLOT, expected_vga_plot);
                end

        

                @(posedge tb_CLOCK_50); #1;
                //octant 5 test
                expected_vga_x = signed_centre_x - expected_offset_x;
                expected_vga_y = signed_centre_y - expected_offset_y;
                
                $display("Checking vga_x, octant 5");
                if (tb_rtl_task3.DUT.VGA_X != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_rtl_task3.DUT.VGA_X, expected_vga_x);
                end

                $display("Checking vga_y, octant 5");
                if (tb_rtl_task3.DUT.VGA_Y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_rtl_task3.DUT.VGA_Y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_rtl_task3.DUT.VGA_PLOT != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_rtl_task3.DUT.VGA_PLOT, expected_vga_plot);
                end

              

                @(posedge tb_CLOCK_50); #1;
                //octant 6 test
                expected_vga_x = signed_centre_x - expected_offset_y;
                expected_vga_y = signed_centre_y - expected_offset_x;
                
                $display("Checking vga_x, octant 6");
                if (tb_rtl_task3.DUT.VGA_X != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_rtl_task3.DUT.VGA_X, expected_vga_x);
                end

                $display("Checking vga_y, octant 6");
                if (tb_rtl_task3.DUT.VGA_Y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_rtl_task3.DUT.VGA_Y, expected_vga_y);
                end  

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_rtl_task3.DUT.VGA_PLOT != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_rtl_task3.DUT.VGA_PLOT, expected_vga_plot);
                end



                @(posedge tb_CLOCK_50); #1;
                //octant 8 test
                expected_vga_x = signed_centre_x + expected_offset_x;
                expected_vga_y = signed_centre_y - expected_offset_y;
                
                $display("Checking vga_x, octant 8");
                if (tb_rtl_task3.DUT.VGA_X != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_rtl_task3.DUT.VGA_X, expected_vga_x);
                end

                $display("Checking vga_y, octant 8");
                if (tb_rtl_task3.DUT.VGA_Y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_rtl_task3.DUT.VGA_Y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_rtl_task3.DUT.VGA_PLOT != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_rtl_task3.DUT.VGA_PLOT, expected_vga_plot);
                end
                
                
                
                @(posedge tb_CLOCK_50); #1;
                //octant 7 test
                expected_vga_x = signed_centre_x + expected_offset_y;
                expected_vga_y = signed_centre_y - expected_offset_x;
                
                $display("Checking vga_x, octant 7");
                if (tb_rtl_task3.DUT.VGA_X != expected_vga_x[7:0]) begin 
                    err = 1'b1;
                    $display("vga_x is %b, expected vga_x is %b", tb_rtl_task3.DUT.VGA_X, expected_vga_x);
                end

                $display("Checking vga_y, octant 7");
                if (tb_rtl_task3.DUT.VGA_Y != expected_vga_y[6:0]) begin
                    err = 1'b1;
                    $display("vga_y is %b, expected vga_y is %b", tb_rtl_task3.DUT.VGA_Y, expected_vga_y);
                end

                //determine expected plot depending on boundary condition
                if (expected_vga_x < 9'sd0 || expected_vga_x > 9'sd159)
                    expected_vga_plot = 1'b0;
                else if (expected_vga_y < 9'sd0 || expected_vga_y > 9'sd119)
                    expected_vga_plot = 1'b0;
                else 
                    expected_vga_plot = 1'b1;

                //check if plot is high
                $display("Checking plot signal");
                if (tb_rtl_task3.DUT.VGA_PLOT != expected_vga_plot) begin
                    err = 1'b1;
                    $display("vga_plot is %b, expected %b",tb_rtl_task3.DUT.VGA_PLOT, expected_vga_plot);
                end


                //changing offset_y, offset_x, and crit according to circle drawing algorithm 
                expected_offset_y = expected_offset_y + 8'sd1;

                if (expected_crit <= 9'sd0)
                    expected_crit = expected_crit + 9'sd2 * $signed(expected_offset_y) + 9'sd1;
                else begin
                    expected_offset_x = expected_offset_x - 8'sd1;
                    expected_crit = expected_crit + 9'sd2 * ($signed(expected_offset_y) - $signed(expected_offset_x)) + 9'sd1;
                end


                
            end
            
            @(posedge tb_rtl_task3.DUT.circle_done); #1;

            //check if plot is low
            $display("Checking plot signal");
            if (tb_rtl_task3.DUT.VGA_PLOT != 1'b0) begin
                err = 1'b1;
                $display("vga_plot is %b, expected 0",tb_rtl_task3.DUT.VGA_PLOT);
            end

            //check if done is high
            $display("Checking done signal");
            if (tb_rtl_task3.DUT.circle_done != 1'b1) begin
                err = 1'b1;
                $display("done is %b, expected 1",tb_rtl_task3.DUT.circle_done);
            end
            
        end

     endtask


    
    //initializing tb_CLOCK_50 for each pixel    
    initial begin

        tb_CLOCK_50 = 1'b0; #10;

        //Cycle clock for 50MHz
        forever begin
            tb_CLOCK_50 = 1'b1; #10;
            tb_CLOCK_50 = 1'b0; #10;
        end

    end

    //block to test fillscreen and circle together
    initial begin

        err = 1'b0;

        //assert reset
        tb_KEY[3] = 1'b0; #20;
        tb_KEY[3] = 1'b1; #5;

        //check if proper start signal is set 
        if (tb_rtl_task3.DUT.fillscreen_start != 1'b1) begin
            err = 1'b1;
            $display("fillscreen_start is %b, expected 1", tb_rtl_task3.DUT.fillscreen_start);
        end

        if (tb_rtl_task3.DUT.circle_start != 1'b0) begin
            err = 1'b1;
            $display("circle_start is %b, expected 0", tb_rtl_task3.DUT.circle_start);
        end

        @(posedge tb_CLOCK_50); #1;

        //fillscreen colours the entire screen black
        //check colour
        $display("Checking colour is black");
        if (tb_rtl_task3.DUT.VGA_COLOUR != 3'b000) begin 
            err = 1'b1;
            $display("colour is %b, expected 000 (black)", tb_rtl_task3.DUT.VGA_COLOUR);
        end

        //check position and colour of every pixel as well as correct plot signal
        for (integer i = 0; i <= 159; i++) begin
            for (integer j = 0; j <= 119; j++) begin 
                //account for extra increment of y after reset
                if (i == 0 && j == 0) 
                    j++;

                $display("Start time is, %0t", $time);
                fillscreen_checker(i, j, 3'b000, 1'b1);
                #20;
            end 
        end

        //check for fillscreen_start, circle_start
        @(posedge tb_CLOCK_50); #1;
        
        if (tb_rtl_task3.DUT.fillscreen_start != 1'b0) begin
            err = 1'b1;
            $display("fillscreen_start is %b, expected 0", tb_rtl_task3.DUT.fillscreen_start);
        end

        if (tb_rtl_task3.DUT.circle_start != 1'b1) begin
            err = 1'b1;
            $display("circle_start is %b, expected 1", tb_rtl_task3.DUT.circle_start);
        end

        //colour checker
        if (tb_rtl_task3.DUT.VGA_COLOUR != 3'b010) begin
                $display("ERROR, colour is %b, expected %b", tb_rtl_task3.DUT.VGA_COLOUR, 3'b010);
                err = 1'b1;
            end
        
        //checking circle
        $display("Testing circle with radius: 40, centre: (80,60) at: %0t", $time);
        circle_checker();

        @(posedge tb_CLOCK_50); #1;

        //check if circle start is low 
        if (tb_rtl_task3.DUT.circle_start != 1'b0) begin
            err = 1'b1;
            $display("circle_start is %b, expected 0", tb_rtl_task3.DUT.circle_start);
        end

        @(posedge tb_CLOCK_50); #1;

        //display error or passed message
        if (!err)
            $display("All cases PASSED :)");
        else 
            $display("Some cases FAILED :(");

        $stop;

    end

endmodule: tb_rtl_task3
