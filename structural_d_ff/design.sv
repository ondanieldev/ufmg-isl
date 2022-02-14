module d_flip_flop (
  input d, clk,
  output q, qbar
);
  wire dbar, t1, t2;
  
  not u0 (dbar, d);
  and u1 (t1, dbar, clk);
  and u2 (t2, d, clk);
  nor u3 (q, t1, qbar);
  nor u4 (qbar, t2, q);
  
endmodule