module rom #(
  parameter aw = 10,
  parameter dw = 8,
  parameter iv = {dw{1'b0}},
  parameter file = "rom_file_with_hex_content.txt"
  )(
  input clk,
  input rst_b,
  input [aw - 1:0] addr,
  output reg [dw - 1:0] data
  );
  
  reg [dw - 1:0] mem [0:2**aw-1];
  
  initial
  begin
    $readmemh(file, mem, 0, 2**aw-1);
  end
  
  always @(posedge clk, negedge rst_b)
  begin
    if (!rst_b)
      data <= iv;
    else
      data <= mem [addr];
  end
endmodule