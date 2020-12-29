// Macros defined for conciseness when dealing with difficul to read part-select operators;
`define WORD(SIGNAL, INDEX) \
  SIGNAL[511-32*(INDEX):480-32*(INDEX)]

`define M(INDEX) \
  WORD(m, INDEX)
  
module msgsch (
  input clk,
  input rst_b,
  input [511:0] blk,
  input ld_mreg,
  input upd_mreg,
  output [31:0] m0
  );
  
  // auxilliary functions for generating new_word; 
  function [31:0] TurnR(input [31:0] x, input [4:0] p);
    reg [63:0] tmp;
    begin
      tmp = {x, x} >> p;
      TurnR = tmp [31:0];
    end
  endfunction

  function [31:0] ShiftR(input [31:0] x, input [4:0] p);
    ShiftR = x >> p;
  endfunction

  function [31:0] Sigma0(input [31:0] x);
    Sigma0 = TurnR(x, 7) ^ TurnR(x, 18) ^ ShiftR(x, 3);
  endfunction

  function [31:0] Sigma1(input [31:0] x);
    Sigma1 = TurnR(x, 17) ^ TurnR(x, 19) ^ ShiftR(x, 10);
  endfunction
  
  // necessary interconnections;
  wire [511:0] m;
  wire [511:0] mux_out;
  wire [31:0] new_word;
  
  // generating all the layers of MUX+RGST;
  // The right most layer is generated separately, because its ports are different from the rest;
  generate
    genvar i;
    for (i = 0; i < 15; i = i+1)
    begin: inst
      mux #(.sw(1), .inw(64)) mux_inst(.i({WORD(blk, i), M(i+1)}), .s(ld_mreg), .o(WORD(mux_out, i)));
      rgst #(.w(32)) rgst_inst(.clk(clk), .rst_b(rst_b), .clr(1'b0), .ld(upd_mreg), .d(WORD(mux_out, i)), .q(M(i)));
    end
  endgenerate
  mux #(.sw(1), .inw(64)) mux_inst_rmost(.i({WORD(blk, 15), new_word}), .s(ld_mreg), .o(WORD(mux_out, 15)));
      rgst #(.w(32)) rgst_inst_rmost(.clk(clk), .rst_b(rst_b), .clr(1'b0), .ld(upd_mreg), .d(WORD(mux_out, 15)), .q(M(15)));
  
  assign new_word = M(0) + Sigma0(M(1)) + M(9) + Sigma1(M(14));
  assign m0 = M(0);
endmodule