module datapath_tb(); // testbench for the datapath (mostly the same as lab5)

  reg sim_asel, sim_bsel, sim_clk, sim_loada, sim_loadb, sim_loadc, sim_loads, sim_write, err; //sim inputs and outputs from 
  reg [1:0] sim_ALUop, sim_shift, sim_vsel;
  reg [15:0] sim_mdata, sim_sximm5, sim_sximm8;
  reg [2:0] sim_writenum, sim_readnum;
  wire [2:0] sim_status_out;
  wire [15:0] sim_C;
  reg [7:0] sim_PC;

  // the module we are testbenching
  datapath DUT(.asel(sim_asel),.bsel(sim_bsel),.vsel(sim_vsel),.clk(sim_clk),.loada(sim_loada),.loadb(sim_loadb),.loadc(sim_loadc),.loads(sim_loads),.write(sim_write),
               .ALUop(sim_ALUop),. shift(sim_shift),.mdata(sim_mdata),.writenum(sim_writenum),.readnum(sim_readnum),.status_out(sim_status_out),.C(sim_C),.sximm5(sim_sximm5),.sximm8(sim_sximm8),.PC(sim_PC));

  task check_r; // task to check register
    input [15:0] expected_data_out;
    begin
      if (datapath_tb.DUT.data_out !== expected_data_out) begin
        err = 1;
        $display("ERROR, data_out is %b, expected %b", datapath_tb.DUT.data_out, expected_data_out);
    end
    end
  endtask

  task check_loada; // task to check the load value of A
    input [15:0] expected_Aout;
    begin
      if (datapath_tb.DUT.Aout !== expected_Aout) begin
        err = 1;
        $display("ERROR, Aout is %b, expected %b", datapath_tb.DUT.Aout, expected_Aout);
    end
    end
  endtask

  task check_loadb; // task to check the load value of B
    input [15:0] expected_in;
    begin
      if (datapath_tb.DUT.in !== expected_in) begin
        err = 1;
        $display("ERROR, in is %b, expected %b", datapath_tb.DUT.in, expected_in);
    end
    end
  endtask

  task check_loadc; // task to check the load value of C which is the final output
    input [15:0] expected_C;
    begin
      if (sim_C !== expected_C) begin
        err = 1;
        $display("ERROR, C is %b, expected %b", sim_C, expected_C);
    end
    end
  endtask

  initial begin // initial block for clock
    sim_clk = 0;
    #5;
    forever begin
      sim_clk = 1;
      #5;
      sim_clk = 0;
      #5;
    end
  end

  initial begin // main initial block
    err = 0; 

    sim_sximm8 = 16'sd7; // storing 7 into register 0
    sim_vsel = 2'b01;
    sim_writenum = 3'd0;
    sim_write = 1;
    #10;
    sim_sximm8 = 16'sd2; // storing 2 into register 1
    sim_vsel = 2'b01;
    sim_writenum = 3'd1;
    sim_write = 1;
    #10;
    
    sim_readnum = 3'd0; // loading register 0 into B
    sim_loada = 0;
    sim_loadb = 1;
    #10;
    
    $display("checking in");
    check_loadb(16'sd7);

    sim_readnum = 3'd1; // loading register 1 into A 
    sim_loada = 1;
    sim_loadb = 0;
    #10;
    
    $display("checking Aout"); 
    check_loada(16'sd2);

    sim_shift = 2'b01; // performing the execute stage by multiplying 7 by 2 (shift) and adding
    sim_asel = 0;
    sim_bsel = 0;
    sim_ALUop = 2'b00;
    sim_loadc = 1;
    #10;
    
    $display("checking C"); 
    check_loadc(16'sd16);

    sim_vsel = 2'b11; // storing back the output value, 16, into another register, R2
    sim_writenum = 3'd2;
    sim_write = 1;
    sim_readnum = 3'd2;
    #10;
    $display("checking r2");
    check_r(16'sd16);
    

    
    
    
$stop;
  end

  

endmodule: datapath_tb
