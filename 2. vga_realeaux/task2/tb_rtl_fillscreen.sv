/*
CPEN311 Lab 2: Circles and Triangles
Ansh Madaan (8399574) & Rishi Upath (18259374)
October 27, 2025

Fillscreen RTL testbench module
Purpose: RTL testbench for fillscreen module, tests x and y positions, colour, plot, and done for every pixel plotted

*/

module tb_rtl_fillscreen();
    reg tb_clk, tb_rst_n, tb_start, tb_done;
    reg [2:0] tb_colour;
    wire [6:0] tb_vga_y;
    wire [7:0] tb_vga_x;
    wire [2:0] tb_vga_colour;
    wire tb_vga_plot;
    reg err;

    //instantiate fillscreen
    fillscreen DUT(.clk(tb_clk), .rst_n(tb_rst_n), .colour(tb_colour),
                   .start(tb_start), .done(tb_done),
                   .vga_x(tb_vga_x), .vga_y(tb_vga_y),
                   .vga_colour(tb_vga_colour), .vga_plot(tb_vga_plot));

    //task checker for fillscreen, checks x and y position, colour, vga plot, and done
    task fillscreen_checker;
        
        //signals that are being checked
        input [7:0] x_expected;
        input [6:0] y_expected;
        input [2:0] colour_expected;
        input vga_plot_expected;
        input done_expected;

        begin
            //check signals and display error if not equal
            if (tb_rtl_fillscreen.DUT.vga_x != x_expected) begin
                $display("ERROR, x position is %b, expected %b", tb_rtl_fillscreen.DUT.vga_x, x_expected);
                err = 1'b1;
            end
            if (tb_rtl_fillscreen.DUT.vga_y != y_expected) begin
                $display("ERROR, y position is %b, expected %b", tb_rtl_fillscreen.DUT.vga_y, y_expected);
                err = 1'b1;
            end
            if (tb_rtl_fillscreen.DUT.vga_colour != colour_expected) begin
                $display("ERROR, colour is %b, expected %b", tb_rtl_fillscreen.DUT.vga_colour, colour_expected);
                err = 1'b1;
            end
            if (tb_rtl_fillscreen.DUT.vga_plot != vga_plot_expected) begin
                $display("ERROR, vga_plot is %b, expected %b", tb_rtl_fillscreen.DUT.vga_plot, vga_plot_expected);
                err = 1'b1;
            end
            if (tb_rtl_fillscreen.DUT.done != done_expected) begin
                $display("ERROR, done is %b, expected %b", tb_rtl_fillscreen.DUT.done, done_expected);
                err = 1'b1;
            end

        end
    endtask
    
    //initializing CLOCK_50 for each pixel    
    initial begin
        tb_clk = 1'b0; #10;
        //Cycle clock for 50MHz
        forever begin
            tb_clk = 1'b1; #10;
            tb_clk = 1'b0; #10;
        end

    end

    initial begin
        err = 1'b0;

        //assert reset
        tb_rst_n = 1'b0; #20;
        tb_rst_n = 1'b1; #5;

        //Check if reset initializes values
        fillscreen_checker(8'd0, 7'd0, 3'b000, 1'b1, 1'b0);

        //start filling screen
        tb_start = 1'b1; #10;

        $display("Start time is, %0t", $time);
        //check position and colour of every pixel as well as correct plot signal
        for (integer i = 0; i <= 159; i++) begin
            for (integer j = 0; j <= 119; j++) begin 
                //account for extra increment of y after reset
                if (i == 0 && j == 0) 
                    j++;

                $display("Start time is, %0t", $time);
                fillscreen_checker(i, j, (i % 8), 1'b1, 1'b0);
                #20;

            end 
        end

        //check if done is high and plot is low 
        $display("Start time is, %0t", $time);
        fillscreen_checker(8'd159, 7'd119, 3'b111, 1'b0, 1'b1);
        #20;
        
        //display message if cases passed or failed
        if (~err)
            $display("All cases PASSED :)");
        else 
            $display("Some cases FAILED :(");

        $stop;

    end

    

endmodule: tb_rtl_fillscreen
