/*
CPEN311 Lab 2: Circles and Triangles
Ansh Madaan (8399574) & Rishi Upath (18259374)
October 27, 2025

Task2 synthesis testbench module
Purpose: Synthesis testbench for task2 module, tests x and y positions, colour, and plot of every pixel plotted. Tests vo file
*/

`timescale 1ps/1ps

module tb_syn_task2();
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

    //instantiate task2 module 
    task2 DUT(.CLOCK_50(tb_CLOCK_50), .KEY(tb_KEY), .SW(tb_SW), .LEDR(tb_LEDR), .HEX0(tb_HEX0),
             .HEX1(tb_HEX1), .HEX2(tb_HEX2), .HEX3(tb_HEX3), .HEX4(tb_HEX4), .HEX5(tb_HEX5),
             .VGA_R(tb_VGA_R), .VGA_G(tb_VGA_G), .VGA_B(tb_VGA_B),
             .VGA_HS(tb_VGA_HS), .VGA_VS(tb_VGA_VS), .VGA_CLK(tb_VGA_CLK),
             .VGA_X(tb_VGA_X), .VGA_Y(tb_VGA_Y),
             .VGA_COLOUR(tb_VGA_COLOUR), .VGA_PLOT(tb_VGA_PLOT));

   task task2_checker;  
        input [7:0] x_expected;
        input [6:0] y_expected;
        input [2:0] colour_expected;
        input vga_plot_expected;

        begin
            //check if signals are correct and display error if not
            if (tb_syn_task2.DUT.VGA_X != x_expected) begin
                $display("ERROR, x position is %b, expected %b", tb_syn_task2.DUT.VGA_X, x_expected);
                err = 1'b1;
            end
            if (tb_syn_task2.DUT.VGA_Y != y_expected) begin
                $display("ERROR, y position is %b, expected %b", tb_syn_task2.DUT.VGA_Y, y_expected);
                err = 1'b1;
            end
            if (tb_syn_task2.DUT.VGA_COLOUR != colour_expected) begin
                $display("ERROR, colour is %b, expected %b", tb_syn_task2.DUT.VGA_COLOUR, colour_expected);
                err = 1'b1;
            end
            if (tb_syn_task2.DUT.VGA_PLOT != vga_plot_expected) begin
                $display("ERROR, vga_plot is %b, expected %b", tb_syn_task2.DUT.VGA_PLOT, vga_plot_expected);
                err = 1'b1;
            end

        end
    endtask
    
    //initializing CLOCK_50 for each pixel    
    initial begin

        tb_CLOCK_50 = 1'b0; #10;

        //Cycle clock for 50MHz
        forever begin
            tb_CLOCK_50 = 1'b1; #10;
            tb_CLOCK_50 = 1'b0; #10;
        end

    end

    initial begin

        err = 1'b0;

        //assert reset
        tb_KEY[3] = 1'b0; #20;
        tb_KEY[3] = 1'b1; #5;

        task2_checker(8'd0, 7'd0, 3'b000, 1'b1);

        #15;

        $display("Start time is, %0t", $time);
        //check position and colour of every pixel as well as correct plot signal
        for (integer i = 0; i <= 159; i++) begin
            for (integer j = 0; j <= 119; j++) begin 
                //account for extra increment of y after reset
                if (i == 0 && j == 0) 
                    j++;

                $display("Start time is, %0t", $time);
                task2_checker(i, j, (i % 8), 1'b1);
                #20;

            end 
        end

        //check if plot is low 
        $display("Start time is, %0t", $time);
        task2_checker(8'd159, 7'd119, 3'b111, 1'b0);
        #20;
        
        //display message if cases passed or failed 
        if (~err)
            $display("All cases PASSED :)");
        else 
            $display("Some cases FAILED :(");

        $stop;

    end

endmodule: tb_syn_task2
