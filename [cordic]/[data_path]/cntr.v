module cntr #(
  parameter w = 3,
  parameter iv = {w{1'b0}}
  )(
  input clk,
  input rst_b,
  input clr,
  input c_up,
  output reg [w-1:0] q
  );
  
  always @(posedge clk, negedge rst_b)
  begin
    if (!rst_b)
      q <= iv;
    else if (clr)
      q <= iv;
    else if (c_up)
      q <= q + 1;
  end
endmodule