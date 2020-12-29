module dec #(
  parameter w = 3
  )(
  input [w-1:0] s,
  input we,
  output reg [2**w-1:0] o
  );
  
  always @(*)
  begin
    o = 0;
    if (we)
      o [s] = 1'b1;
  end
endmodule