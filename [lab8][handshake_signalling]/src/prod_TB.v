module prod_TB;
  reg clk;
  reg rst_b;
  wire val;
  wire [7:0] data;

  localparam CLK_PERIOD = 100, RST_DURATION = 25, RUNNING_CYCLES = 100;

  prod inst (.clk(clk), .rst_b(rst_b), .val(val), .data(data));

  // generating clock signal;
  initial
  begin
    clk = 0;
    repeat (RUNNING_CYCLES * 2) #(CLK_PERIOD / 2) clk = ~clk;
  end

  // generating reset signal;
  initial
  begin
    rst_b = 0;
    #RST_DURATION rst_b = 1;
  end
endmodule
