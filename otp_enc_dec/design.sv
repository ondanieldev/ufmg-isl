/*
  @input clk (clock) -> LFSR just changes it state at positive edges of the clock
  @input clear -> when high, set all LFSR output to 1
  @input s0, s1 -> control if LFSR will load a new input or shift its output
  @input in (input) -> input to be loaded
  @output l_out (left out) -> returned value after shift left
  @output r_out (right out) -> returned value after shift right
  @output out -> full output
*/
module lfsr_8bit(
  clk,
  clear,
  s0,
  s1,
  in,
  l_out,
  r_out,
  out,
);
  localparam LFSR_SIZE = 8, MOST_SIGNIFICANT = 7, LEAST_SIGNIFICANT = 0, MAX = 8'b11111111;

  input clk, clear, s0, s1;
  input [LFSR_SIZE-1:0] in;
  output reg l_out, r_out;
  output reg [LFSR_SIZE-1:0] out;

  // l_in (left in) used when shifting right
  // r_in (right in) used when shifting left
  wire l_in, r_in;

  // assign new data while shifting
  assign l_in = (out[LEAST_SIGNIFICANT] ^ out[LEAST_SIGNIFICANT+1]);
  assign r_in = (out[MOST_SIGNIFICANT] ^ out[MOST_SIGNIFICANT-1]);

  // positive edge triggered
  always @(posedge clk) begin
    // set max value
    if (clear)
      out <= MAX;
    
    // load new input
    else if (s0 && s1) begin
      l_out <= in[MOST_SIGNIFICANT];
      r_out <= in[LEAST_SIGNIFICANT];
      out <= in;
    end
    
    // shift left
    else if (s0 && !s1) begin
      l_out <= out[MOST_SIGNIFICANT];
      out <= {out[MOST_SIGNIFICANT-1:LEAST_SIGNIFICANT], r_in};
    end
    
    // shift right
    else if (!s0 && s1) begin
      r_out <= out[LEAST_SIGNIFICANT];
      out <= {l_in, out[MOST_SIGNIFICANT:LEAST_SIGNIFICANT+1]};
    end
    
    // else keep as it is
  end

endmodule