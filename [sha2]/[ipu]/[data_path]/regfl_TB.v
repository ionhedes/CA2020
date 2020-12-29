module regfl_TB;
  reg clk;
  reg rst_b;
  reg we;
  reg [63:0] d;
  reg [2:0] s;
  wire [511:0] q;
  
  // instance the unit under test (UUT) regfl;
  regfl #(.w(3), .rgst_w(64)) regfl_inst(.clk(clk), .rst_b(rst_b), .we(we), .d(d), .s(s), .q(q));
  
  localparam CLK_PERIOD = 100;
  localparam RUNNING_CYCLES = 20;
  localparam RST_DURATION = 25;
  
  // print values of the ports when they change;
  initial
  begin
    $monitor("t=%3d, clk=%b, rst_b=%d, we=%b, d=%4h, s=%d, q=%4h", $time, clk, rst_b, we, d, s, q);
  end

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
  
  // generate write enable signal;
  initial
  begin
    we = 1;
    repeat (RUNNING_CYCLES/4) #(CLK_PERIOD*2) we = ~we;
  end
  
  // task for generating 64bit random values; - TASKS MUST BE PLACED INSIDE MODULES;
  task urand64(output reg [63:0] r);
    begin
      r [63:32] = $urandom();
      r [31:0] = $urandom();
    end
  endtask
  
  // generate input vectors using the 64bit random number generating task;
  initial
  begin
    urand64(d);
    repeat (RUNNING_CYCLES*2) #(CLK_PERIOD/2) urand64(d);
  end
    
  // generate select signal;
  initial
  begin
    s = 0;
    repeat (RUNNING_CYCLES * 2) #(CLK_PERIOD/2) s = s+1;
  end
endmodule
  
  