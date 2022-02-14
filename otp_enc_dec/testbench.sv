`timescale 1ns/100ps

module otp_enc_dec_tb;

  localparam LFSR_SIZE = 8, MSG_SIZE = 104;
  
  // variables to control encoding/decoding
  reg [MSG_SIZE-1:0] enc_msg, dec_msg;
  integer i;
  
  // variables to instantiate LFSR
  reg clk, s0, s1;
  reg [LFSR_SIZE-1:0] key_seed;
  wire key_digit;

  // lfst module
  lfsr_8bit lfsr(.clk(clk), .s0(s0), .s1(s1), .in(key_seed), .r_out(key_digit));
  
  // pulse clock
  always begin
    #10
    clk = ~clk;
  end

  initial begin
    set_epwave;
    set_clock;

    // encode and decode "Hello, World!" using 11111111 as LFSR seed
    generate_key(8'b11111111);
    encode(104'b01001000011001010110110001101100011011110010110000100000010101110110111101110010011011000110010000100001);
    generate_key(8'b11111111);
    decode;
    show_result;
    
    // encode and decode "BH eh nóis!!" using 10101010 as LFSR seed
    generate_key(8'b10101010);
    encode(104'b01000010010010000010000001100101011010000010000001101110110000111011001101101001011100110010000100100001);
    generate_key(8'b10101010);
    decode;
    show_result;
    
    $finish;
  end

  // generate time diagram
  task set_epwave;
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  endtask 

  // initial clock value
  task set_clock;
    begin
      clk = 1'b0;
    end
  endtask
  
  // key generate strategy
  task generate_key(input [LFSR_SIZE-1:0] seed);
    begin
      s0 = 1'b1;
      s1 = 1'b1;
      key_seed = seed;
      #20
      s0 = 1'b0;
    end
  endtask
  
  // encode given message
  task encode(input [MSG_SIZE-1:0] msg);
    begin
      for (i = MSG_SIZE - 1; i >= 0; i = i - 1) begin
        #20
        enc_msg[i] = msg[i] ^ key_digit;
      end
    end
  endtask
  
  // decode previous encoded message
  task decode;
    begin
      for (i = MSG_SIZE - 1; i >= 0; i = i - 1) begin
        #20
        dec_msg[i] = enc_msg[i] ^ key_digit;
      end
    end
  endtask
  
  // print encoded and decoded messages
  task show_result;
    begin
      $display("\nEncoded message:\t%s", enc_msg);
      $display("Decoded message:\t%s", dec_msg);
    end
  endtask
  
endmodule
