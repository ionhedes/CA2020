module rgst #(
  parameter w = 8,
  parameter iv = {w {1'b0}}
  )(
  input clk,
  input rst_b,
  input clr,
  input ld,
  input [w-1:0] d,
  output reg [w-1:0] q
  );
  
  always @(posedge clk, negedge rst_b)
  begin
    if (!rst_b)
      q <= iv;
    else if (clr)
      q <= iv;
    else if (ld)
      q <= d;
  end
endmodule
  