module cntr_TB;
  reg clk;
  reg rst_b;
  reg clr;
  reg c_up;
  wire [2:0] q;
  
  cntr #(.w(3)) cntr_inst(.clk(clk), .rst_b(rst_b), .clr(clr), .c_up(c_up), .q(q));
  
  localparam CLK_PERIOD = 100;
  localparam RUNNING_CYCLES = 20;
  localparam RST_DURATION = 25;
  
  // monitoring the changes in the variables;
  initial
  begin
     $monitor("t=%3d, clk=%b, rst_b=%d, clr=%b, c_up=%b, q=%3d", $time, clk, rst_b, clr, c_up, q);
  end
  
  // generating clock signal;
  initial
  begin
    clk = 1'b0;
    repeat (RUNNING_CYCLES*2) #(CLK_PERIOD/2) clk = ~clk;
  end
  
  // generating reset signal;
  initial
  begin
    rst_b = 1'b0;
    #(RST_DURATION) rst_b = 1'b1;
  end
  
  // generating synchronous clear signal;
  initial
  begin
    clr = 0;
    #(CLK_PERIOD*5) clr = 1'b1;
    #(CLK_PERIOD*28/5) clr = 1'b0;
  end
  
  // generating count up signal;
  initial
  begin
    c_up = 1'b1;
    #(CLK_PERIOD*3) c_up = 1'b0;
    #(CLK_PERIOD*10/3) c_up = 1'b1;
  end
endmodule