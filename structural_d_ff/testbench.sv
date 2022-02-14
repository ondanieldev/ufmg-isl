`timescale 1ns/100ps

module d_flip_flop_tb();
  
  reg d_tb, clk_tb;
  wire q_tb, qbar_tb;
  
  d_flip_flop dff (d_tb, clk_tb, q_tb, qbar_tb);

  initial begin
  	clk_tb = 0;
  end
  
  always begin
    #10
    clk_tb = ~clk_tb;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
 
    d_tb = 0;
    
    #100
    d_tb = 1;
    
    #100
    d_tb = 0;
    
    #100
    d_tb = 1;
    
    #100
    $finish;
  end
  
endmodule