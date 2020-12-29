module regfl #(
  parameter w = 3,
  parameter rgst_w = 64
  )(
  input clk,
  input rst_b,
  input we,
  input [rgst_w-1:0] d,
  input [w-1:0] s,
  output [2**w * rgst_w - 1:0] q
  );
    
    
  wire [2**w-1:0] o; // internal output for address selector decoder;
  dec #(.w(w)) dec_inst (.s(s), .we(we), .o(o)); // instancing the decoder;
  
  generate // instancing the registers in the file;
    genvar i;
    for (i = 0; i < 2**w; i = i+1)
    begin: rgst_vect
      rgst #(.w(rgst_w)) rgst_inst(.clk(clk), .rst_b(rst_b), .clr(1'b0), .ld(o [i]), .d(d), .q(q [(2**w - i)*rgst_w - 1:(2**w - i - 1)*rgst_w]));
    end
  endgenerate
endmodule
      