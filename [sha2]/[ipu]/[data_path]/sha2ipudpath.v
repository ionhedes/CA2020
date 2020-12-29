module sha2ipudpath (
  input clk,
  input rst_b,
  input clr,
  input [63:0] pkt,
  input st_pkt, // store packet line;
  input pad_pkt,
  input zero_pkt,
  input mgln_pkt,
  output [511:0] blk,
  output [2:0] idx
  );

  // necessary wires to create links inside the module;
  wire [63:0] pktmux_out;
  wire [2:0] cntr_out;
  wire [63:0] rgst_out;

  // necessary instances;
  pktmux #(.w(64)) pktmux_inst(.pad_pkt(pad_pkt), .zero_pkt(zero_pkt), .mgln_pkt(mgln_pkt), .pkt(pkt), .msg_len(rgst_out), .o(pktmux_out));
  rgst #(.w(64)) rgst_inst(.clk(clk), .rst_b(rst_b), .clr(clr), .ld(st_pkt & ~(pad_pkt | zero_pkt | mgln_pkt)), .d(rgst_out + 64), .q(rgst_out));
  cntr #(.w(3)) cntr_inst(.clk(clk), .rst_b(rst_b), .clr(clr), .c_up(st_pkt), .q(cntr_out));
  regfl #(.w(3), .rgst_w(64)) regfl_inst(.clk(clk), .rst_b(rst_b), .we(st_pkt), .d(pktmux_out), .s(cntr_out), .q(blk));

  // assigning remaining port;
  assign idx = cntr_out;
endmodule
