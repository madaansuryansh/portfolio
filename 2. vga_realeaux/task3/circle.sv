/*
CPEN311 Lab 2: Circles and Triangles
Ansh Madaan (8399574) & Rishi Upath (18259374)
October 27, 2025

Circle Module
Purpose: Draws a circle based on centre_x, centre_y, and radius input. Uses the Bresenham circle drawing algorithm.
*/

//define for states
`define state_reset 3'b000
`define state_draw 3'b001
`define state_done 3'b010

module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);

     // count regs for detemrining which octant to draw
     reg [2:0] count;
     reg [2:0] next_count;

     //circle algorithm regs
     reg signed [8:0] offset_x, next_offset_x;
     reg signed [8:0] offset_y, next_offset_y;
     reg signed [8:0] crit, next_crit;

     //state machine state regs
     reg [2:0] present_state;
     reg [2:0] next_state;

     //flags
     reg increment_flag;
     reg reset_flag;
     
     //local regs to handle signed values 
     reg signed [8:0] x_position, signed_centre_x;
     reg signed [8:0] y_position, signed_centre_y;

     //set colour 
     assign vga_colour = colour;

     assign signed_centre_x = centre_x;
     assign signed_centre_y = centre_y;

     assign vga_x = x_position[7:0];
     assign vga_y = y_position[6:0];

     //next state logic
     always_comb begin
          case(present_state)
          
          `state_reset: next_state = `state_draw;
          `state_draw: begin 
               //if offset_y is less than offset_x, then keep drawing
               if (offset_y <= offset_x)
                    next_state = `state_draw;
               else
                    next_state = `state_done;
          end
          `state_done: next_state = `state_done;
          
          default: next_state = 3'bxxx;
          
          endcase
     end


     //sequential block
     always_ff @(posedge clk) begin 
          //resetting all control regs
          if (!rst_n) begin
               present_state <= `state_reset;
               reset_flag <= 1'b1;
               offset_y <= 9'b0;
               offset_x <= radius;
               crit <= 9'sd1 - $signed(radius);
               count <= 3'd0;      
          end
          //set new value of offsets and crit on clock edge
          else if (start) begin
               present_state <= next_state;
               reset_flag <= 1'b0;
               offset_x <= next_offset_x;
               offset_y <= next_offset_y;
               crit <= next_crit;
               count <= next_count;
          end
     end


     //output logic 
     always_comb begin 
          
          case(present_state)
               `state_reset:begin 
                    next_count = 1'b0;
                    x_position = signed_centre_x + offset_x;
                    y_position = signed_centre_y + offset_y;
                    increment_flag = 1'b0;
                    done = 1'b0;
               end
               
               `state_draw: begin
                    case (count) 
                         //octant 1 
                         3'b000: begin 
                              x_position = signed_centre_x + offset_x;
                              y_position = signed_centre_y + offset_y;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 2 
                         3'b001: begin
                              x_position = signed_centre_x + offset_y;
                              y_position = signed_centre_y + offset_x;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 3 
                         3'b010: begin 
                              x_position = signed_centre_x - offset_x;
                              y_position = signed_centre_y + offset_y;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 4 
                         3'b011: begin
                              x_position = signed_centre_x - offset_y;
                              y_position = signed_centre_y + offset_x;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 5 
                         3'b100: begin 
                              x_position = signed_centre_x - offset_x;
                              y_position = signed_centre_y - offset_y;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 6 
                         3'b101: begin
                              x_position = signed_centre_x - offset_y;
                              y_position = signed_centre_y - offset_x;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 7 
                         3'b110: begin 
                              x_position = signed_centre_x + offset_x;
                              y_position = signed_centre_y - offset_y;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 8 
                         3'b111: begin
                              x_position = signed_centre_x + offset_y;
                              y_position = signed_centre_y - offset_x;

                              //do increment logic during last octant 
                              increment_flag = 1'b1;
                         end
                         default: begin
                              x_position = 9'bxxxxxxxxx;
                              y_position = 9'bxxxxxxxxx;

                              increment_flag = 1'bx;
                         end
                    endcase
                    
                    //increment count for traversing octants
                    next_count = count + 3'd1;
                    done = 1'b0;
               end
              
               `state_done: begin
                    
                    if (start == 1'b1)
                         done = 1'b1;
                    else 
                         //deassert done
                         done = 1'b0;
                    
                    x_position = signed_centre_x + offset_x;
                    y_position = signed_centre_y + offset_y;
                    
                    increment_flag = 1'b0;
                    next_count = 3'b0;
               end

          endcase

     end


     //combinational block for Bresenham circle drawing algorithm increment logic 
     always_comb begin

          //hold old value if no incrememnt needed
          next_offset_x = offset_x;
          next_offset_y = offset_y;
          next_crit = crit;

          if (reset_flag) begin 
               //initialize
               next_offset_y = 9'sd0;
               next_offset_x = radius;
               next_crit = 9'sd1 - $signed(radius);               
          end

          else if (increment_flag == 1'b1)begin 

               //increments offsets and crit in the final octant
               next_offset_y = offset_y + 9'sd1;
               
               if (crit <= 9'sd0)
                    next_crit = crit + 9'sd2 * $signed(next_offset_y) + 9'sd1;
               else begin 
                    next_offset_x = offset_x - 9'sd1;
                    next_crit = crit + 9'sd2 * ($signed(next_offset_y) - $signed(next_offset_x)) + 9'sd1;
               end
          end
     end
     

     //combinational block for deciding when to plot 
     always_comb begin

          //if position is outside the screen do not plot
          if (x_position < 9'sd0 || x_position > 9'sd159)
               vga_plot = 1'b0;
          else if (y_position < 9'sd0 || y_position > 9'sd119)
               vga_plot = 1'b0;
          //if reset or circle is done drawing do not plot
          else if (reset_flag == 1'b1 || done == 1'b1)
               vga_plot = 1'b0;
          else 
               vga_plot = 1'b1;

     end

endmodule

