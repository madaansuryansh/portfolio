/*
CPEN311 Lab 2: Circles and Triangles
Ansh Madaan (8399574) & Rishi Upath (18259374)
October 27, 2025

Fillscreen Module
Purpose: Displays columns of different colours when start signal is asserted
*/

module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);
                  

     //sequential block that sets pixel position and colour 
	always_ff @(posedge clk) begin
          //active low synchronous reset 
          if (~rst_n) begin
               vga_x <= 8'b0;
               vga_y <= 7'b0;
               vga_plot <= 1'b1;
               done <= 1'b0;
               
          end
          
          //change position of pixel if start is still asserted
          else if (start) begin
               
               //asserts done and stop plotting 
               if (vga_y == 7'd119 && vga_x == 8'd159) begin 
                    done <= 1'b1;
                    vga_plot <= 1'b0;
               end
               
               //increment y position until bottom of screen is reached
               else if (vga_y < 7'd119)
                    vga_y <= vga_y + 7'b1;

               //increment x position, and reset y position if bottom of screen is reached
               else begin 
                    vga_x <= vga_x + 8'b1;
                    vga_y <= 7'b0;
               end

          end

          //if start is deasserted then done is deasserted 
          else 
               done <= 1'b0;
          
     end
     
     //set colour based on x position. Outside sequential block so the colour updates right away after a change in x position 
     assign vga_colour = vga_x[2:0];
     
endmodule