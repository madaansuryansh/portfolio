/*
CPEN311 Lab 2: Circles and Triangles
Ansh Madaan (8399574) & Rishi Upath (18259374)
October 27, 2025

Task2 Module
Purpose: Displays columns of different colours through vga when start signal is asserted. Connects fillscreen to the vga adapter.

*/

`timescale 1 ps / 1 ps

module task2(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);
    
    reg start;
    reg [2:0] colour;
    reg done;
    logic VGA_SYNC, VGA_BLANK;

    //set start to high if reset is set 
    always_ff @(posedge CLOCK_50) begin 

        if (KEY[3] == 1'b0)
            start <= 1'b1;
        //deassert start if fillscreen is done 
        else if (done)
            start <= 1'b0;

    end
    
    //instantiations of fillscreen and vga_adapter
    fillscreen FSC (.clk(CLOCK_50), .rst_n(KEY[3]), .colour(colour), .start(start), .done(done), 
                    .vga_x(VGA_X), .vga_y(VGA_Y), .vga_colour(VGA_COLOUR), .vga_plot(VGA_PLOT));

    vga_adapter#(.RESOLUTION("160x120")) vga_u0(.resetn(KEY[3]), .clock(CLOCK_50), .colour(VGA_COLOUR),
                                            .x(VGA_X), .y(VGA_Y), .plot(VGA_PLOT),
                                            .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .*);

endmodule: task2
