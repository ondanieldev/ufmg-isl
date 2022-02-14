module d_flip_flop (
  input d, clk,
  output reg q, qbar
);

  always @(posedge clk) begin
    q = d;
    qbar = ~q;
  end
  
endmodule