module cordicdpath_TB;
  reg clk;
  reg rst_b;
  reg [15:0] theta;
  reg bgn;
  wire fin;
  wire [15:0] cos;
  
  cordicdpath cordicdpath_inst(.clk(clk), .rst_b(rst_b), .theta(theta), .bgn(bgn), .fin(fin), .cos(cos));
  
  localparam CLK_PERIOD = 100;
  localparam RUNNING_CYCLES = 30;
  localparam RST_DURATION = 25;
  
  // generate clock signal;
  initial
  begin
    clk = 0;
    repeat (RUNNING_CYCLES*2) #(CLK_PERIOD/2) clk = ~clk;
  end
  
  // generate reset signal;
  initial
  begin
    rst_b = 0;
    #(RST_DURATION) rst_b = 1;
  end
  
  // generate a theta signal;
  initial
  begin
    theta = 16'h31EB; // approximately pi/4 when converted to an integer format;
    /**
     * theta = 0.78 ~= pi/4;
     * {0.78}_b10 ~= {0(s) 0.1100 0111 1010 11}_b2 <- verilog will see this value as integer {0(s) 011 0001 1110 1011}_b2;
     * 
     * cos(theta) = {0(s) 010 1111 1101 0010}_b2 (as seen by verilog) <- true value {0(s) 0.1011 1111 0100 00}_b2;
     * {0(s) 0.1011 1111 0100 00}_b2 ~= {0.747}_b10;
     * cos(pi/2) ~= 0.707; 
     * it works ok-ish!
     */
  end
  
  // generate a begin signal;
  initial
  begin
    bgn = 1'b0;
    #(CLK_PERIOD*3) bgn = 1'b1;
    #(CLK_PERIOD*3) bgn = 1'b0;
  end
endmodule