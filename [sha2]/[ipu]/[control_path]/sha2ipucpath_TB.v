module sha2ipucpath_TB;
  reg clk;
  reg rst_b;
  reg lst_pkt;
  reg [2:0] idx;
  wire st_pkt;
  wire pad_pkt;
  wire zero_pkt;
  wire mgln_pkt;
  wire blk_val;
  wire msg_end;
  
  // instancing UUT module;
  sha2ipucpath sha2ipucpath_inst(.clk(clk), .rst_b(rst_b), .lst_pkt(lst_pkt), .idx(idx), .st_pkt(st_pkt), .pad_pkt(pad_pkt), .zero_pkt(zero_pkt), .mgln_pkt(mgln_pkt), .blk_val(blk_val), .msg_end(msg_end));
  
  localparam CLK_DURATION = 100;
  localparam RUNNING_CYCLES = 30;
  localparam RST_DURATION = 25;
  
  // generating clock signal;
  initial
  begin
    clk = 1'b0;
    repeat (RUNNING_CYCLES*2) #(CLK_DURATION/2) clk = ~clk;
  end
  
  // generating asynchronous reset signal;
  initial
  begin
    rst_b = 1'b0;
    #RST_DURATION rst_b = 1'b1;
  end
  
  // generating dummy signal for the current writing index in the register file;
  initial
  begin
    idx = 1'b0;
    repeat (RUNNING_CYCLES) #(CLK_DURATION) idx = idx+1;
  end
  
  // generating dummy signal for the last packet flag, provided by the message deliverer;
  initial
  begin
    lst_pkt = 1'b0;
    #(CLK_DURATION*8) lst_pkt = 1'b1;
    #(CLK_DURATION*9) lst_pkt = 1'b0;
  end
endmodule
    