/*
CPEN311 Lab 2: Circles and Triangles
Ansh Madaan (8399574) & Rishi Upath (18259374)
October 27, 2025

Reuleaux Module
Purpose: Draws reuleaux triangle using a modified version of the Bresenham algorithm based on input of center position and diameter. 
          Works by setting the centers based on 3 intersecting circles and clipping any unwanted pixels.
*/

//define for states
`define state_reset 3'b000
`define state_draw 3'b001
`define state_done 3'b010


module reuleaux(input logic clk, input logic rst_n, input logic [2:0] colour,
                input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] diameter,
                input logic start, output logic done,
                output logic [7:0] vga_x, output logic [6:0] vga_y,
                output logic [2:0] vga_colour, output logic vga_plot);

     //count regs for determining which octant to draw
     reg [2:0] count;
     reg [2:0] next_count;

     //circle algrothim regs
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
     
     //position
     reg signed [8:0] x_position;
     reg signed [8:0] y_position;
     
     //centres of 3 circles
     logic signed [8:0] top_centre_x, left_centre_x, right_centre_x;
     logic signed [8:0] top_centre_y, left_centre_y, right_centre_y;
     
     //temporary reg for square root values
     logic [16:0] sqrt_temp1, sqrt_temp2;
     
     //sqrt(3)/6 * 2^10   
     assign sqrt_temp1 = (diameter * 17'd296 + 17'd512) >> 10;
     //sqrt(3)/3 * 2^10
     assign sqrt_temp2 = (diameter * 17'd591 + 17'd512) >> 10;
     
     //assigning centre coordinates
     assign right_centre_x = centre_x + (diameter >> 1);
     assign right_centre_y = centre_y + sqrt_temp1[8:0];
     assign left_centre_x = centre_x - (diameter >> 1);
     assign left_centre_y = centre_y + sqrt_temp1[8:0];
     assign top_centre_x = centre_x;
     assign top_centre_y = centre_y - sqrt_temp2[8:0];

     assign vga_x = x_position[7:0];
     assign vga_y = y_position[6:0];

     //set colour 
     assign vga_colour = colour;

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
               offset_x <= diameter;
               crit <= 9'sd1 - $signed(diameter);
               count <= 3'd0;      
          end
          //set new value of offsets and crit on clock edge
          else if (start) begin
               present_state <= next_state;
               reset_flag <= 1'b0;
               //assign next value of offsets and crit on clock edge
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
                    x_position = left_centre_x + offset_x;
                    y_position = left_centre_y + offset_y;
                    increment_flag = 1'b0;
                    done = 1'b0;
               end
               
               `state_draw: begin
                    case (count) 
                         // octant 8 - left circle
                         3'b000: begin 
                              x_position = left_centre_x + offset_x;
                              y_position = left_centre_y - offset_y;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 7 - left circle
                         3'b001: begin
                              x_position = left_centre_x + offset_y;
                              y_position = left_centre_y - offset_x;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 6 - right circle
                         3'b010: begin 
                              x_position = right_centre_x - offset_y;
                              y_position = right_centre_y - offset_x;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 5 - right circle
                         3'b011: begin
                              x_position = right_centre_x - offset_x;
                              y_position = right_centre_y - offset_y;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 3 - top circle
                         3'b100: begin
                              x_position = top_centre_x - offset_y;
                              y_position = top_centre_y + offset_x;
                              
                              increment_flag = 1'b0;
                         end
                         //octant 2 - top circle
                         3'b101: begin 
                              x_position = top_centre_x + offset_y;
                              y_position = top_centre_y + offset_x;
                              
                              //do increment logic during last octant
                              increment_flag = 1'b1;
                         end
                         default: begin
                              x_position = 9'bxxxxxxxxx;
                              y_position = 9'bxxxxxxxxx;

                              //do increment logic 
                              increment_flag = 1'bx;
                         end
                    endcase
                    
                    //resetting count
                    if (count >= 3'd5)
                         next_count = 3'd0;
                    else
                         //increment count
                         next_count = count + 3'd1;
                    
                    done = 1'b0;
               end
              
               `state_done: begin
                    
                    if (start == 1'b1)
                         done = 1'b1;
                    else 
                         //deasseert done
                         done = 1'b0;
                    
                    x_position = top_centre_x + offset_x;
                    y_position = top_centre_y + offset_y;
                    
                    increment_flag = 1'b0;
                    next_count = 3'b0;
               end

          endcase

     end


     //combinational block for Bresenham circle drawing algorithm increment logic
     always_comb begin

          //hold old value if no increment needed
          next_offset_x = offset_x;
          next_offset_y = offset_y;
          next_crit = crit;

          if (reset_flag) begin 

               //initialize
               next_offset_y = 9'sd0;
               next_offset_x = diameter;
               next_crit = 9'sd1 - $signed(diameter);
               
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
          //thresholds for reuleaux triangle based on which octacts are being drawn
          else if (count == 0 || count == 1) begin
               //left circle
               if ((x_position > right_centre_x) || (x_position < top_centre_x ) || (y_position < top_centre_y) || (y_position > right_centre_y)) 
                    vga_plot = 1'b0;
               else 
                    vga_plot = 1'b1;
          end
          else if (count == 2 || count == 3) begin
               //right circle
               if ((x_position > top_centre_x) || (x_position < left_centre_x ) || (y_position < top_centre_y) || (y_position > left_centre_y)) begin
                    vga_plot = 1'b0;
               end
               else
                    vga_plot = 1'b1;
          end
          else if (count == 4 || count == 5) begin
               //top circle
               if ((x_position > right_centre_x) || (x_position < left_centre_x) || (y_position < right_centre_y)) begin
                    vga_plot = 1'b0;
               end
               else 
                    vga_plot = 1'b1;
          end
          else 
               vga_plot = 1'b1;

     end

endmodule

