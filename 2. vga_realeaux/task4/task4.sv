/*
CPEN311 Lab 2: Circles and Triangles
Ansh Madaan (8399574) & Rishi Upath (18259374)
October 27, 2025

Task4 Module
Purpose: Fills the entire screen black and draws reuleaux triangle based on centre_x, centre_y, and diameter inputs
*/

module task4(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

    logic VGA_SYNC, VGA_BLANK;
    logic [7:0] centre_x, diameter, fillscreen_vga_x, reuleaux_vga_x;
    logic [6:0] centre_y, fillscreen_vga_y, reuleaux_vga_y;
    logic [2:0] fillscreen_colour, reuleaux_colour, fillscreen_vga_colour, reuleaux_vga_colour;
    reg fillscreen_start, reuleaux_start, fillscreen_done, reuleaux_done, fillscreen_vga_plot, reuleaux_vga_plot;
    

    //sequential block for asserting start for both modules
    always_ff @(posedge CLOCK_50) begin 

        //reset sets start for fillscreeen
        if (KEY[3] == 1'b0) begin 
            fillscreen_start <= 1'b1;
            reuleaux_start <= 1'b0;
        end
        //after fillscreen finishes, reuleaux module starts
        else if (fillscreen_done) begin
            fillscreen_start <= 1'b0;
            reuleaux_start <= 1'b1;
        end
        //deasserts start after circle asserts done
        else if (reuleaux_done)
            reuleaux_start <= 1'b0;
    end
        
    //set circle center position and radius
    assign centre_x = 8'd80;
    assign centre_y = 7'd60;
    assign diameter = 8'd80;
    assign reuleaux_colour = 3'b010;
    assign fillscreen_colour = 3'b000;

    //determine which module outputs to connect to VGA adapter
    assign VGA_X = reuleaux_start ? reuleaux_vga_x : fillscreen_vga_x;
    assign VGA_Y = reuleaux_start ? reuleaux_vga_y : fillscreen_vga_y;
    assign VGA_COLOUR = reuleaux_start ? reuleaux_vga_colour : fillscreen_vga_colour;
    assign VGA_PLOT = reuleaux_start ? reuleaux_vga_plot : fillscreen_vga_plot;
    
    //instantiate and connect the VGA adapter, circle, and fillscreen module
    fillscreen FSC (.clk(CLOCK_50), .rst_n(KEY[3]), .colour(fillscreen_colour), .start(fillscreen_start), 
                    .done(fillscreen_done), .vga_x(fillscreen_vga_x), .vga_y(fillscreen_vga_y), 
                    .vga_colour(fillscreen_vga_colour), .vga_plot(fillscreen_vga_plot));

    reuleaux RLX (.clk(CLOCK_50), .rst_n(KEY[3]), .colour(reuleaux_colour), .centre_x(centre_x), .centre_y(centre_y), 
                .diameter(diameter), .start(reuleaux_start), .done(reuleaux_done), .vga_x(reuleaux_vga_x), .vga_y(reuleaux_vga_y), 
                .vga_colour(reuleaux_vga_colour), .vga_plot(reuleaux_vga_plot));

    vga_adapter#(.RESOLUTION("160x120")) vga_u0(.resetn(KEY[3]), .clock(CLOCK_50), .colour(VGA_COLOUR),
                                            .x(VGA_X), .y(VGA_Y), .plot(VGA_PLOT),
                                            .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .*);


    
endmodule: task4