module sha2ipudpath_TB;
  reg clk;
  reg rst_b;
  reg clr;
  reg [63:0] pkt;
  reg st_pkt; // store packet line;
  reg pad_pkt;
  reg zero_pkt;
  reg mgln_pkt;
  wire [511:0] blk;
  wire [2:0] idx;
  
  // instancing sha2ipudpath module;
  sha2ipudpath  sha2ipudpath_inst(.clk(clk), .rst_b(rst_b), .clr(clr), .pkt(pkt), .st_pkt(st_pkt), .pad_pkt(pad_pkt), .zero_pkt(zero_pkt), .mgln_pkt(mgln_pkt), .blk(blk), .idx(idx));
  
  localparam CLK_PERIOD = 100;
  localparam RUNNING_CYCLES = 40;
  localparam RST_DURATION = 25;
  
  // monitoring the changes in the variables;
  initial
  begin
     $monitor("t=%3d, clk=%b, rst_b=%d, clr=%b, pkt=%h, st_pkt=%3d, pad_pkt=%b, zero_pkt=%d, mgln_pkt=%b, blk=%h, idx=%2d", $time, clk, rst_b, clr, pkt, st_pkt, pad_pkt, zero_pkt, mgln_pkt, blk, idx);
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
    #(CLK_PERIOD*5) clr = 1'b0;
    #(CLK_PERIOD*28/5) clr = 1'b0;
  end
  
  // generating store packet signal;
  initial
  begin
    st_pkt = 0;
    #(CLK_PERIOD*7) st_pkt = 1'b1;
    #(CLK_PERIOD*29/7) st_pkt = 1'b0;
  end
  
  // task for generating 64bit random values; - TASKS MUST BE PLACED INSIDE MODULES;
  task urand64(output reg [63:0] r);
    begin
      r [63:32] = $urandom();
      r [31:0] = $urandom();
    end
  endtask
  
  // generate random input packets using the 64bit random number generating task;
  initial
  begin
    #(CLK_PERIOD/4) // this is necessary, or else the IPU will always take in the previous value because of propagation times;
    urand64(pkt);
    repeat (RUNNING_CYCLES*2) #(CLK_PERIOD/2) urand64(pkt);
  end
  
  // generating all the possible combinations of entries;
  integer i; // must be declared outside the initial block, else the block must be named;
  initial
  begin
    #(CLK_PERIOD/4) // this is necessary, or else the IPU will always take in the previous value because of propagation times;
    {pad_pkt, zero_pkt, mgln_pkt} = 3'b0;
    for (i = 0; i < RUNNING_CYCLES*2; i = i+1)
    begin
      #(CLK_PERIOD) {pad_pkt, zero_pkt, mgln_pkt} = (i%4 == 3) ? (3'b0) : (1 << (i%4));
    end
  end
endmodule